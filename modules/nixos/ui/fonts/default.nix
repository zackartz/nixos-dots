{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.ui.fonts;
in {
  options.ui.fonts = with types; {
    enable = mkBoolOpt false "Enable Custom Fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        material-icons
        material-design-icons
        roboto
        work-sans
        comic-neue
        source-sans
        twemoji-color-font
        comfortaa
        inter
        lato
        lexend
        jost
        dejavu_fonts
        iosevka-bin
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        jetbrains-mono
        (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono" "ZedMono"];})
        custom.zed-fonts
      ];

      enableDefaultPackages = false;

      # this fixes emoji stuff
      fontconfig = {
        defaultFonts = {
          monospace = [
            "Iosevka Nerd Font Complete Mono"
            "Iosevka Nerd Font"
            "Noto Color Emoji"
          ];
          sansSerif = ["Inter" "Noto Color Emoji"];
          serif = ["Noto Serif" "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
