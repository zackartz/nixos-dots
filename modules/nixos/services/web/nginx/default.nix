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
      appendHttpConfig = ''
        limit_req_zone $binary_remote_addr zone=iso_ratelimit:10m rate=1r/m;
        limit_conn_zone $binary_remote_addr zone=iso_connlimit:10m;

        access_log /var/log/nginx/blocked.log combined if=$ratelimited;

        map $request_uri $ratelimited {
          default 0;
          ~\.iso$ $limit_req_status;
        }
      '';
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "zach@zacharymyers.com";
    };
  };
}
