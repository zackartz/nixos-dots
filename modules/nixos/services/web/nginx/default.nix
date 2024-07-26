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
    security.dhparams = {
      enable = true;
      params.nginx = {};
    };

    services.nginx = {
      enable = true;
      package = pkgs.nginxStable.override {openssl = pkgs.libressl;};
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      sslDhparam = config.security.dhparams.params.nginx.path;
      virtualHosts = {
        "node.nyc.zackmyers.io" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };
  };
}
