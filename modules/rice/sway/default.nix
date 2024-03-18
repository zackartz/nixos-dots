{...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      terminal = "kitty";
      startup = [{command = "firefox";}];
    };
    extraOptions = ["--unsupported-gpu"];
  };
}
