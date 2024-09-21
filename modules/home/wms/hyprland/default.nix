{
  options,
  config,
  lib,
  inputs,
  system,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.wms.hyprland;

  mkService = recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };

  mod = "SUPER";
  modshift = "${mod}SHIFT";

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10} (stolen from fufie)
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "${mod}, ${ws}, workspace, ${toString (x + 1)}"
        "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  options.wms.hyprland = with types; {
    enable = mkBoolOpt false "Enable Hyprland";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs-unstable.xwayland
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;

      systemd = {
        enable = true;
        variables = ["--all"];
        extraCommands = [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
    };

    wayland.windowManager.hyprland.settings = with colors; {
      exec-once = [
        "pw-loopback -C \"alsa_input.pci-0000_0d_00.4.analog-stereo\" -P \"Scarlett Solo (3rd Gen.) Headphones / Line 1-2\""
        "sway-audio-idle-inhibit"
        "zen"
        "telegram"
        "thunderbird"
        "vesktop"
        "spotify"
        "slack"
      ];

      bind =
        [
          ''${mod},RETURN,exec,kitty''

          "${mod},D,exec,killall anyrun || anyrun"
          "${mod},Q,killactive"
          "${mod},M,exit"
          "${mod},P,pseudo"

          "${mod},J,togglesplit,"

          "${mod},T,togglegroup," # group focused window
          "${modshift},G,changegroupactive," # switch within the active group
          "${mod},V,togglefloating," # toggle floating for the focused window
          "${mod},F,fullscreen," # fullscreen focused window

          # workspace controls
          "${modshift},right,movetoworkspace,+1" # move focused window to the next ws
          "${modshift},left,movetoworkspace,-1" # move focused window to the previous ws
          "${mod},mouse_down,workspace,e+1" # move to the next ws
          "${mod},mouse_up,workspace,e-1" # move to the previous ws

          "${mod},X,exec, ags --toggle-window \"dashboard\""
          "${mod},Print,exec,grim -g \"$(slurp)\" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png;"
          ",Print,exec, grim - | wl-copy"
          "${modshift},O,exec,wl-ocr"

          "${mod},Period,exec, tofi-emoji"

          "${modshift},L,exec,swaylock --grace 0" # lock screen
        ]
        ++ workspaces;

      bindm = [
        "${mod},mouse:272,movewindow"
        "${mod},mouse:273,resizewindow"
      ];

      general = {
        # gaps
        gaps_in = 4;
        gaps_out = 8;

        # border thiccness
        border_size = 2;

        # active border color
        "col.active_border" = "rgb(${rose})";
        "col.inactive_border" = "rgb(${muted})";
      };

      input = {
        kb_layout = "us";
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat";
        force_no_accel = false;
      };

      dwindle = {
        force_split = 2;
      };

      decoration = {
        # fancy corners
        rounding = 10;
        # blur
        blur = {
          enabled = true;
          size = 2;
          passes = 5;
          ignore_opacity = false;
          new_optimizations = 1;
          contrast = 1;
          brightness = 1;
        };

        # shadow config
        drop_shadow = "yes";
        shadow_range = 60;
        shadow_render_power = 5;
        "col.shadow" = "rgba(07061f29)";
      };

      misc = {
        # disable redundant renders
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;

        vfr = false;

        # dpms
        mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
        key_press_enables_dpms = true; # enable dpms on keyboard action
        disable_autoreload = true; # autoreload is unnecessary on nixos, because the config is readonly anyway
      };

      xwayland = {
        force_zero_scaling = true;
      };

      monitor = ["DP-1,2560x1440@240,0x0,1,bitdepth,10" "HDMI-A-1,disable"];

      layerrule = [
        "blur, ^(gtk-layer-shell)$"
        "blur, ^(launcher)$"
        "ignorezero, ^(gtk-layer-shell)$"
        "ignorezero, ^(launcher)$"
        "blur, notifications"
        "ignorezero, notifications"
        "blur, bar"
        "ignorezero, bar"
        "ignorezero, ^(gtk-layer-shell|anyrun)$"
        "blur, ^(gtk-layer-shell|anyrun)$"
        "noanim, launcher"
        "noanim, bar"
      ];
      windowrulev2 = [
        # only allow shadows for floating windows
        "noshadow, floating:0"
        "tile, title:Spotify"

        "idleinhibit focus, class:^(mpv)$"

        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"

        "float,class:udiskie"

        # "workspace special silent,class:^(pavucontrol)$"

        "float, class:^(imv)$"

        # throw sharing indicators away
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
        "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

        "workspace 5, class:^(thunderbird)$"
        "workspace 4, title:^(.*(Disc|WebC)ord.*)$"
        "workspace 4, class:^(.*Slack.*)$"
        "workspace 3, title:^(Spotify Premium)$"
        "workspace 2, class:^(firefox)$"
        "opacity 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];
    };

    # # fake a tray to let apps start
    # # https://github.com/nix-community/home-manager/issues/2064
    # systemd.user.targets.tray = {
    #   Unit = {
    #     Description = "Home Manager System Tray";
    #     Requires = ["graphical-session-pre.target"];
    #   };
    # };

    systemd.user.services = {
      swaybg = mkService {
        Unit.Description = "Wallpaper chooser";
        Service = {
          ExecStart = "${getExe pkgs.swaybg} -i ${wallpaper}";
          Restart = "always";
        };
      };
    };
  };
}
