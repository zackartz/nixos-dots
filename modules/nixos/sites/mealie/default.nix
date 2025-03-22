{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.sites.mealie;
in {
  options.sites.mealie = with types; {
    enable = mkBoolOpt false "Enable mealie";
  };

  config = mkIf cfg.enable {
    services.mealie = {
      enable = true;
      port = 9090;
      listenAddress = "127.0.0.1";
    };
  };
}
