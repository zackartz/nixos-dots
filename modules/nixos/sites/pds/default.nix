{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.atproto-pds;
in {
  options.services.atproto-pds = {
    enable = mkEnableOption "Bluesky Personal Data Server container";

    dataDir = mkOption {
      type = types.path;
      default = "/pds";
      description = "Directory to store PDS data, maps to /pds inside container.";
    };

    blobStorage = {
      type = mkOption {
        type = types.enum ["disk" "s3"];
        default = "disk";
        description = "Type of blob storage to use (disk or s3).";
      };

      # Disk-specific options
      diskPath = mkOption {
        type = types.str;
        default = "/pds/blocks";
        description = "Path for disk-based blob storage.";
      };

      # S3-specific options
      s3 = {
        endpoint = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "S3 endpoint URL (optional, for non-AWS S3).";
        };

        bucket = mkOption {
          type = types.str;
          default = "";
          description = "S3 bucket name.";
        };

        region = mkOption {
          type = types.str;
          default = "us-east-1";
          description = "AWS region for S3.";
        };
      };
    };

    environmentFile = mkOption {
      type = types.path;
      default = "/pds/pds.env";
      description = "Environment file for PDS configuration.";
    };

    image = mkOption {
      type = types.str;
      default = "ghcr.io/bluesky-social/pds";
      description = "PDS container image to use.";
    };

    imageTag = mkOption {
      type = types.str;
      default = "0.4";
      description = "Tag of the PDS container image.";
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "Port on which PDS will listen.";
    };

    useHostNetwork = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use host networking. Set to false to use port mapping instead.";
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable nginx virtual host.";
      };

      domain = mkOption {
        type = types.str;
        default = "zoeys.computer";
        description = "Domain name for the PDS server.";
      };

      subdomainPrefix = mkOption {
        type = types.str;
        default = "*";
        description = "Subdomain prefix for PDS (e.g., pds.zoeys.computer).";
      };

      useACME = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable automatic HTTPS certificates via ACME.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional nginx configuration.";
      };
    };
  };

  config = mkIf cfg.enable {
    age.secrets = {
      pds = {
        file = ./pds.age;
      };
      cloudflare = {
        file = ./cloudflare.age;
      };
    };

    # Ensure directories exist
    systemd.tmpfiles.rules =
      [
        "d '${cfg.dataDir}' 0750 root root - -"
        # Create blocks directory if using disk storage
      ]
      ++ optional (cfg.blobStorage.type == "disk")
      "d '${cfg.blobStorage.diskPath}' 0750 root root - -";

    # Docker container configuration
    virtualisation.oci-containers = {
      backend = "docker";
      containers.pds = {
        image = "${cfg.image}:${cfg.imageTag}";
        autoStart = true;

        extraOptions =
          [
            "--name=pds"
            "--env-file=${config.age.secrets.pds.path}"
          ]
          ++ (optional cfg.useHostNetwork "--network=host");

        # Add port mapping if not using host network
        ports = mkIf (!cfg.useHostNetwork) [
          "${toString cfg.port}:3000"
        ];

        # Match docker-compose volumes
        volumes = [
          "${cfg.dataDir}:/pds"
        ];
      };
    };

    # Nginx configuration remains the same as before
    services.nginx = mkIf cfg.nginx.enable {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      virtualHosts = {
        "${cfg.nginx.domain}" = {
          enableACME = cfg.nginx.useACME;
          forceSSL = cfg.nginx.useACME;

          locations = {
            "~ ^/xrpc/(.*)$" = {
              proxyPass = "http://127.0.0.1:${toString cfg.port}";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };

            "~ ^/.well-known/atproto-did$" = {
              root = ./atproto;
              extraConfig = ''
                default_type text/plain;
              '';
            };
          };
        };

        "~^(?<subdomain>.+)\\.${cfg.nginx.domain}" = {
          useACMEHost = "pds.zoeys.computer";
          forceSSL = cfg.nginx.useACME;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              ${cfg.nginx.extraConfig}
            '';
          };
        };
      };
    };

    security.acme.certs = mkIf cfg.nginx.useACME {
      "pds.zoeys.computer" = {
        domain = "*.zoeys.computer";
        dnsProvider = "cloudflare";
        credentialsFile = config.age.secrets.cloudflare.path;
        group = config.services.nginx.group;
      };
    };
  };
}
