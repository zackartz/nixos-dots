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

    fonts = {
      # normal = mkStringOpt "JetBrainsMonoNL Nerd Font Mono Bold" "Normal Font";
      # bold = mkStringOpt "JetBrainsMonoNL Nerd Font Mono ExtraBold" "Bold Font";
      # italic = mkStringOpt "JetBrainsMonoNL Nerd Font Mono Bold Italic" "Italic Font";
      # bold_italic = mkStringOpt "JetBrainsMonoNL Nerd Font Mono ExtraBold Italic" "Bold Italic Font";
      normal = mkStringOpt "Iosevka" "Normal Font";
      bold = mkStringOpt "Iosevka ExtraBold" "Bold Font";
      italic = mkStringOpt "Iosevka Bold Italic" "Italic Font";
      bold_italic = mkStringOpt "Iosevka ExtraBold Italic" "Bold Italic Font";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      settings = {
        font-family = cfg.fonts.normal;
        gtk-single-instance = true;
        gtk-titlebar = false;
      };
    };
  };
}
