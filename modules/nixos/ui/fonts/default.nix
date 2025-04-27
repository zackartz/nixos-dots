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
        # iosevka
        cantarell-fonts
        (iosevka.override
          {
            set = "Custom";
            privateBuildPlan = ''
              # [buildPlans.IosevkaCustom]
              # family = "Iosevka"
              # spacing = "fontconfig-mono"
              # serifs = "sans"
              # noCvSs = true
              # exportGlyphNames = true
              #
              #   [buildPlans.IosevkaCustom.variants]
              #   inherits = "ss08"
              #
              # [buildPlans.IosevkaCustom.widths.Normal]
              # shape = 500
              # menu = 5
              # css = "normal"
              #
              # [buildPlans.IosevkaCustom.widths.Extended]
              # shape = 600
              # menu = 7
              # css = "expanded"

              [buildPlans.IosevkaCustom]
              family = "Iosevka"
              spacing = "normal"
              serifs = "sans"
              noCvSs = true
              exportGlyphNames = true

                [buildPlans.IosevkaCustom.variants]
                inherits = "ss17"

                  [buildPlans.IosevkaCustom.variants.design]
                  capital-e = "top-left-serifed"
                  capital-u = "toothed-bottom-right-serifed"
                  f = "tailed"
                  m = "short-leg-top-left-and-bottom-right-serifed"
                  paren = "flat-arc"

                [buildPlans.IosevkaCustom.ligations]
                inherits = "dlig"

                [buildPlans.IosevkaCustom.weights.Regular]
                shape = 400
                menu = 400
                css = 400

                [buildPlans.IosevkaCustom.weights.Medium]
                shape = 500
                menu = 500
                css = 500

                [buildPlans.IosevkaCustom.weights.SemiBold]
                shape = 600
                menu = 600
                css = 600

                [buildPlans.IosevkaCustom.weights.Bold]
                shape = 700
                menu = 700
                css = 700

                [buildPlans.IosevkaCustom.slopes.Upright]
                angle = 0
                shape = "upright"
                menu = "upright"
                css = "normal"

                [buildPlans.IosevkaCustom.slopes.Italic]
                angle = 9.4
                shape = "italic"
                menu = "italic"
                css = "italic"
            '';
          })
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
