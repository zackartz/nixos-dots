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
        family = mkStringOpt "ZedMono NFM" "The Family of the font";
        style = mkStringOpt "Bold" "The Style of the font";
      };
      bold = {
        family = mkStringOpt "ZedMono NFM" "The Family of the font";
        style = mkStringOpt "ExtraBold" "The Style of the font";
      };
      italic = {
        family = mkStringOpt "ZedMono NFM" "The Family of the font";
        style = mkStringOpt "Bold Italic" "The Style of the font";
      };
      bold_italic = {
        family = mkStringOpt "ZedMono NFM" "The Family of the font";
        style = mkStringOpt "ExtraBold Italic" "The Style of the font";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      catppuccin.enable = true;

      settings = {
        background_opacity = "0.75";
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
