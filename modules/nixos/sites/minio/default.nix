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

    services.nginx.virtualHosts."s3.zoeys.computer" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        # Allow special characters in headers
        ignore_invalid_headers off;
        # Allow any size file to be uploaded.
        # Set to a value such as 1000m; to restrict file size to a specific value
        client_max_body_size 0;
        # Disable buffering
        proxy_buffering off;
        proxy_request_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://localhost${config.services.minio.listenAddress}";
        extraConfig = ''
          proxy_set_header Host $http_host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          proxy_connect_timeout 300;
          # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
          proxy_http_version 1.1;
          proxy_set_header Connection "";
          chunked_transfer_encoding off;
        '';
      };
      locations."/minio/ui" = {
        proxyPass = "http://localhost${config.services.minio.consoleAddress}";
        extraConfig = ''
          rewrite ^/minio/ui/(.*) /$1 break;
          proxy_set_header Host $http_host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-NginX-Proxy true;

          # This is necessary to pass the correct IP to be hashed
          real_ip_header X-Real-IP;

          proxy_connect_timeout 300;

          # To support websockets in MinIO versions released after January 2023
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          # Some environments may encounter CORS errors (Kubernetes + Nginx Ingress)
          # Uncomment the following line to set the Origin request to an empty string
          # proxy_set_header Origin \'\';
          chunked_transfer_encoding off;
        '';
      };
    };
  };
}
