{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.immich;
in {
  options.sites.immich = with types; {
    enable = mkBoolOpt false "Enable Immich Photo backup";
  };

  config = mkIf cfg.enable {
    services.immich.enable = true;
    services.immich.port = 2283;

    services.nginx.virtualHosts."i.zoeys.photos" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };
  };
}
