{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.cache;

  sec = config.age.secrets;
in {
  options.sites.hydra = with types; {
    enable = mkBoolOpt false "Enable Hydra";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      cache_key = {
        file = ./sec/cache_key.age;
      };
    };

    services.nix-serve = {
      enable = true;
      secretKeyFile = sec.cache_key.path;
    };

    services.nginx.virtualHosts."cache.zoeys.computer" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };
}
