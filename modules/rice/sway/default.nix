{
  wayland.windowManager.sway = {
    enable = true;
    # package = pkgs.swayfx;
    catppuccin.enable = true;
    config = {
      terminal = "kitty";
      startup = [{command = "firefox";}];

      input = {
        "Logitech USB Receiver Keyboard" = {
          accel_profile = "flat";
          pointer_accel = "0.5";
        };
        "Logitech USB Receiver" = {
          accel_profile = "flat";
          pointer_accel = "0.5";
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
}
