{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.term.alacritty;
in {
  options.apps.term.alacritty = with types; {
    enable = mkBoolOpt false "Enable Alacritty Term";

    fonts = {
      normal = {
        family = mkStringOpt "Iosevka" "The Family of the font";
        style = mkStringOpt "ExtraBold" "The Style of the font";
      };
      bold = {
        family = mkStringOpt "Iosevka" "The Family of the font";
        style = mkStringOpt "Heavy" "The Style of the font";
      };
      italic = {
        family = mkStringOpt "Iosevka" "The Family of the font";
        style = mkStringOpt "ExtraBold Italic" "The Style of the font";
      };
      bold_italic = {
        family = mkStringOpt "Iosevka" "The Family of the font";
        style = mkStringOpt "Heavy Italic" "The Style of the font";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      catppuccin.enable = true;

      settings = {
        window = {
          opacity = 0.95;
          padding = {
            x = 20;
            y = 20;
          };
        };
        font = {
          normal = cfg.fonts.normal;
          bold = cfg.fonts.bold;
          italic = cfg.fonts.italic;
          bold_italic = cfg.fonts.bold_italic;
        };
      };
    };
  };
}
