{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.wms.sway;
in {
  options.wms.sway = with types; {
    enable = mkBoolOpt false "Enable Sway";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      xwayland = true;
      extraOptions = ["--unsupported-gpu"];
    };
  };
}
