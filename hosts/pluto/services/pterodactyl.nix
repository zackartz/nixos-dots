{
  pkgs,
  config,
  ...
}: {
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

  systemd.services."p_queue-worker" = {
    after = ["redis.service"];
    wantedBy = ["multi-user.target"];
    script = ''
      ${pkgs.php} /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
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
      extension=${pkgs.php82Extensions.openssl}/lib/php/extensions/openssl.so
      extension=${pkgs.php82Extensions.gd}/lib/php/extensions/gd.so
      extension=${pkgs.php82Extensions.pdo_mysql}/lib/php/extensions/mysql.so
      extension=${pkgs.php82Extensions.mbstring}/lib/php/extensions/mbstring.so
      extension=${pkgs.php82Extensions.tokenizer}/lib/php/extensions/tokenizer.so
      extension=${pkgs.php82Extensions.bcmath}/lib/php/extensions/bcmath.so
      extension=${pkgs.php82Extensions.xml}/lib/php/extensions/xml.so
      extension=${pkgs.php82Extensions.dom}/lib/php/extensions/dom.so
      extension=${pkgs.php82Extensions.curl}/lib/php/extensions/curl.so
      extension=${pkgs.php82Extensions.zip}/lib/php/extensions/zip.so
    '';
    pools.pterodactyl = {
      user = "nobody";
      phpPackage = pkgs.php;
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
}
