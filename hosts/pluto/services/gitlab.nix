{
  config,
  pkgs,
  ...
}: let
  sec = config.age.secrets;
in {
  age.secrets = {
    gitlab_db.file = ../../../sec/gitlab_db.age;
    gitlab_initpw.file = ../../../src/gitlab_initpw.age;
    gitlab_otp.file = ../../../sec/gitlab_otp.age;
    gitlab_pw.file = ../../../sec/gitlab_pw.age;
    gitlab_sec.file = ../../../sec/gitlab_sec.age;
  };

  services.gitlab = {
    enable = true;
    databasePasswordFile = sec.gitlab_db.path;
    initialRootPasswordFile = sec.gitlab_initpw.path;
    secrets = {
      secretFile = sec.gitlab_sec.path;
      otpFile = sec.gitlab_otp.path;
      dbFile = sec.gitlab_db.path;
      jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
    };
  };

  services.nginx.virtualHosts."git.zackmyers.io" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
  };

  systemd.services.gitlab-backup.environment.BACKUP = "dump";
}
