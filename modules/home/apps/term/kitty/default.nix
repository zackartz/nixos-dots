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

    fonts = {
      # normal = mkStringOpt "JetBrainsMonoNL Nerd Font Mono Bold" "Normal Font";
      # bold = mkStringOpt "JetBrainsMonoNL Nerd Font Mono ExtraBold" "Bold Font";
      # italic = mkStringOpt "JetBrainsMonoNL Nerd Font Mono Bold Italic" "Italic Font";
      # bold_italic = mkStringOpt "JetBrainsMoIosevka ExtraBold ItalicnoNL Nerd Font Mono ExtraBold Italic" "Bold Italic Font";
      # normal = mkStringOpt "Kirsch Nerd Font Mono" "Normal Font";
      # bold = mkStringOpt "Kirsch Nerd Font Mono" "BBoldold Font";
      # italic = mkStringOpt "Kirsch Nerd Font Mono" "Italic Font";
      # bold_italic = mkStringOpt "Kirsch Nerd Font Mono" "Bold Italic Font";
      normal = mkStringOpt "PragmataPro Mono Liga" "Normal Font";
      bold = mkStringOpt "PragmataPro Mono Liga Bold" "Bold Font";
      italic = mkStringOpt "PragmataPro Mono Liga Italic" "Italic Font";
      bold_italic = mkStringOpt "PragmataPro Mono Liga Bold Italic" "Bold Italic Font";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = cfg.fonts.normal;
        size = 16;
      };

      extraConfig = ''
        bold_font ${cfg.fonts.bold}
        italic_font ${cfg.fonts.italic}
        bold_italic_font ${cfg.fonts.bold_italic}
      '';

      catppuccin.enable = true;

      settings = {
        window_padding_width = 12;
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
