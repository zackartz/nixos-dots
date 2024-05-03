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
    locations."/searx" = {
      uwsgiPass = "unix://run/searx/searx.sock";
    };
  };
}
