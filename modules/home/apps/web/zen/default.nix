{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.web.zen;
in {
  options.apps.web.zen = with types; {
    enable = mkBoolOpt false "Enable or disable zen";

    setDefault = mkBoolOpt false "Set zen as default browser";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = mkIf cfg.setDefault {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
    };
  };
}
