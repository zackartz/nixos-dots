{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.map;
in {
  options.sites.map = with types; {
    enable = mkBoolOpt false "Enable BlueMap for Alfie";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."cobblemonsurvival.zackmyers.io" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://0.0.0.0:8100";
      };
    };
  };
}
