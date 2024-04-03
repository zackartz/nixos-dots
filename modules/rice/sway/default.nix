{...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      terminal = "kitty";
      startup = [{command = "firefox";}];

      output = {
        DP-1 = {
          mode = "2560x1440@239.972Hz";
        };
      };
    };
    extraOptions = ["--unsupported-gpu"];
  };
}
