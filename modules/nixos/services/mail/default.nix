{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.mail;

  sec = config.age.secrets;
in {
  options.services.mail = with types; {
    enable = mkBoolOpt false "Enable Simple Nixos Mailserver";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      webmaster-pw = {
        file = ./sec/webmaster-pw.age;
      };
      zoeycomputer-pw = {
        file = ./sec/zoey-zoeycomputer-pw.age;
      };
      zmio-pw = {
        file = ./sec/zmio-pw.age;
      };
      zach-pw.file = ./sec/zach-pw.age;
      emily-pw.file = ./sec/emily-piccat.age;

      gitlab-email-pw-hashed.file = ./sec/gitlab-email-pw-hashed.age;
    };

    mailserver = {
      enable = true;
      fqdn = "mail.zoeys.email";
      domains = ["zoeys.email" "zoeys.cloud" "zoeys.computer" "zackmyers.io" "zacharymyers.com" "pictureofcat.com"];

      loginAccounts = {
        "zoey@zoeys.email" = {
          hashedPasswordFile = sec.webmaster-pw.path;
          aliases = ["zoey@zoeys.cloud" "postmaster@zoeys.email" "abuse@zoeys.email"];
        };
        "hi@zoeys.computer" = {
          hashedPasswordFile = sec.zoeycomputer-pw.path;
          aliases = ["spam@zoeys.computer"];
        };
        "me@zackmyers.io" = {
          hashedPasswordFile = sec.zmio-pw.path;
          aliases = ["zach@zacharymyers.com" "zack@zacharymyers.com"];
        };
        "gf@zackmyers.io" = {
          hashedPasswordFile = sec.emily-pw.path;
          aliases = ["emily@pictureofcat.com"];
        };
        "gitlab@zoeys.cloud" = {
          hashedPasswordFile = sec.gitlab-email-pw-hashed.path;
          aliases = ["noreply@zoeys.cloud"];
        };
      };

      certificateScheme = "acme-nginx";
      virusScanning = true;
    };

    # services.nginx = {
    #   virtualHosts = {
    #     "cal.zoeys.cloud" = {
    #       forceSSL = true;
    #       enableACME = true;
    #       locations."/" = {
    #         proxyPass = "http://localhost:5232/";
    #         extraConfig = ''
    #           proxy_set_header  X-Script-Name /;
    #           proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    #           proxy_pass_header Authorization;
    #         '';
    #       };
    #     };
    #   };
    # };

    services.roundcube = {
      enable = true;
      hostName = "zoeys.email";
      extraConfig = ''
        $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
        $config['smtp_user'] = "%u";
        $config['smtp_pass'] = "%p";
      '';
    };
  };
}
