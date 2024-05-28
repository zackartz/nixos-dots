{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.lock;
in {
  options.services.lock = with types; {
    enable = mkBoolOpt false "Enable Hypridle Service";
  };

  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      catppuccin.enable = false;
      package = pkgs.swaylock-effects;
      settings = with colors; {
        clock = true;
        color = base;
        font = "Work Sans";
        image = "${wallpaper}";
        show-failed-attempts = false;
        indicator = true;
        indicator-radius = 200;
        indicator-thickness = 20;
        line-color = "00000000";
        ring-color = "00000000";
        inside-color = "00000000";
        key-hl-color = "f2cdcd";
        separator-color = "00000000";
        text-color = text;
        text-caps-lock-color = "";
        line-ver-color = love;
        ring-ver-color = rose;
        inside-ver-color = base;
        text-ver-color = text;
        ring-wrong-color = foam;
        text-wrong-color = foam;
        inside-wrong-color = base;
        inside-clear-color = base;
        text-clear-color = text;
        ring-clear-color = iris;
        line-clear-color = base;
        line-wrong-color = base;
        bs-hl-color = foam;
        line-uses-ring = false;
        grace = 2;
        grace-no-mouse = true;
        grace-no-touch = true;
        datestr = "%d.%m";
        fade-in = "0.1";
        ignore-empty-password = true;
      };
    };

    systemd.user.services.hypridle = {
      Unit = {
        Description = "Idle Daemon for Hyprland";
      };
      Service = {
        Type = "simple";
        ExecStart = lib.getExe inputs.hypridle.packages.${pkgs.system}.hypridle;
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["hyprland-session.target"];
      };
    };

    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = ${pkgs.swaylock-effects}/bin/swaylock -fF
          before_sleep_cmd = ${pkgs.swaylock-effects}/bin/swaylock -fF    # command ran before sleep
          ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
      }

      listener {
          timeout = 300                            # in seconds
          on-timeout = ${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off
          on-resume = ${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on
      }
    '';
  };
}
