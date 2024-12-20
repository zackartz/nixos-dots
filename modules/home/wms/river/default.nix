{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.wms.river;

  super = "Super";
in {
  options.wms.river = with types; {
    enable = mkBoolOpt false "Enable River WM";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.river = {
      enable = true;
      settings = {
        spawn = [
          "zen"
          "ghostty"
        ];

        map = {
          normal = {
            "${super} Return" = "spawn ghostty";
            "${super} Q" = "close";
            "${super} M" = "exit";
            "${super} D" = "spawn anyrun";
            "${super} J" = "focus-view next";
            "${super} K" = "focus-view previous";
            "${super}+Shift J" = "swap next";
            "${super}+Shift K" = "swap previous";
          };
        };

        map-pointer = {
          normal = {
            "${super} BTN_LEFT" = "move-view";
            "${super} BTN_RIGHT" = "resize-view";
            "${super} BTN_MIDDLE" = "toggle-float";
          };
        };
      };
    };
  };
}
