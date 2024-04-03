{...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      terminal = "kitty";
      startup = [{command = "firefox";}];

      output = {
        DP-1 = {
          mode = "2560x1440@240Hz";
          adaptive_sync = "on";
        };
        HDMI-A-1 = {
          disable = "disable";
        };
      };
    };
    extraOptions = ["--unsupported-gpu"];
  };
}
