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
        color = base.hex;
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
        text-color = text.hex;
        text-caps-lock-color = "";
        line-ver-color = rosewater.hex;
        ring-ver-color = rosewater.hex;
        inside-ver-color = base.hex;
        text-ver-color = text.hex;
        ring-wrong-color = teal.hex;
        text-wrong-color = teal.hex;
        inside-wrong-color = base.hex;
        inside-clear-color = base.hex;
        text-clear-color = text.hex;
        ring-clear-color = lavender.hex;
        line-clear-color = base.hex;
        line-wrong-color = base.hex;
        bs-hl-color = teal.hex;
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
