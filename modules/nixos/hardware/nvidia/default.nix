{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.nvidia;
in {
  options.hardware.nvidia = with types; {
    enable = mkBoolOpt false "Enable drivers for nvidia hardware";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

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
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta.overrideAttrs {
      #   patchesOpen = with pkgs; [
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0001-Enable-atomic-kernel-modesetting-by-default.patch";
      #       hash = "sha256-tvdm8nxxXslPUun33zj1kkYZOiWKK3F4nwcCkdzPW9s=";
      #     })
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0002-Add-IBT-support.patch";
      #       hash = "sha256-JUT8FwBhyRhOWxwET7Zw/xkIl8g6UCLMXSTofr0OuSg=";
      #     })
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0003-Kbuild-Convert-EXTRA_CFLAGS-to-ccflags-y.patch";
      #       hash = "sha256-W+yyiK6TpEs9IACMr/0V7EIP++u7MPOfa9ko3w8Gqtc=";
      #     })
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0004-kernel-open-nvidia-Use-new-timer-functions-for-6.15.patch";
      #       hash = "sha256-T3SY2O6Pmc8BA0oana5xGGDhBxCizwmRqMyPvgF3j8A=";
      #     })
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0005-nvidia-uvm-Use-__iowrite64_hi_lo.patch";
      #       hash = "sha256-T8BNr1H1vgEQoKB0S5cqcbq6fSQxiDK9bb/MCvMtzTI";
      #     })
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0006-nvidia-uvm-Use-page_pgmap.patch";
      #       hash = "sha256-YucFZ2Z7YSgUiah82uLOmd4Z/c5YLOXxzEZNO6ZvQQg=";
      #     })
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0007-nvidia-uvm-Convert-make_device_exclusive_range-to-ma.patch";
      #       hash = "sha256-AehV7D+yYBmE8FWsUiagnjB8V7S8RJSTNcVMwZIgw/I=";
      #     })
      #     (fetchpatch {
      #       url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.14/misc/nvidia/0008-kbuild-Add-workaround-for-GCC-15-Compilation.patch";
      #       hash = "sha256-HrYBiAFy62Jll+ceVnGuJKGKDoaRObjAGIYa+yrAogA=";
      #     })
      #   ];
      # };
    };

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # __NV_PRIME_RENDER_OFFLOAD = "1";
      # __VK_LAYER_NV_optimus = "NVIDIA_only";
      NVD_BACKEND = "direct";
      # __GL_GSYNC_ALLOWED = "1";
      # __GL_VRR_ALLOWED = "1";
      # XWAYLAND_NO_GLAMOR = "1";
      # __GL_MaxFramesAllowed = "1";
    };

    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
  };
}
