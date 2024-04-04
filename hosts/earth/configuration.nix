# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../common/default.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
    ../../env/wayland
    ({
      options,
      lib,
      ...
    }:
      lib.mkIf (options ? virtualisation.memorySize) {
        users.users.zack.password = "foo";
      })
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "earth"; # Define your hostname.

  networking.networkmanager.unmanaged = ["enp6s0"];

  boot.supportedFilesystems = ["ntfs"];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.

  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      notify_interval = 60;
      friendly_name = "ZACKPC";
      media_dir = ["/home/zack/Music"];
    };
  };

  # services.openssh = {
  #   enable = true;
  #   PasswordAuthentication = true;
  # };

  environment.systemPackages = with pkgs; [
    alvr
    BeatSaberModManager
  ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  programs.virt-manager.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
