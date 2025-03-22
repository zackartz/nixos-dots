{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.mirror;
in {
  options.sites.mirror = with types; {
    enable = mkBoolOpt false "Enable ArchLinux Mirror";
  };

  config = mkIf cfg.enable {
    systemd.timers."mirror-update" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1h";
        OnUnitActiveSec = "1h";
        Unit = "mirror-update.service";
      };
    };

    systemd.services."mirror-update" = {
      script = ''
        ${pkgs.rsync}/bin/rsync -vPa rsync://mirrors.lug.mtu.edu/archlinux/ /var/www/mirror.zackmyers.io/archlinux/
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    services.nginx.virtualHosts."mirror.zackmyers.io" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/mirror.zackmyers.io";
      locations."/".extraConfig = ''
        autoindex on;
      '';

      locations."~* \.iso$".extraConfig = ''
        limit_req zone=iso_ratelimit burst=20 nodelay;
        limit_conn iso_connlimit 5;
        limit_rate_after 10m;
        limit_rate 500k;

        if ($http_user_agent ~* "Transmission") {
          access_log /var/log/nginx/blocked_transmission.log combined;
          return 403;
        }
      '';
    };
  };
}
