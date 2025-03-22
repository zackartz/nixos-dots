{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.vpn;
in {
  options.services.vpn = with types; {
    enable = mkBoolOpt false "Enable VPN service(s)";

    mullvad = mkBoolOpt false "Enable Mullvad VPN Daemon";
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = cfg.mullvad;
      package = nixos-stable.mullvad;
    };
    #
    # # Create a specific network namespace for VPN traffic
    # systemd.services.mullvad-daemon = {
    #   serviceConfig = {
    #     NetworkNamespacePath = "/run/netns/mullvad";
    #   };
    # };
    #
    # # Configure transmission to use Mullvad's SOCKS5 proxy
    # # Configure transmission to use the Mullvad network namespace
    # systemd.services.transmission = mkIf config.services.transmission.enable {
    #   serviceConfig = {
    #     NetworkNamespacePath = "/run/netns/mullvad";
    #   };
    #   # Make sure Mullvad is running before transmission starts
    #   requires = ["mullvad-daemon.service"];
    #   after = ["mullvad-daemon.service"];
    # };

    services.openvpn = {
      servers = {
        work = {
          config = ''config /home/zoey/Downloads/zachary_myers.ovpn'';
          updateResolvConf = true;
        };
      };
    };

    systemd.services.openvpn-work.wantedBy = lib.mkForce [];

    #   # Add necessary networking tools
    #   environment.systemPackages = with pkgs; [
    #     iproute2 # for ip netns commands
    #   ];
    #
    #   # Setup network namespace
    #   systemd.services.setup-mullvad-netns = {
    #     description = "Setup Mullvad Network Namespace";
    #     before = ["mullvad-daemon.service"];
    #     serviceConfig = {
    #       Type = "oneshot";
    #       RemainAfterExit = true;
    #       ExecStart = "${pkgs.iproute2}/bin/ip netns add mullvad";
    #       ExecStop = "${pkgs.iproute2}/bin/ip netns delete mullvad";
    #     };
    #   };
  };
}
