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

    services.openvpn = {
      servers = {
        work = {
          config = ''config /home/zoey/Downloads/zachary_myers.ovpn'';
          updateResolvConf = true;
        };
      };
    };

    systemd.services.openvpn-work.wantedBy = lib.mkForce [];
  };
}
