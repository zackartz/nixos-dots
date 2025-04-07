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
        # (iosevka.override
        #   {
        #     set = "Custom";
        #     privateBuildPlan = ''
        #       [buildPlans.IosevkaCustom]
        #       family = "Iosevka"
        #       spacing = "normal"
        #       serifs = "sans"
        #       noCvSs = true
        #       exportGlyphNames = true
        #
        #         [buildPlans.IosevkaCustom.variants]
        #         inherits = "ss05"
        #
        #           [buildPlans.IosevkaCustom.variants.design]
        #           l = "hooky"
        #
        #       [buildPlans.IosevkaCustom.widths.Normal]
        #       shape = 500
        #       menu = 5
        #       css = "normal"
        #
        #       [buildPlans.IosevkaCustom.widths.Extended]
        #       shape = 600
        #       menu = 7
        #       css = "expanded"
        #
        #       [buildPlans.IosevkaCustom.widths.SemiCondensed]
        #       shape = 456
        #       menu = 4
        #       css = "semi-condensed"
        #
        #       [buildPlans.IosevkaCustom.widths.SemiExtended]
        #       shape = 548
        #       menu = 6
        #       css = "semi-expanded"
        #     '';
        #   })
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        jetbrains-mono
        nerd-fonts.iosevka
        nerd-fonts.zed-mono
        adwaita-fonts
        cozette
        scientifica
        # (nerdfonts.override {fonts = ["ZedMono" "Iosevka"];})
      ];

      enableDefaultPackages = false;

      # this fixes emoji stuff
      fontconfig = {
        defaultFonts = {
          monospace = [
            # "Pragmata Pro Mono"
            "Iosevka"
            "Noto Color Emoji"
          ];
          sansSerif = ["Adwaita Sans" "Noto Color Emoji"];
          serif = ["Noto Serif" "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
