{...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      terminal = "kitty";
      startup = [{command = "firefox";}];

      output = {
        DP-1 = {
          mode = "2560x1440@240Hz";
        };
        HDMI-A-1 = {
          mode = "disable";
        };
      };
    };
    extraOptions = ["--unsupported-gpu"];
  };
}
