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

              [buildPlans.IosevkaCustom.variants.design]
              one = "base-flat-top-serif"
              two = "straight-neck-serifless"
              four = "closed-serifless"
              five = "oblique-arched-serifless"
              six = "closed-contour"
              seven = "bend-serifless"
              eight = "crossing-asymmetric"
              nine = "closed-contour"
              zero = "oval-dotted"
              capital-d = "more-rounded-serifless"
              capital-g = "toothless-corner-serifless-hooked"
              a = "double-storey-serifless"
              g = "double-storey"
              i = "hooky"
              l = "serifed-semi-tailed"
              r = "hookless-serifless"
              t = "bent-hook-short-neck"
              w = "straight-flat-top-serifless"
              y = "straight-turn-serifless"
              capital-eszet = "rounded-serifless"
              long-s = "bent-hook-middle-serifed"
              eszet = "longs-s-lig-serifless"
              lower-lambda = "straight-turn"
              lower-tau = "short-tailed"
              lower-phi = "straight"
              partial-derivative = "closed-contour"
              cyrl-capital-u = "straight-turn-serifless"
              cyrl-u = "straight-turn-serifless"
              cyrl-ef = "split-serifless"
              asterisk = "penta-low"
              caret = "high"
              guillemet = "straight"
              number-sign = "slanted"
              dollar = "open"
              cent = "through-cap"
              bar = "force-upright"
              micro-sign = "tailed-serifless"
              lig-ltgteq = "slanted"
              lig-neq = "more-slanted-dotted"
              lig-equal-chain = "without-notch"
              lig-hyphen-chain = "without-notch"
              lig-plus-chain = "with-notch"

              [buildPlans.IosevkaCustom.weights.Regular]
              shape = 400
              menu = 400
              css = 400

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
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
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
            fonts.mono
            "Noto Color Emoji"
          ];
          sansSerif = [fonts.ui "Noto Color Emoji"];
          serif = [fonts.ui "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
