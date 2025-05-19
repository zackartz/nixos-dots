{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.gdm-monitors;

  montiorsXmlContent = builtins.readFile ./monitors.xml;
  monitorsConfig = pkgs.writeText "gdm_monitors.xml" montiorsXmlContent;
in {
  options.services.gdm-monitors = with types; {
    enable = mkBoolOpt false "Enable Monitors config for GDM";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
    ];
  };
}
