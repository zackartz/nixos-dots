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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  hardware.audio.enable = true;
  hardware.nvidia.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  ui.fonts.enable = true;

  protocols.wayland.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
  '';
  services.fstrim.enable = true;
  services.vpn.enable = true;
  services.xserver.enable = true;
  services.vpn.mullvad = true;
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    settings = {
      download-dir = "/home/zoey/dl";
    };
  };
  services.gnome.gnome-keyring.enable = true;
  services._1password = {
    enable = true;
    polkitPolicyOwnerUsername = "zoey";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
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
  # networking.firewall.enable = false;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs"];

  services.dlna.enable = true;
  # services.openssh = {
  #   enable = true;
  #   PasswordAuthentication = true;
  # };

  time.timeZone = "America/Detroit";

  environment.systemPackages = [
    pkgs.BeatSaberModManager
    pkgs.sbctl
    pkgs.custom.vesktop
    pkgs.mangohud
    pkgs.transmission_4
    inputs.agenix.packages.${system}.agenix
  ];

  programs.zsh.enable = true;
  users.users.zoey = {
    isNormalUser = true;
    description = "zoey";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "plugdev"];
    shell = pkgs.zsh;
    initialHashedPassword = "$6$rounds=2000000$rFBJH7LwdEHvv.0i$HdHorWqp8REPdWPk5fEgZXX1TujRJkMxumGK0f0elFN0KRPlBjJMW2.35A.ID/o3eC/hGTwbSJAcJcwVN2zyV/";
  };

  users.groups.plugdev = {};

  snowfallorg.users.zoey = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  catppuccin.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
}
