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
    enable = mkBoolOpt false "Enable MiniDLNA service";
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
    services.openvpn.servers = {
      work = {
        config = ''config /home/zack/Downloads/zachary_myers.ovpn'';
        updateResolvConf = true;
      };
    };

    # disable autoconnect for now
    # systemd.services."mullvad-daemon".postStart = let
    #   mullvad = config.services.mullvad-vpn.package;
    # in ''
    #   while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 1; done
    #   ${mullvad}/bin/mullvad auto-connect set on
    #   ${mullvad}/bin/mullvad tunnel set ipv6 on
    #   ${mullvad}/bin/mullvad connect
    # '';
  };
}
