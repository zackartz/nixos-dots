{
  config,
  pkgs,
  lib,
  ...
}: let
  sec = config.age.secrets;
  user = config.services.gitlab.user;
  group = config.services.gitlab.group;
in {
  age.secrets = {
    gitlab_db = {
      file = ../../../sec/gitlab_db.age;
      owner = user;
      group = group;
    };
    gitlab_initpw = {
      file = ../../../sec/gitlab_initpw.age;
      owner = user;
      group = group;
    };
    gitlab_otp = {
      file = ../../../sec/gitlab_otp.age;
      owner = user;
      group = group;
    };
    gitlab_pw = {
      file = ../../../sec/gitlab_pw.age;
      owner = user;
      group = group;
    };
    gitlab_sec = {
      file = ../../../sec/gitlab_sec.age;
      owner = user;
      group = group;
    };
    gitlab_runner = {
      file = ../../../sec/gitlab_runner.age;
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = true; # 1

  services.gitlab-runner = {
    enable = true;
    services = {
      nix = with lib; {
        registrationConfigFile = toString sec.gitlab_runner.path; # 2
        dockerImage = "alpine";
        dockerVolumes = [
          "/nix/store:/nix/store:ro"
          "/nix/var/nix/db:/nix/var/nix/db:ro"
          "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
        ];
        dockerDisableCache = true;
        preBuildScript = pkgs.writeScript "setup-container" ''
          mkdir -p -m 0755 /nix/var/log/nix/drvs
          mkdir -p -m 0755 /nix/var/nix/gcroots
          mkdir -p -m 0755 /nix/var/nix/profiles
          mkdir -p -m 0755 /nix/var/nix/temproots
          mkdir -p -m 0755 /nix/var/nix/userpool
          mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
          mkdir -p -m 1777 /nix/var/nix/profiles/per-user
          mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
          mkdir -p -m 0700 "$HOME/.nix-defexpr"
          . ${pkgs.nix}/etc/profile.d/nix-daemon.sh
          ${pkgs.nix}/bin/nix-channel --add https://nixos.org/channels/nixos-20.09 nixpkgs # 3
          ${pkgs.nix}/bin/nix-channel --update nixpkgs
          ${pkgs.nix}/bin/nix-env -i ${concatStringsSep " " (with pkgs; [nix cacert git openssh])}
        '';
        environmentVariables = {
          ENV = "/etc/profile";
          USER = "root";
          NIX_REMOTE = "daemon";
          PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";
          NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
        };
        tagList = ["nix"];
      };
    };
  };

  services.gitlab = {
    enable = true;
    databasePasswordFile = sec.gitlab_db.path;
    initialRootPasswordFile = sec.gitlab_initpw.path;
    port = 443;
    https = true;
    host = "git.zackmyers.io";
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
