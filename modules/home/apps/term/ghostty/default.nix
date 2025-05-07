{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.term.ghostty;
in {
  options.apps.term.ghostty = with types; {
    enable = mkBoolOpt false "Enable Ghostty Term";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      settings = {
        font-family = fonts.mono;
        gtk-single-instance = true;
        gtk-titlebar = false;

        background = colors.crust.hex;

        window-padding-x = 20;
        window-padding-y = 20;
        window-padding-balance = true;
        font-style = "SemiBold";
        font-style-bold = "Bold";
        font-style-italic = "SemiBold Italic";
        font-style-bold-italic = "Bold Italic";
      };
    };
  };
}
