# home.nix
{theme, ...}: {
  wayland.windowManager.hyprland.settings = with theme.colors; {
    exec-once = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    ];

    general = {
      # gaps
      gaps_in = 6;
      gaps_out = 11;

      # border thiccness
      border_size = 2;

      # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      apply_sens_to_raw = 0;

      # active border color
      # "col.active_border" = "rgb(${rose}) rgb(${pine}) rgb(${love}) rgb(${iris}) 90deg";
      # "col.inactive_border" = "rgb(${muted})";
    };

    input = {
      kb_layout = "us";
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      accel_profile = "flat";
      force_no_accel = true;
    };

    decoration = {
      # fancy corners
      rounding = 7;
      # blur
      blur = {
        enabled = true;
        size = 3;
        passes = 3;
        ignore_opacity = false;
        new_optimizations = 1;
        xray = true;
        contrast = 0.7;
        brightness = 0.8;
      };

      # shadow config
      drop_shadow = "no";
      shadow_range = 20;
      shadow_render_power = 5;
      "col.shadow" = "rgba(292c3cee)";
    };

    xwayland = {
      force_zero_scaling = true;
    };

    monitor = ["DP-1,2560x1440@240,0x0,1" "HDMI-A-1,disable"];
  };
}
