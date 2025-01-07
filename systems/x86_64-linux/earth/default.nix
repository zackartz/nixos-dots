{
  pkgs,
  lib,
  system,
  inputs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix (import ./disko.nix {device = "/dev/nvme0n1";})];

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
    enable = true;
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
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
  };

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
    pkgs.transmission_4
    inputs.agenix.packages.${system}.agenix
    inputs.awsvpnclient.packages."${pkgs.system}".awsvpnclient
  ];

  programs.fish.enable = true;
  programs.fuse.userAllowOther = true;
  users.users.zoey = {
    isNormalUser = true;
    description = "zoey";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd" "plugdev"];
    shell = pkgs.fish;
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

  sites.jellyfin.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  system.stateVersion = "24.05";
}
