{
  options,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.helpers.snc;
in {
  options.apps.helpers.snc = with types; {
    enable = mkBoolOpt false "Enable Sway Notification Center";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [swaynotificationcenter];

      # Copy the theme file to the correct location
      file.".config/swaync/style.css".source = ./theme/ctp.css;

      # Create default config file
      file.".config/swaync/config.json".text = builtins.toJSON {
        "$schema" = "/etc/xdg/swaync/configSchema.json";
        "positionX" = "right";
        "positionY" = "top";
        "layer" = "overlay";
        "control-center-margin-top" = 0;
        "control-center-margin-bottom" = 0;
        "control-center-margin-right" = 0;
        "control-center-margin-left" = 0;
        "notification-icon-size" = 64;
        "notification-body-image-height" = 100;
        "notification-body-image-width" = 200;
        "timeout" = 10;
        "timeout-low" = 5;
        "timeout-critical" = 0;
        "fit-to-screen" = true;
        "control-center-width" = 500;
        "notification-window-width" = 500;
        "keyboard-shortcuts" = true;
        "image-visibility" = "when-available";
        "transition-time" = 200;
        "hide-on-clear" = false;
        "hide-on-action" = true;
        "script-fail-notify" = true;
        "scripts" = {};
        "notification-visibility" = {};
        "widgets" = [
          "title"
          "dnd"
          "notifications"
        ];
      };
    };

    # Add systemd user service
    systemd.user.services.swaync = {
      Unit = {
        Description = "Sway Notification Center";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        ExecReload = "${pkgs.swaynotificationcenter}/bin/swaync-client --reload-config";
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
