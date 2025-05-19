{
  options,
  pkgs,
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
        name = fonts.mono;
        size = 16;
      };

      extraConfig = ''
        bold_font ${fonts.mono} Bold Italic
        italic_font ${fonts.mono} Italic
        bold_italic_font ${fonts.mono} Bold Italic

        shell ${lib.getExe pkgs.nushell}
      '';

      catppuccin.enable = true;

      settings = {
        window_padding_width = 20;
        # background_opacity = "0.9";
        background = colors.crust.hex;
        foreground = colors.text.hex;

        # Normal colors
        color0 = colors.surface1.hex; # black
        color1 = colors.red.hex; # red
        color2 = colors.green.hex; # green
        color3 = colors.yellow.hex; # yellow
        color4 = colors.blue.hex; # blue
        color5 = colors.mauve.hex; # magenta
        color6 = colors.teal.hex; # cyan
        color7 = colors.text.hex; # white

        # Bright colors
        color8 = colors.surface2.hex; # bright black
        color9 = colors.red.hex; # bright red
        color10 = colors.green.hex; # bright green
        color11 = colors.yellow.hex; # bright yellow
        color12 = colors.blue.hex; # bright blue
        color13 = colors.mauve.hex; # bright magenta
        color14 = colors.teal.hex; # bright cyan
        color15 = colors.text.hex; # bright white
      };
    };
  };
}
