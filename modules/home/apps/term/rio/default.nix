{
  lib,
  config,
  pkgs,
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
            family = "Iosevka";
            style = "normal";
            weight = 700;
          };

          bold = {
            family = "Iosevka";
            style = "normal";
            weight = 800;
          };

          italic = {
            family = "Iosevka";
            style = "italic";
            weight = 700;
          };

          bold-italic = {
            family = "Iosevka";
            style = "italic";
            weight = 800;
          };
        };
      };
    };
  };
}
