{pkgs, ...}: {
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    runInUwsgi = true;
    settings = {
      # server.port = 8080;
      # server.bind_addres = "0.0.0.0";
      server.secret_key = "6f6bf40218f239718cacbc2cd837792be828e840b48ac72a8e0a9d0ddb9d0b00";
    };
    uwsgiConfig = {
      http = ":8080";
    };
  };

  services.nginx.virtualHosts."search.zackmyers.io" = {
    forceSSL = true;
    enableACME = true;
    locations."/searx" = {
      proxyPass = "http://localhost:8080";
    };
  };
}
