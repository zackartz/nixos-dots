{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.term.rio;
in {
  options.apps.term.rio = with types; {
    enable = mkBoolOpt false "Enable Rio Terminal";
  };

  config = mkIf cfg.enable {
    programs.rio = {
      enable = true;
      settings = {
        window = {
          opacity = 0.9;
          blur = true;
        };

        padding-x = 10;
        padding-y = [10 10];

        navigation = {
          mode = "Plain";
        };

        fonts = {
          regular = {
            family = fonts.mono;
            style = "Normal";
            weight = 400;
          };

          bold = {
            family = fonts.mono;
            style = "Normal";
            weight = 700;
          };

          italic = {
            family = fonts.mono;
            style = "Italic";
            weight = 400;
          };

          bold-italic = {
            family = fonts.mono;
            style = "Italic";
            weight = 700;
          };
        };
      };
    };
  };
}
