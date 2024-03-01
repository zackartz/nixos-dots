# home.nix
{theme, ...}: {
  wayland.windowManager.hyprland.settings = with theme.colors; {
    exec-once = [
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "pw-loopback -C \"alsa_input.pci-0000_0d_00.4.analog-stereo\""
    ];

    "plugin:borders-plus-plus" = {
      add_borders = 1;

      "col.border_1" = "rgb(${rose})";
      "col.border_2" = "rgb(${love})";

      border_size_1 = 6;

      natural_rounding = "yes";
    };

    general = {
      # gaps
      gaps_in = 6;
      gaps_out = 11;

      # border thiccness
      border_size = 4;

      # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      apply_sens_to_raw = 0;

      # active border color
      "col.active_border" = "rgb(${rose})";
      "col.inactive_border" = "rgb(${muted})";
    };

    input = {
      kb_layout = "us";
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      accel_profile = "flat";
      force_no_accel = true;
    };

    decoration = {
      # fancy corners
      rounding = 12;
      # blur
      blur = {
        enabled = true;
        size = 3;
        passes = 6;
        ignore_opacity = false;
        new_optimizations = 1;
        contrast = 0.7;
        brightness = 0.8;
      };

      # shadow config
      drop_shadow = "no";
      shadow_range = 20;
      shadow_render_power = 5;
      "col.shadow" = "rgba(292c3cee)";
    };

    misc = {
      # disable redundant renders
      disable_splash_rendering = true;
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;

      vfr = true;

      # window swallowing
      enable_swallow = true; # hide windows that spawn other windows
      swallow_regex = "^(foot)$";

      # dpms
      mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
      key_press_enables_dpms = true; # enable dpms on keyboard action
      disable_autoreload = true; # autoreload is unnecessary on nixos, because the config is readonly anyway
    };

    xwayland = {
      force_zero_scaling = true;
    };

    monitor = ["DP-1,2560x1440@240,0x0,1" "HDMI-A-1,disable"];
  };
}
