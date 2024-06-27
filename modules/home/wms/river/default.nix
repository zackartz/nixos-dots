{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.wms.river;
in {
  options.wms.river = with types; {
    enable = mkBoolOpt false "Enable River WM";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.river = {
      enable = true;
      settings = {
        spawn = [
          "firefox"
          "kitty"
        ];
      };
    };
  };
}
