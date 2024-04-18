{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/default.nix
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };

  boot = {
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  networking = {
    hostName = "live";
  };

  # gnome power settings do not turn off screen
  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  home-manager.users.nixos = {
    # imports = [../../modules/home-manager/default.nix];
    _module.args.theme = import ../../core/theme.nix;

    home.stateVersion = "23.11"; # Please read the comment before changing it.

    home.username = "nixos";
    home.homeDirectory = "/home/nixos";
  };
  users.extraUsers.root.password = "nixos";
}
