{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.search;
in {
  options.sites.search = with types; {
    enable = mkBoolOpt false "Enable Search (Searxng)";

    domain = mkStringOpt "search.zoeys.computer" "The domain of the search instance";
  };

  config = mkIf cfg.enable {
    services.searx = {
      enable = true;
      runInUwsgi = true;
      settings = {
        # server.port = 8080;
        # server.bind_addres = "0.0.0.0";
        server.secret_key = "6f6bf40218f239718cacbc2cd837792be828e840b48ac72a8e0a9d0ddb9d0b00"; # you can know this i don't care
        server.base_url = "https://${cfg.domain}/searx/";
      };
      uwsgiConfig = {
        http = ":8080";
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        access_log off;
      '';
      locations."/searx/" = {
        proxyPass = "http://localhost:8080";
      };
    };
  };
}
