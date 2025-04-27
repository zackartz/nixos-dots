{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.gitlab;

  sec = config.age.secrets;
  user = config.services.gitlab.user;
  group = config.services.gitlab.group;
in {
  options.sites.gitlab = with types; {
    enable = mkBoolOpt false "Enable GitLab";

    domain = mkStringOpt "git.zoeys.cloud" "Domain for GitLab";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      gitlab_db = {
        file = ./sec/gitlab_db.age;
        owner = user;
        group = group;
      };
      gitlab_initpw = {
        file = ./sec/gitlab_initpw.age;
        owner = user;
        group = group;
      };
      gitlab_otp = {
        file = ./sec/gitlab_otp.age;
        owner = user;
        group = group;
      };
      gitlab_pw = {
        file = ./sec/gitlab_pw.age;
        owner = user;
        group = group;
      };
      gitlab_sec = {
        file = ./sec/gitlab_sec.age;
        owner = user;
        group = group;
      };
      gitlab_runner = {
        file = ./sec/gitlab_runner.age;
      };
      gitlab_email_pw = {
        file = ./sec/gitlab-email-pw.age;
        owner = user;
        group = group;
      };
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = true; # 1

    services.gitlab = {
      enable = true;
      databasePasswordFile = sec.gitlab_db.path;
      initialRootPasswordFile = sec.gitlab_initpw.path;
      port = 443;
      https = true;
      host = cfg.domain;

      smtp = {
        enable = true;
        address = "mail.zoeys.cloud";
        username = "gitlab@zoeys.cloud";
        passwordFile = sec.gitlab_email_pw.path;
        port = 465;
      };

      secrets = {
        secretFile = sec.gitlab_sec.path;
        otpFile = sec.gitlab_otp.path;
        dbFile = sec.gitlab_db.path;
        jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    };

    systemd.services.gitlab-backup.environment.BACKUP = "dump";
  };
}
