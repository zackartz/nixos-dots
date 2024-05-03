{pkgs, ...}: {
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    runInUwsgi = true;
    settings = {
      server.secret_key = "6f6bf40218f239718cacbc2cd837792be828e840b48ac72a8e0a9d0ddb9d0b00";
    };
    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };
  };

  services.nginx.virtualHosts."search.zackmyers.io" = {
    forceSSL = true;
    enableACME = true;
    locations."/searx".extraConfig = ''
      uwsgi_pass unix:///run/searx/searx.sock;

      include uwsgi_params;

      uwsgi_param    HTTP_HOST             $host;
      uwsgi_param    HTTP_CONNECTION       $http_connection;

      # see flaskfix.py
      uwsgi_param    HTTP_X_SCHEME         $scheme;
      uwsgi_param    HTTP_X_SCRIPT_NAME    /searxng;

      # see limiter.py
      uwsgi_param    HTTP_X_REAL_IP        $remote_addr;
      uwsgi_param    HTTP_X_FORWARDED_FOR  $proxy_add_x_forwarded_for;
    '';
  };
}
