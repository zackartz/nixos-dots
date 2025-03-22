{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.pywal2;
in {
  options = {programs.pywal2 = {enable = mkEnableOption "pywal";};};

  config = mkIf cfg.enable {
    home.packages = [pkgs.pywal];

    programs.zsh.initExtra = ''
      # Import colorscheme from 'wal' asynchronously
      # &   # Run the process in the background.
      # ( ) # Hide shell job control messages.
      (cat ${config.xdg.cacheHome}/wal/sequences &)
    '';

    programs.kitty.extraConfig = ''
      include ${config.xdg.cacheHome}/wal/colors-kitty.conf
    '';

    programs.rofi.theme."@import" = "${config.xdg.cacheHome}/wal/colors-rofi-dark.rasi";
  };
}
