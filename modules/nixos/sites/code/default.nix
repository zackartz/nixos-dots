{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.forgejo;
  frg = config.services.forgejo;
  srv = frg.settings.server;
in {
  options.sites.forgejo = with types; {
    enable = mkBoolOpt false "Enable Forgejo site";

    domain = mkStringOpt "code.zoeys.cloud" "The domain for the site";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts.${frg.settings.server.DOMAIN} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
    };

    catppuccin.forgejo.enable = true;

    services.gitea-actions-runner = {
      package = pkgs.forgejo-actions-runner;
      instances.default = {
        enable = true;
        name = "monolith";
        url = "https://code.zoeys.cloud";
        # Obtaining the path to the runner token file may differ
        # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
        tokenFile = config.age.secrets.forgejo-runner-token.path;
        labels = [
          "ubuntu-latest:docker://node:16-bullseye"
          "ubuntu-22.04:docker://node:16-bullseye"
          "ubuntu-20.04:docker://node:16-bullseye"
          "ubuntu-18.04:docker://node:16-buster"
          ## optionally provide native execution on the host:
          # "native:host"
        ];
      };
    };

    services.forgejo = {
      enable = true;
      database.type = "postgres";

      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = cfg.domain;
          ROOT_URL = "https://${srv.DOMAIN}";
          HTTP_PORT = 7201;
        };
        service.DISABLE_REGISTRATION = true;
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
        mailer = {
          ENABLED = true;
          SMTP_ADDR = "mail.zoeys.cloud";
          FROM = "no-reply@${srv.DOMAIN}";
          USER = "no-reply@${srv.DOMAIN}";
        };
      };
      secrets = {
        mailer = {
          PASSWD = config.age.secrets.forgejo-mailer-password.path;
        };
      };
    };

    systemd.services.forgejo.preStart = let
      adminCmd = "${lib.getExe frg.package} admin user";
      pwd = config.age.secrets.forgejo-pw;
      user = "zoey";
    in ''
      ${adminCmd} create --admin --email "hi@zoeys.computer" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true'';

    age.secrets = {
      forgejo-mailer-password = {
        file = ../sourcehut/sec/smtpPassword.age;
        mode = "400";
        owner = "forgejo";
      };
      forgejo-pw = {
        file = ./forgejoPw.age;
        mode = "400";
        owner = "forgejo";
      };
      forgejo-runner-token = {
        file = ./forgejoRunner.age;
        mode = "400";
        owner = "forgejo";
      };
    };
  };
}
