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
      # package = inputs.rio-term.packages.${pkgs.system}.default;
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
            family = "Iosevka";
            style = "Normal";
            weight = 700;
          };

          bold = {
            family = "Iosevka";
            style = "Normal";
            weight = 800;
          };

          italic = {
            family = "Iosevka";
            style = "Italic";
            weight = 700;
          };

          bold-italic = {
            family = "Iosevka";
            style = "Italic";
            weight = 800;
          };
        };
      };
    };
  };
}
