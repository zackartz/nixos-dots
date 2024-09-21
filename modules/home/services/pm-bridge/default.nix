{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.pm-bridge;
in {
  options.services.pm-bridge = with types; {
    enable = mkBoolOpt false "Enable Protonmail Bridge";

    package = lib.mkPackageOption pkgs "protonmail-bridge" {};

    logLevel = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "panic"
          "fatal"
          "error"
          "warn"
          "info"
          "debug"
        ]
      );
      default = null;
      description = "Log level of the Proton Mail Bridge service. If set to null then the service uses it's default log level.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "A Bridge to view Protonmail Messages in your local email client";
      };
      Service = let
        logLevel = lib.optionalString (cfg.logLevel != null) "--log-level ${cfg.logLevel}";
      in {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} --noninteractive ${logLevel}";
        Restart = "always";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
