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
      normal = mkStringOpt "JetBrainsMonoNL Nerd Font Mono Bold" "Normal Font";
      bold = mkStringOpt "JetBrainsMonoNL Nerd Font Mono ExtraBold" "Bold Font";
      italic = mkStringOpt "JetBrainsMonoNL Nerd Font Mono Bold Italic" "Italic Font";
      bold_italic = mkStringOpt "JetBrainsMonoNL Nerd Font Mono ExtraBold Italic" "Bold Italic Font";
      # normal = mkStringOpt "Iosevka Bold" "Normal Font";
      # bold = mkStringOpt "Iosevka ExtraBold" "Bold Font";
      # italic = mkStringOpt "Iosevka Bold Italic" "Italic Font";
      # bold_italic = mkStringOpt "Iosevka ExtraBold Italic" "Bold Italic Font";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = cfg.fonts.normal;
        size = 14;
      };

      extraConfig = ''
        bold_font ${cfg.fonts.bold}
        italic_font ${cfg.fonts.italic}
        bold_italic_font ${cfg.fonts.bold_italic}
      '';

      catppuccin.enable = true;

      settings = {
        window_padding_width = 12;
        background_opacity = "0.9";
      };
    };
  };
}
