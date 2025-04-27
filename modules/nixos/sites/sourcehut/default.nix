{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.sourcehut;

  srhtCfg = config.services.sourcehut;

  fqdn = "zoeys.cloud";

  sec = config.age.secrets;

  sourcehutGroup = "sourcehut-secrets";

  mkSrhtBindOverrides = serviceNames:
    lib.listToAttrs (map (name: {
        name = name;

        value = {
          serviceConfig.BindReadOnlyPaths = lib.mkMerge ["/run/agenix"];
        };
      })
      serviceNames);

  metaServices = lib.mkIf srhtCfg.meta.enable (mkSrhtBindOverrides [
    "metasrht" # Main web service
    "metashrt-daily"
    "metasrht-api" # API service
    "metasrht-webhooks" # Webhook worker
  ]);

  gitServices = lib.mkIf srhtCfg.git.enable (mkSrhtBindOverrides [
    "gitsrht" # Main web service
    "gitsrht-api" # API service
    "gitsrht-periodic" # Timer service
    "gitsrht-webhooks" # Webhook worker
    "gitsrht-fcgiwrap" # FCGIWrap for git http backend (might need access if hooks use secrets)
  ]);

  manServices = lib.mkIf srhtCfg.man.enable (mkSrhtBindOverrides [
    "mansrht" # Main web service
    # Add others if man gains sub-services
  ]);
in {
  options.sites.sourcehut = with types; {
    enable = mkBoolOpt false "Enable SRHT";
  };

  config = mkIf cfg.enable {
    users.groups.sourcehut-secrets = {};

    users.users.metasrht.extraGroups = ["sourcehut-secrets"];
    users.users.gitsrht.extraGroups = ["sourcehut-secrets"];

    systemd.services = lib.mkMerge [
      metaServices
      gitServices
    ];

    age.secrets = {
      network-key = {
        file = ./sec/networkKey.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440";
      };
      service-key = {
        file = ./sec/serviceKey.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440";
      };
      webhook-key = {
        file = ./sec/webhookKey.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440";
      };
      smtp-password = {
        file = ./sec/smtpPassword.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440";
      };

      pgp-pub-key = {
        file = ./sec/pgpPubKey.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440"; # Or 0444 if it needs to be world-readable, but 0440 is safer
      };
      pgp-priv-key = {
        file = ./sec/pgpPrivKey.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440"; # Private key needs strict permissions
      };

      git-client-secret = {
        file = ./sec/gitClientSecret.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440";
      };
      man-client-secret = {
        file = ./sec/gitClientSecret.age;
        owner = "root";
        group = sourcehutGroup;
        mode = "0440";
      };
    };

    services.sourcehut = {
      enable = true;

      git.enable = true;
      git.redis.host = "redis://localhost:6379?db=0";
      man.enable = true;
      man.redis.host = "redis://localhost:6379?db=0";
      meta.enable = true;
      meta.redis.host = "redis://localhost:6379?db=0";
      # todo.enable = true;
      # paste.enable = true;
      # lists.enable = true;

      nginx.enable = true;
      postgresql.enable = true;
      redis.enable = true;

      postfix.enable = false;

      settings = {
        "sr.ht" = {
          environment = "production";
          global-domain = fqdn;

          origin = "https://${fqdn}";

          owner-email = "admin@${fqdn}";
          owner-name = "zoey";
          site-name = "zoey's cloud";

          network-key = sec.network-key.path;
          service-key = sec.service-key.path;
        };

        webhooks = {
          private-key = sec.webhook-key.path;
        };

        "git.sr.ht" = {
          oauth-client-id = "bdd69307-d8b9-4f02-b079-2a1055c3e865";
          oauth-client-secret = sec.git-client-secret.path;
        };

        "man.sr.ht" = {
          oauth-client-id = "9c64aac1-51cb-48f0-9ff8-a2af377dd38e";
          oauth-client-secret = sec.man-client-secret.path;
        };

        mail = {
          smtp-host = "mail.zoeys.email";
          smtp-port = 465;
          smtp-user = "srht@${fqdn}";
          smtp-password = sec.smtp-password.path;
          smtp-from = "no-reply@${fqdn}";

          smtp-ssl = true;

          pgp-pubkey = sec.pgp-pub-key.path;
          pgp-privkey = sec.pgp-priv-key.path;

          pgp-key-id = "0xD82899ACCD75CC48";

          error-to = "errors@${fqdn}";
          error-from = "sourcehut-errors@${fqdn}";
        };

        "meta.sr.ht::settings" = {
          registration = true;
        };
      };
    };

    security.acme.certs."${fqdn}".extraDomainNames = [
      "meta.${fqdn}"
      "man.${fqdn}"
      "git.${fqdn}"
    ];

    services.nginx = {
      virtualHosts = {
        "${fqdn}".enableACME = true;
        "meta.${fqdn}".enableACME = true;
        "man.${fqdn}".enableACME = true;
        "git.${fqdn}".enableACME = true;
      };
    };
  };
}
