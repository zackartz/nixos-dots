{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.gpu-passthru;

  startScript = ''
    #!/run/current-system/sw/bin/bash

    # Debugging
    exec 19>/home/zoey/Desktop/startlogfile
    BASH_XTRACEFD=19
    set -x

    # Load variables we defined
    source "/etc/libvirt/hooks/kvm.conf"

    # Change to performance governor
    echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

    # Isolate host to core 0
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-8
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-8
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-8

    # disable vpn
    mullvad disconnect -w

    # Logout
    # source "/home/owner/Desktop/Sync/Files/Tools/logout.sh"

    # Stop display manager
    systemctl stop display-manager.service
    killall gdm-wayland-session
    killall niri
    killall niri-session

    # Unbind VTconsoles
    echo 0 > /sys/class/vtconsole/vtcon0/bind
    echo 0 > /sys/class/vtconsole/vtcon1/bind

    # Unbind EFI Framebuffer
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

    # Avoid race condition
    sleep 5

    # Unload NVIDIA kernel modules
    modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

    # Detach GPU devices from host
    virsh nodedev-detach $VIRSH_GPU_VIDEO
    virsh nodedev-detach $VIRSH_GPU_AUDIO

    # Load vfio module
    modprobe vfio-pci
  '';

  stopScript = ''
    #!/run/current-system/sw/bin/bash

    # Debugging
    exec 19>/home/zoey/Desktop/stoplogfile
    BASH_XTRACEFD=19
    set -x

    # Load variables we defined
    source "/etc/libvirt/hooks/kvm.conf"

    # Unload vfio module
    modprobe -r vfio-pci

    # Attach GPU devices from host
    virsh nodedev-reattach $VIRSH_GPU_VIDEO
    virsh nodedev-reattach $VIRSH_GPU_AUDIO

    # Read nvidia x config
    nvidia-xconfig --query-gpu-info > /dev/null 2>&1

    # Load NVIDIA kernel modules
    modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia

    # Avoid race condition
    sleep 5

    # Bind EFI Framebuffer
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

    # Bind VTconsoles
    echo 1 > /sys/class/vtconsole/vtcon0/bind
    echo 1 > /sys/class/vtconsole/vtcon1/bind

    # Start display manager
    systemctl start display-manager.service

    # Return host to all cores
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-31

    # Change to powersave governor
    echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  '';
in {
  options.hardware.gpu-passthru = with types; {
    enable = mkBoolOpt false "Enable support for single gpu-passthru";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
    boot.kernelModules = ["vfio-pci"];

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };

    systemd.services.libvirtd = {
      path = let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            nixos-stable.mullvad
            killall
            sd
          ];
        };
      in [env];
    };

    system.activationScripts.libvirt-hooks.text = ''
      ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
    '';

    environment.systemPackages = with pkgs; [
      libguestfs-with-appliance
    ];

    environment.etc = {
      "/libvirt/hooks/qemu" = {
        text = ''
          #!/run/current-system/sw/bin/bash
          #
          # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
          #
          # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
          # After this file is installed, restart libvirt.
          # From now on, you can easily add per-guest qemu hooks.
          # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
          # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
          #

          GUEST_NAME="$1"
          HOOK_NAME="$2"
          STATE_NAME="$3"
          MISC="''${@:4}"

          BASEDIR="$(dirname $0)"

          HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

          set -e # If a script exits with an error, we should as well.

          # check if it's a non-empty executable file
          if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH"] && [ -x "$HOOKPATH" ]; then
              eval \"$HOOKPATH\" "$@"
          elif [ -d "$HOOKPATH" ]; then
              while read file; do
                  # check for null string
                  if [ ! -z "$file" ]; then
                    eval \"$file\" "$@"
                  fi
              done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
          fi
        '';
        mode = "0755";
      };

      "libvirt/hooks/kvm.conf" = {
        text = ''
          VIRSH_GPU_VIDEO=pci_0000_0B_00_0
          VIRSH_GPU_AUDIO=pci_0000_0B_00_1
        '';
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/win10/prepare/begin/start.sh" = {
        text = startScript;
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/win10/release/end/stop.sh" = {
        text = stopScript;
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/bazzite/prepare/begin/start.sh" = {
        text = startScript;
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/bazzite/release/end/stop.sh" = {
        text = stopScript;
        mode = "0755";
      };
    };
  };
}
