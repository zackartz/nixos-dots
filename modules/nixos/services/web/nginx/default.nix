{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.web.nginx;
in {
  options.services.web.nginx = with types; {
    enable = mkBoolOpt false "Enable NGINX Service";
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      package = pkgs.nginxStable.override {openssl = pkgs.libressl;};
      recommendedProxySettings = true;
      virtualHosts = {
        "node.nyc.zackmyers.io" = {
          forceSSL = true;
          enableACME = true;
        };

        "zackmyers.io" = {
          globalRedirect = "zackster.zip";
          forceSSL = true;
          enableACME = true;
        };
      };
    };
  };
}
