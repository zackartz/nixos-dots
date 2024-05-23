{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.bat;
in {
  options.apps.tools.bat = with types; {
    enable = mkBoolOpt false "Enable Bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;

      catppuccin.enable = true;

      config = {
        pager = "less -FR";
      };
    };
  };
}
