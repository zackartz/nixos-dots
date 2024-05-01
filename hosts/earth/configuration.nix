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

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    wireplumber.enable = true;
  };
  services.fstrim.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "earth"; # Define your hostname.

  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = ["enp6s0"];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs"];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"]; # or "nvidiaLegacy470 etc.

  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      notify_interval = 60;
      friendly_name = "ZACKPC";
      media_dir = ["A,/home/zack/Music"];
      inotify = "yes";
    };
  };

  users.users.minidlna = {
    extraGroups = ["users"];
  };

  # services.openssh = {
  #   enable = true;
  #   PasswordAuthentication = true;
  # };

  environment.systemPackages = with pkgs; [
    alvr
    BeatSaberModManager
    sbctl
    vesktop
    mangohud
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
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # specialisation = {
  #   nvidiaProduction.configuration = {
  #     hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  #     environment.etc."specialisation".text = "nvidiaProduction";
  #   };
  #   nvidiaStable.configuration = {
  #     hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  #     environment.etc."specialisation".text = "nvidiaStable";
  #   };
  #   nvidiaVulkanBeta.configuration = {
  #     hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
  #     environment.etc."specialisation".text = "nvidiaVulkanBeta";
  #   };
  # };

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zack = {
    isNormalUser = true;
    description = "zack";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "plugdev"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      kate
      rio
      telegram-desktop
      kitty
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "zack" = {
        imports = [../../modules/home-manager/zack.nix];
        _module.args.theme = import ../../core/theme.nix;

        home.username = "zack";
        home.homeDirectory = "/home/zack";
      };
    };
  };

  programs.virt-manager.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
