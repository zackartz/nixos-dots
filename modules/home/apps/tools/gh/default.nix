{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.gh;
in {
  options.apps.tools.gh = with types; {
    enable = mkBoolOpt false "Enable GitHub CLI";
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;

      extensions = with pkgs; [
        pkgs.gh-dash
      ];
    };
  };
}
