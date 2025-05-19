{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  nix.optimise = {
    automatic = true;
    dates = ["03:45"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  nix.settings = {
    trusted-users = ["zoey"];
  };

  networking.useDHCP = lib.mkForce false;
  networking.interfaces.ens3.ipv4.addresses = [
    {
      address = "185.112.147.15";
      prefixLength = 24;
    }
  ];
  networking.nameservers = ["93.95.224.28" "93.95.224.29"];
  networking.defaultGateway = "185.112.147.1";

  programs.zsh.enable = true;

  services.web.nginx.enable = true;
  services.mail.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuw7D+qDzzxBKsfKEmMd7odc98m3ZEnqWYFtuKwvC9k zoey@earth"
  ];

  users.users.zoey = {
    isNormalUser = true;
    description = "zoey";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    hashedPassword = "$6$LZdeNTlfOEivWraB$J3/kQ5YHbcdd4J4oJ.0NJ7/MeRgdDHcemy4zIG1uAtI6637Glj6kPCPpJyyCRKN3I9NLRfZDLRBbwtSCtY.4B.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuw7D+qDzzxBKsfKEmMd7odc98m3ZEnqWYFtuKwvC9k zoey@earth"
    ];
  };

  snowfallorg.users.zoey = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];

  system.stateVersion = "24.05";
}
