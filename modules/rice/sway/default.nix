{
  pkgs,
  lib,
  theme,
  ...
}: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  wayland.windowManager.sway = {
    enable = true;
    # package = pkgs.swayfx;
    catppuccin.enable = true;
    config = {
      terminal = "kitty";
      startup = [{command = "firefox";}];

      menu = "wofi --show drun";

      input = {
        "Logitech USB Receiver Keyboard" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
        "Logitech USB Receiver" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
      };

      output = {
        DP-1 = {
          mode = "2560x1440@239.972Hz";
        };
        HDMI-A-1 = {
          disable = "disable";
        };
      };
    };
    extraOptions = ["--unsupported-gpu"];
  };

  systemd.user.services = {
    swaybg = mkService {
      Unit.Description = "Wallpaper chooser";
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${theme.wallpaper}";
        Restart = "always";
      };
    };
  };
}
