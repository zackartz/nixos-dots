{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.work.vpn;
in {
  options.work.vpn = with types; {
    enable = mkBoolOpt false "Enable Work VPN Config";
  };

  config = mkIf cfg.enable {
    xdg.configFile."vpn/work.ovpn" = {
      text = ''
        conifg /home/zoey/cvpn-client.ovpn

        up ${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf
        down ${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf
      '';
      recursive = true;
    };
  };
}
