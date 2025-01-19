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
        # (let
        #   bolder = writeText "bolder.py" ''
        #     #!/usr/bin/env python
        #     # Script shamelessly stolen from: https://github.com/shytikov/pragmasevka
        #
        #     import sys
        #     import fontforge
        #
        #     if len(sys.argv) < 2:
        #         print("Please provide path prefix of the font to update!")
        #         exit()
        #
        #     prefix = sys.argv[1]
        #
        #     glyphs = [
        #         "exclam", "ampersand", "parenleft", "parenright", "asterisk", "plus",
        #         "comma", "hyphen", "period", "slash", "colon", "semicolon", "less",
        #         "equal", "greater", "question", "bracketleft", "backslash", "bracketright",
        #         "asciicircum", "braceleft", "bar", "braceright", "asciitilde",
        #     ]
        #
        #     pairs = [
        #         ['regular', 'semibold'],
        #         ['regularItalic', 'semiboldItalic'],
        #         ['bold', 'black'],
        #         ['boldItalic', 'blackItalic'],
        #     ]
        #
        #     for [recipient, donor] in pairs:
        #         font = f"{prefix}{recipient}.ttf"
        #         donor_font = f"{prefix}{donor}.ttf"
        #
        #         target = fontforge.open(font)
        #         # Finding all punctuation
        #         target.selection.select(*glyphs)
        #         # and deleting it to make space
        #         for i in target.selection.byGlyphs:
        #             target.removeGlyph(i)
        #
        #         source = fontforge.open(donor_font)
        #         source.selection.select(*glyphs)
        #         source.copy()
        #         target.paste()
        #
        #         target.generate(font)
        #   '';
        # in (iosevka.override
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
        #       [buildPlans.IosevkaCustom.variants]
        #       inherits = "ss08"
        #     '';
        #   }))
        # .overrideAttrs (oldAttrs: {
        #   buildInputs =
        #     (oldAttrs.buildInputs or [])
        #     ++ [
        #       pkgs.python3
        #       pkgs.python3Packages.fontforge
        #     ];
        #
        #   postInstall = ''
        #     ${oldAttrs.postInstall or ""}
        #
        #     echo $out
        #
        #     cd $out/share/fonts/truetype
        #
        #     PREFIX="IosevkaCustom-normal"
        #
        #     python3 ${bolder} $PREFIX
        #   '';
        # }))
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        jetbrains-mono
        nerd-fonts.iosevka
        nerd-fonts.zed-mono
        # (nerdfonts.override {fonts = ["ZedMono" "Iosevka"];})
      ];

      enableDefaultPackages = false;

      # this fixes emoji stuff
      fontconfig = {
        defaultFonts = {
          monospace = [
            "Pragmata Pro Mono"
            # "Iosevka"
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
