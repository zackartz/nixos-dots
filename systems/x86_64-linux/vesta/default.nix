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
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  # do not use DHCP, as DigitalOcean provisions IPs using cloud-init
  networking.useDHCP = lib.mkForce false;

  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      datasource_list = ["ConfigDrive"];
      datasource.ConfigDrive = {};
    };
  };

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration

    80
    443
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  services.k3s = {
    enable = true;
    role = "agent"; # Or "agent" for worker only nodes
    token = "e73bb24efa7c545165e7edaf357bc8cfe0fc3e579ff41f6cdc4ea6b81f34ebd9c9ec13f27fb6d4aa5824dec3ac5c57dbf36460c5255fc434c2d33507e38578cb";
    serverAddr = "https://134.199.176.87:6443";

    extraFlags = [
      # "--advertise-address=174.138.106.48"
      # "--disable=traefik"
    ];
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuw7D+qDzzxBKsfKEmMd7odc98m3ZEnqWYFtuKwvC9k zoey@earth"
  ];

  system.stateVersion = "24.05";
}
