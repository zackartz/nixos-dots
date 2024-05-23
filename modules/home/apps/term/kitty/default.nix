{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.term.kitty;
in {
  options.apps.term.kitty = with types; {
    enable = mkBoolOpt false "Enable Kitty Term";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka Term SemiBold";
        size = 14;
      };

      extraConfig = ''
        bold_font Iosevk Term Heavy
        italic_font Iosevka Term SemiBold Italic
        bold_italic_font Iosevka Term Heavy Italic
      '';

      catppuccin.enable = true;

      settings = {
        window_padding_width = 12;
        background_opacity = "0.8";
      };
    };
  };
}
