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
        iosevka
        cantarell-fonts
        # (iosevka.override {
        #   set = "Custom";
        #   privateBuildPlan = ''
        #     [buildPlans.IosevkaCustom]
        #     family = "Iosevka"
        #     spacing = "normal"
        #     serifs = "sans"
        #     noCvSs = true
        #     exportGlyphNames = true
        #
        #       [buildPlans.IosevkaCustom.variants]
        #       inherits = "ss03"
        #   '';
        # })
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        jetbrains-mono
        nerd-fonts.iosevka
        # (nerdfonts.override {fonts = ["ZedMono" "Iosevka"];})
      ];

      enableDefaultPackages = false;

      # this fixes emoji stuff
      fontconfig = {
        defaultFonts = {
          monospace = [
            # "ZedMono Nerd Font Mono"
            "Iosevka"
            "Noto Color Emoji"
          ];
          sansSerif = ["Cantarell" "Noto Color Emoji"];
          serif = ["Noto Serif" "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
