{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.web.librewolf;
in {
  options.apps.web.librewolf = with types; {
    enable = mkBoolOpt false "Enable librewolf";

    setDefault = mkBoolOpt false "Set Librewolf to default";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = mkIf cfg.setDefault {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "image/png" = "feh.desktop";
    };

    programs.librewolf = {
      enable = true;
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };
  };
}
