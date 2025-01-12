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

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

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
      download-dir = "/home/zoey/dl";
    };
  };
  services.gnome.gnome-keyring.enable = true;
  services.solaar = {
    enable = true;
  };
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

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs"];

  services.dlna.enable = false;
  # services.openssh = {
  #   enable = true;
  #   PasswordAuthentication = true;
  # };

  time.timeZone = "America/Detroit";

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.vesktop
    pkgs.mangohud
    pkgs.lutris
    pkgs.podman-tui
    pkgs.dive
    pkgs.docker-compose
    pkgs.podman-compose
    pkgs.transmission_4
    inputs.agenix.packages.${system}.agenix
    inputs.awsvpnclient.packages."${pkgs.system}".awsvpnclient

    pkgs.nautilus-python
    (pkgs.writeTextFile {
      name = "nautilus-open-kitty-here";
      destination = "/share/nautilus-python/extensions/open-kitty-here.py";
      text = ''
        import os
        import gi
        gi.require_version('Nautilus', '3.0')
        from gi.repository import Nautilus, GObject

        class OpenKittyTerminalExtension(GObject.GObject, Nautilus.MenuProvider):
            def __init__(self):
                pass

            def menu_activate_cb(self, menu, file):
                if file.is_directory():
                    path = file.get_location().get_path()
                else:
                    path = file.get_parent_location().get_path()
                os.system(f'kitty --directory "{path}" &')

            def get_file_items(self, window, files):
                if len(files) != 1:
                    return

                file = files[0]
                item = Nautilus.MenuItem(
                    name='OpenKittyTerminalExtension::OpenKitty',
                    label='Open in Kitty',
                    tip='Opens Kitty terminal in this location'
                )
                item.connect('activate', self.menu_activate_cb, file)
                return [item]

            def get_background_items(self, window, file):
                item = Nautilus.MenuItem(
                    name='OpenKittyTerminalExtension::OpenKitty',
                    label='Open in Kitty',
                    tip='Opens Kitty terminal in this location'
                )
                item.connect('activate', self.menu_activate_cb, file)
                return [item]
      '';
    })
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

  snowfallorg.users.zoey = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  catppuccin.enable = true;
  programs.virt-manager.enable = true;

  sites.jellyfin.enable = true;

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.libvirtd.enable = true;

  system.stateVersion = "24.05";
}
