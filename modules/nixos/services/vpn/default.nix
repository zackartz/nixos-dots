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
    services.mullvad-vpn.enable = cfg.mullvad;
    services.openvpn = {
      servers = {
        work = {
          config = ''config /home/zoey/Downloads/zachary_myers.ovpn'';
          updateResolvConf = true;
        };
      };
    };

    systemd.services.openvpn-work.wantedBy = lib.mkForce [];

    systemd.services."mullvad-daemon".postStart = let
      mullvad = config.services.mullvad-vpn.package;
    in
      mkIf cfg.mullvad ''
        while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 1; done
        ${mullvad}/bin/mullvad auto-connect set on
        ${mullvad}/bin/mullvad tunnel set ipv6 on
        ${mullvad}/bin/mullvad connect
      '';
  };
}
