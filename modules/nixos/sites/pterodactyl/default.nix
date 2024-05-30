{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.pterodactyl;

  wings = pkgs.stdenv.mkDerivation {
    name = "wings";

    src = pkgs.fetchurl {
      name = "wings";
      url = "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64";
      sha256 = "sha256-rKX6Rd3xwQ8JLBbddYuSDYo/qfkcN6rMYnRecpWL9xo=";
    };

    phases = ["installPhase"];

    installPhase = ''
      install -D $src $out/bin/wings
    '';
  };
in {
  options.sites.pterodactyl = with types; {
    enable = mkBoolOpt false "Enable Pterodactyl Site";
  };

  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    systemd.timers."p_artisan-run" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        Unit = "p_artisan-run.service";
      };
    };

    systemd.services."p_artisan-run" = {
      script = ''
        ${pkgs.php}/bin/php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    systemd.services."wings" = {
      after = ["docker.service"];
      requires = ["docker.service"];
      partOf = ["docker.service"];
      script = ''
        #!/usr/bin/env bash
        export PATH=${pkgs.shadow}/bin:$PATH
        ${wings}/bin/wings
      '';
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        User = "root";
        WorkingDirectory = "/etc/pterodactyl";
        LimitNOFILE = 4096;
        PIDFile = /var/run/wings/daemon.pid;
        Restart = "on-failure";
        StartLimitInterval = 180;
        StartLimitBurst = 30;
        RestartSec = "5s";
      };
    };

    systemd.services."p_queue-worker" = {
      after = ["redis.service"];
      wantedBy = ["multi-user.target"];
      script = ''
        ${pkgs.php}/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
      '';
      serviceConfig = {
        User = "nginx";
        Group = "nginx";
        Restart = "always";
        StartLimitInterval = 180;
        StartLimitBurst = 30;
        RestartSec = "5s";
      };
    };

    services.nginx.virtualHosts."pterodactyl.zackmyers.io" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/pterodactyl/public";

      locations."/".extraConfig = ''
        try_files $uri $uri/ /index.php?$query_string;
      '';
      locations."/favicon.ico".extraConfig = ''
        access_log off; log_not_found off;
      '';
      locations."/robots.txt".extraConfig = ''
        access_log off; log_not_found off;
      '';
      locations."~ \\.php$".extraConfig = ''
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:${config.services.phpfpm.pools.pterodactyl.socket};
        fastcgi_index index.php;
        include ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
        proxy_buffering off;
        proxy_request_buffering off;
      '';

      locations."~ /\\.ht".extraConfig = ''
        deny all;
      '';

      extraConfig = ''
        index index.html index.htm index.php;
        charset utf-8;

        access_log off;
        error_log  /var/log/nginx/pterodactyl.app-error.log error;

        # allow larger file uploads and longer script runtimes
        client_max_body_size 100m;
        client_body_timeout 120s;

        sendfile off;
      '';
    };

    services.phpfpm = {
      phpOptions = ''
        extension=${pkgs.php81Extensions.openssl}/lib/php/extensions/openssl.so
        extension=${pkgs.php81Extensions.gd}/lib/php/extensions/gd.so
        extension=${pkgs.php81Extensions.mysqlnd}/lib/php/extensions/mysqlnd.so
        extension=${pkgs.php81Extensions.mbstring}/lib/php/extensions/mbstring.so
        extension=${pkgs.php81Extensions.tokenizer}/lib/php/extensions/tokenizer.so
        extension=${pkgs.php81Extensions.bcmath}/lib/php/extensions/bcmath.so
        extension=${pkgs.php81Extensions.xml}/lib/php/extensions/xml.so
        extension=${pkgs.php81Extensions.dom}/lib/php/extensions/dom.so
        extension=${pkgs.php81Extensions.curl}/lib/php/extensions/curl.so
        extension=${pkgs.php81Extensions.zip}/lib/php/extensions/zip.so
      '';
      pools.pterodactyl = {
        user = config.services.nginx.user;
        phpPackage = pkgs.php81;
        settings = {
          "pm" = "dynamic";
          "listen.owner" = config.services.nginx.user;
          "pm.max_children" = 5;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 3;
          "pm.max_requests" = 500;
        };
      };
    };

    services.redis = {
      enable = true;
    };
  };
}
