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
      # normal = {
      #   family = mkStringOpt "Cozette" "The Family of the font";
      #   # style = mkStringOpt "ExtraBold" "The Style of the font";
      # };
      # bold = {
      #   family = mkStringOpt "Cozette" "The Family of the font";
      #   # style = mkStringOpt "Heavy" "The Style of the font";
      # };
      # italic = {
      #   family = mkStringOpt "Cozette" "The Family of the font";
      #   # style = mkStringOpt "ExtraBold Italic" "The Style of the font";
      # };
      # bold_italic = {
      #   family = mkStringOpt "Cozette" "The Family of the font";
      #   # style = mkStringOpt "Heavy Italic" "The Style of the font";
      # };

      normal = {
        family = mkStringOpt "Iosevka Nerd Font Mono" "The Family of the font";
        style = mkStringOpt "SemiBold" "The Style of the font";
      };
      bold = {
        family = mkStringOpt "Iosevka Nerd Font Mono" "The Family of the font";
        style = mkStringOpt "Bold" "The Style of the font";
      };
      italic = {
        family = mkStringOpt "Iosevka Nerd Font Mono" "The Family of the font";
        style = mkStringOpt "SemiBold Italic" "The Style of the font";
      };
      bold_italic = {
        family = mkStringOpt "Iosevka Nerd Font Mono" "The Family of the font";
        style = mkStringOpt "Bold Italic" "The Style of the font";
      };

      # normal = {
      #   family = mkStringOpt "PragmataPro" "The Family of the font";
      #   # style = mkStringOpt "" "The Style of the font";
      # };
      # bold = {
      #   family = mkStringOpt "PragmataPro" "The Family of the font";
      #   style = mkStringOpt "Bold" "The Style of the font";
      # };
      # italic = {
      #   family = mkStringOpt "PragmataPro" "The Family of the font";
      #   style = mkStringOpt "Italic" "The Style of the font";
      # };
      # bold_italic = {
      #   family = mkStringOpt "PragmataPro" "The Family of the font";
      #   style = mkStringOpt "Bold Italic" "The Style of the font";
      # };
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      catppuccin.enable = true;

      settings = {
        colors = {
          primary.background = colors.crust.hex;
        };
        env = {
          term = "xterm-256color";
        };
        cursor = {
          style = {
            shape = "Beam";
          };
          vi_mode_style = {
            shape = "Beam";
          };
        };
        window = {
          # opacity = 0.95;
          padding = {
            x = 20;
            y = 20;
          };
        };
        font = {
          size = 16.0;
          normal = fonts.mono;
          bold = "${fonts.mono} Bold";
          italic = "${fonts.mono} Italic";
          bold_italic = "${fonts.mono} Bold Italic";

          offset = {
            x = 0;
            y = 0;
          };
        };
      };
    };
  };
}
