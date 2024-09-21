{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.invidious;
in {
  options.sites.invidious = with types; {
    enable = mkBoolOpt false "Enable invidious instance";

    domain = mkStringOpt "vid.zoeys.computer" "The domain of the invidious instance";
  };

  config = mkIf cfg.enable {
    services.invidious = {
      enable = true;
      domain = cfg.domain;

      nginx.enable = true;
    };
  };
}
