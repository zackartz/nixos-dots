{
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.direnv;
in {
  options.apps.tools.direnv = with types; {
    enable = mkBoolOpt false "Enable Direnv";
  };

  config = mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        config = {
          global = {
            log_format = "-";
            log_filter = "^$";
          };
        };
      };
    };
    home.sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
