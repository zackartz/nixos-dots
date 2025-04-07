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
      normal = mkStringOpt "CozetteVector" "Normal Font";
      bold = mkStringOpt "CozetteVector" "Bold Font";
      italic = mkStringOpt "CozetteVector" "Italic Font";
      bold_italic = mkStringOpt "CozetteVector" "Bold Italic Font";
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
        # background = "#000000";
      };
    };
  };
}
