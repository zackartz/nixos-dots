{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.wg;
in {
  options.services.wg = with types; {
    enable = mkBoolOpt false "Enable wg service(s)";
  };

  config = mkIf cfg.enable {
    networking.nat.enable = false;
    networking.nat.externalInterface = "enp5s0";
    networking.nat.internalInterfaces = ["wg0"];
    networking.firewall = {
      allowedUDPPorts = [51820];

      extraCommands = ''
        # Allow WireGuard peer to access only Jellyfin
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -s 10.100.0.2 -d 192.168.1.83 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -s 10.100.0.3 -d 192.168.1.83 -j ACCEPT
      '';

      extraStopCommands = ''
        # Clean up rules when stopping
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -s 10.100.0.2 -d 192.168.1.83 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -s 10.100.0.3 -d 192.168.1.83 -j ACCEPT
      '';
    };

    networking.wireguard.interfaces = {
      wg0 = {
        ips = ["10.100.0.1/24"];

        listenPort = 51820;

        privateKeyFile = "/home/zoey/wg-keys/private";

        peers = [
          # List of allowed peers.
          {
            # Feel free to give a meaning full name
            # Public key of the peer (not a file path).
            publicKey = "oxcliwRzjiYda7x90lv71R/PnnPxIWSVIjSjiv2DyBQ=";
            # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
            allowedIPs = ["10.100.0.2/32" "192.168.1.83/32"];
          }
          {
            publicKey = "+lWaMyRJOmijb3pSe8iufFO3lw2VW62uCn/ckJyAUxk=";
            allowedIPs = ["10.100.0.3/32" "192.168.1.83/32"];
          }
        ];
      };
    };
  };
}
