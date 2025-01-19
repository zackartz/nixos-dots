{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.rice.qt;
in {
  options.rice.qt = with types; {
    enable = mkBoolOpt false "Enable QT Customization";
  };

  config = mkIf cfg.enable {
    catppuccin.kvantum.enable = true;
    catppuccin.kvantum.apply = true;

    qt.enable = true;
    qt.style.name = "kvantum";
    qt.platformTheme.name = "kvantum";
  };
}
