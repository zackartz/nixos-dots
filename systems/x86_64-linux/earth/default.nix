{
  pkgs,
  lib,
  system,
  inputs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];

  nix.settings = {
    trusted-users = ["zoey"];
  };

  nix.optimise = {
    automatic = true;
    dates = ["03:45"];
  };

  nix.package = inputs.lix-module.packages.${pkgs.system}.default;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1d";
  };

  hardware.audio.enable = true;
  hardware.nvidia.enable = true;
  hardware.keyboard.qmk.enable = true;
  programs.nix-ld.enable = true;

  hardware.march = {
    arch = "znver3";
    enableNativeOptimizations = true;
    cpu.vcores = 32;
    memory.total = 32;
  };

  # CachyOS-inspired additional native optimizations
  nixpkgs.config.packageOverrides = pkgs: {
    # Override performance-critical packages with native optimizations
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          libva
          mesa
          vulkan-loader
        ];
    };
  };

  services.gdm-monitors.enable = true;

  specialisation = {
    plasma6 = {
      configuration = {
        services.desktopManager.plasma6.enable = true;
        services.displayManager.sddm.enable = true;
        services.xserver.displayManager.gdm.enable = lib.mkForce false;

        programs.seahorse.enable = lib.mkForce false;
      };
    };
  };

  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      qt5.qtwayland
    ];
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  programs.steam.gamescopeSession.enable = true;
  # programs.gamemode = {
  #   enable = true;
  #   settings = {
  #     general = {
  #       renice = 10; # Higher process priority for games
  #       ioprio = 0; # Highest I/O priority
  #       inhibit_screensaver = 1; # Prevent screensaver
  #     };
  #
  #     gpu = {
  #       gpu_device = 0; # GPU device index to use
  #       apply_gpu_optimisations = 1; # Apply GPU optimizations
  #       gpu_core_clock_mhz = 0; # Don't override core clock
  #       gpu_mem_clock_mhz = 0; # Don't override memory clock
  #       gpu_powermizer_mode = 1; # Maximum performance mode
  #     };
  #
  #     custom = {
  #       start = "${pkgs.libnotify}/bin/notify-send 'GameMode enabled' 'System optimizations activated'";
  #       end = "${pkgs.libnotify}/bin/notify-send 'GameMode disabled' 'System returned to normal'";
  #     };
  #   };
  # };

  ui.fonts.enable = true;

  protocols.wayland.enable = true;

  programs.openvpn3.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
  '';
  services.fstrim.enable = true;
  services.vpn.enable = true;
  services.xserver.enable = true;
  services.vpn.mullvad = true;
  services.lorri.enable = true;
  services.udisks2.enable = true;
  services.transmission = {
    enable = false;
    package = pkgs.transmission_4;
    settings = {
      download-dir = "/home/zoey/Downloads";
      incomplete-dir = "/home/zoey/Downloads/.incomplete";
      incomplete-dir-enabled = true;
    };
    user = "zoey";
    group = "users";
  };
  services.gnome.gnome-keyring.enable = true;
  # services.solaar = {
  #   enable = true;
  # };
  services._1password = {
    enable = true;
    polkitPolicyOwnerUsername = "zoey";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.lanzaboote = {
    enable = false;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "earth"; # Define your hostname.

  networking.extraHosts = "127.0.0.1 local-cald.io";

  networking.networkmanager = {
    enable = true;
    unmanaged = ["enp6s0"];
    # insertNameservers = ["1.1.1.1" "1.0.0.1"];
  };

  services.scx.enable = true;
  services.scx.scheduler = "scx_rusty";
  services.scx.package = pkgs.scx_git.full;

  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  # CachyOS-inspired kernel parameters for better desktop responsiveness and gaming
  boot.kernelParams = [
    "nowatchdog"
    "preempt=full"
    "threadirqs"
    "tsc=reliable"
    "clocksource=tsc"
    "preempt=voluntary"
    "futex.futex2_interface=1" # Better Wine/Proton compatibility
    "NVreg_UsePageAttributeTable=1" # Improved GPU memory management
    "io_uring.sqpoll=2" # Modern I/O scheduler polling
    "transparent_hugepage=madvise" # Better memory management
    "elevator=bfq" # Better I/O scheduling for gaming
  ];
  boot.supportedFilesystems = ["ntfs"];

  services.dlna.enable = false;

  time.timeZone = "America/Detroit";

  services.gvfs.enable = true;
  services.gnome.sushi.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;
  services.wg.enable = true;

  # home-manager.useGlobalPkgs = false;

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.mangohud
    (pkgs.lutris.override {
      extraPkgs = pkgs: [
        inputs.nix-gaming.packages.${pkgs.system}.wine-tkg-zoey
        pkgs.winetricks
      ];
    })
    pkgs.bottles
    pkgs.file-roller
    pkgs.podman-tui
    pkgs.dive
    pkgs.docker-compose
    pkgs.podman-compose
    pkgs.transmission_4
    pkgs.protonup-qt
    pkgs.restic
    pkgs.qt5.qtwayland
    pkgs.vkBasalt # Vulkan post-processing layer for better visuals
    pkgs.goverlay # MangoHud and vkBasalt GUI configurator
    pkgs.cpupower-gui # CPU frequency control GUI
    pkgs.ananicy-cpp # Process priority daemon
    (inputs.umu.packages.${system}.umu-launcher.override {
      withTruststore = true;
      withDeltaUpdates = true;
    })
    inputs.agenix.packages.${system}.agenix
    inputs.awsvpnclient.packages.${system}.awsvpnclient
  ];

  programs.zsh.enable = true;
  programs.fuse.userAllowOther = true;
  users.users.zoey = {
    isNormalUser = true;
    description = "zoey";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "plugdev"];
    shell = pkgs.zsh;
    initialHashedPassword = "$6$rounds=2000000$rFBJH7LwdEHvv.0i$HdHorWqp8REPdWPk5fEgZXX1TujRJkMxumGK0f0elFN0KRPlBjJMW2.35A.ID/o3eC/hGTwbSJAcJcwVN2zyV/";
  };

  services.gnome.core-utilities.enable = true; # Enable core GNOME utilities

  users.groups.plugdev = {};

  home-manager.backupFileExtension = "bk";

  snowfallorg.users.zoey = {
    create = true;
    admin = true;

    home = {
      enable = true;
    };
  };

  services.openssh = {
    enable = true;
    ports = [22];
  };

  networking.firewall.allowedTCPPorts = [22];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      "SteamLibrary" = {
        path = "/mnt/bk"; # Update this path to your drive's mount point
        browseable = true;
        writable = true;
        guestOk = true; # Allow access without authentication
        public = true;
        createMask = "0775"; # File permissions
        directoryMask = "0775"; # Directory permissions
      };
    };
  };

  catppuccin.enable = true;
  programs.virt-manager.enable = true;

  # Enable Ananicy for automatic process priority management
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # CPU frequency governor always set to performance for desktop
  powerManagement.cpuFreqGovernor = "performance";

  systemd.services.NetworkManager-wait-online.enable = false;

  sites.jellyfin.enable = true;
  sites.mealie.enable = false;

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  hardware.gpu-passthru.enable = true;

  system.stateVersion = "24.05";
}
