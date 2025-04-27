{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.term.foot;
in {
  options.apps.term.foot = with types; {
    enable = mkBoolOpt false "Enable Foot Terminal";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "Iosevka:weight=bold:size=20";
        };
        colors = {
          alpha = "0.9";

          # Custom colors from lib/theme/default.nix
          foreground = "${colors.text.hex}";
          background = "${colors.crust.hex}";

          # Normal colors
          regular0 = "${colors.surface1.hex}"; # black
          regular1 = "${colors.red.hex}"; # red
          regular2 = "${colors.green.hex}"; # green
          regular3 = "${colors.yellow.hex}"; # yellow
          regular4 = "${colors.blue.hex}"; # blue
          regular5 = "${colors.mauve.hex}"; # magenta
          regular6 = "${colors.teal.hex}"; # cyan
          regular7 = "${colors.text.hex}"; # white

          # Bright colors
          bright0 = "${colors.surface2.hex}"; # bright black
          bright1 = "${colors.red.hex}"; # bright red
          bright2 = "${colors.green.hex}"; # bright green
          bright3 = "${colors.yellow.hex}"; # bright yellow
          bright4 = "${colors.blue.hex}"; # bright blue
          bright5 = "${colors.mauve.hex}"; # bright magenta
          bright6 = "${colors.teal.hex}"; # bright cyan
          bright7 = "${colors.text.hex}"; # bright white
        };
      };
    };
  };
}
