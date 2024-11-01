{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.minio;
in {
  options.sites.minio = with types; {
    enable = mkBoolOpt false "Enable Hydra";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      minio = {
        owner = "minio";
        group = "minio";
        file = ./sec/minio.age;
      };
    };

    services.minio = {
      enable = true;
      consoleAddress = ":4242";
      rootCredentialsFile = config.age.secrets.minio.path;
    };

    services.nginx.virtualHosts."minio.zoeys.computer" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost${config.services.minio.consoleAddress}";

        extraConfig = ''
          # To support websocket
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        '';
      };
    };

    services.nginx.virtualHosts."s3.zoeys.computer" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost${config.services.minio.listenAddress}";
      };
    };
  };
}
