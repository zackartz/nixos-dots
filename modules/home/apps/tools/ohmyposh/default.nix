{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.ohmyposh;
in {
  options.apps.tools.ohmyposh = with types; {
    enable = mkBoolOpt false "Enable OhMyPosh";
  };

  config = mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "catppuccin";
    };
  };
}
