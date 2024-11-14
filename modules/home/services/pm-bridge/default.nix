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
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Bridge.";
    };

    nonInteractive = mkOption {
      type = types.bool;
      default = false;
      description = "Start Bridge entirely noninteractively";
    };

    logLevel = mkOption {
      type = types.enum ["panic" "fatal" "error" "warn" "info" "debug" "debug-client" "debug-server"];
      default = "info";
      description = "The log level";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.protonmail-bridge = {
      Unit = {
        Description = "Protonmail Bridge";
        After = ["network.target"];
      };

      Service = {
        Restart = "always";
        ExecStart = "${lib.getExe pkgs.hydroxide} serve";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
