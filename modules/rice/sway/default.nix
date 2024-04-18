{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    # package = pkgs.swayfx;
    config = rec {
      terminal = "kitty";
      startup = [{command = "firefox";}];

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
