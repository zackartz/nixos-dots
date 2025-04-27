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
      # normal = mkStringOpt "Pragmata Pro Mono" "Normal Font";
      # bold = mkStringOpt "Pragmata Pro Mono" "Bold Font";
      # italic = mkStringOpt "Iosevka Bold Italic" "Italic Font";
      # bold_italic = mkStringOpt "Iosevka ExtraBold Italic" "Bold Italic Font";

      normal = mkStringOpt "Cozette" "Normal";
      bold = mkStringOpt "Cozette" "Bold";
      italic = mkStringOpt "Cozette" "Italic";
      bold_italic = mkStringOpt "Cozette" "Bold Italic";

      # normal = mkStringOpt "Iosevka Nerd Font Mono" "Normal Font";
      # bold = mkStringOpt "Iosevka Nerd Font Mono" "Bold Font";
      # italic = mkStringOpt "Iosevka Nerd Font Mono" "Italic Font";
      # bold_italic = mkStringOpt "Iosevka Nerd Font Mono" "Bold Italic Font";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      settings = {
        font-family = cfg.fonts.normal;
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
