{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.wms.niri;

  mkService = recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };

  actions = config.lib.niri.actions;

  mkColor = color: {inherit color;};
  mkGradient = from: to: {
    angle ? 180,
    relative-to ? "window",
    in' ? null,
  }: {
    gradient = {inherit from to angle relative-to in';};
  };

  spawnSlackOnWeekday = pkgs.writeShellScriptBin "spawn-slack-on-weekday" ''
    # Get the day of the week (1=Monday, ..., 7=Sunday)
    DAY_OF_WEEK=$(${pkgs.coreutils}/bin/date +%u)

    # Check if it's a weekday (between 1 and 5 inclusive)
    if [ "$DAY_OF_WEEK" -ge 1 ] && [ "$DAY_OF_WEEK" -le 5 ]; then
      # Execute Slack. Use the full path for robustness.
      # Ensure pkgs.slack is available (e.g., via environment.systemPackages)
      exec ${pkgs.slack}/bin/slack
    fi
    # Exit successfully if not a weekday or after exec replaces the process
    exit 0
  '';
in {
  options.wms.niri = with types; {
    enable = mkBoolOpt false "Enable niri";
  };

  config = mkIf cfg.enable {
    programs.niri = {
      package = pkgs.niri;

      settings = {
        # Input device configuration
        input = {
          keyboard = {
            # xkb settings are empty in KDL, using defaults/empty strings
            xkb = {
              rules = "";
              model = "";
              layout = "";
              variant = "";
              options = null; # Or "" if you prefer explicit empty
            };
          };

          touchpad = {
            enable = true; # Not explicitly 'off' in KDL
            tap = true;
            dwt = false; # Commented out in KDL
            dwtp = false; # Commented out in KDL
            natural-scroll = true;
            # accel-speed = 0.2; # Commented out
            # accel-profile = "flat"; # Commented out
            # scroll-method = "two-finger"; # Commented out
            disabled-on-external-mouse = true;
          };

          mouse = {
            enable = true; # Not explicitly 'off' in KDL
            natural-scroll = false; # Commented out in KDL
            accel-speed = 0.2;
            accel-profile = "flat";
            # scroll-method = "no-scroll"; # Commented out
          };

          trackpoint = {
            enable = true; # Not explicitly 'off' in KDL
            natural-scroll = false; # Commented out
            # accel-speed = 0.2; # Commented out
            # accel-profile = "flat"; # Commented out
            # scroll-method = "on-button-down"; # Commented out
            # scroll-button = 273; # Commented out
            middle-emulation = false; # Commented out
          };

          warp-mouse-to-focus = true;

          focus-follows-mouse = {
            enable = false; # Commented out in KDL
            # max-scroll-amount = "0%"; # Only relevant if enabled
          };
        };

        # Output configuration
        outputs."DP-1" = {
          enable = true; # Not explicitly 'off'
          mode = {
            width = 2560;
            height = 1440;
            refresh = 239.972;
          };
          scale = 1;
          transform = {
            # "normal"
            rotation = 0;
            flipped = false;
          };
          position = {
            x = 0;
            y = 0;
          };
        };

        # Environment variables
        environment = {
          DISPLAY = ":0"; # for applications using xwayland-satillite
        };

        hotkey-overlay = {
          skip-at-startup = true;
        };

        # Layout settings
        layout = {
          gaps = 16;
          center-focused-column = "never";

          preset-column-widths = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
            # { fixed = 1920; } # Example if needed
          ];

          # preset-window-heights = []; # Empty in KDL

          default-column-width = {proportion = 0.5;};
          # default-column-width = {}; # Alternative from KDL comments

          focus-ring = {
            enable = true; # Not explicitly 'off'
            width = 4;
            active = mkGradient colors.blue.hex colors.sky.hex {angle = 45;};
            # active = mkColor "#7fc8ff"; # Alternative solid color from KDL
            inactive = mkGradient colors.surface1.hex colors.surface2.hex {
              angle = 45;
              relative-to = "workspace-view";
            };
            # inactive = mkColor "#505050"; # Alternative solid color from KDL
          };

          border = {
            enable = true; # Explicitly 'off' in KDL
            width = 0;
            active = mkColor colors.blue.hex;
            inactive = mkColor colors.base.hex;
            # active-gradient = ... # Commented out in KDL
            # inactive-gradient = ... # Commented out in KDL
          };

          struts = {
            # left = 64; # Commented out
            # right = 64; # Commented out
            # top = 64; # Commented out
            # bottom = 64; # Commented out
          };
        };

        # Spawn processes at startup
        spawn-at-startup = [
          {command = ["xwayland-satellite"];}
          {command = ["${pkgs.writeShellScriptBin "thunderbird-delayed" ''sleep 5; thunderbird''}/bin/thunderbird-delayed"];}
          {command = ["${pkgs.writeShellScriptBin "zen-delayed" ''sleep 5; zen''}/bin/zen-delayed"];}
          {command = ["vesktop"];}
          {command = ["spotify"];}

          {command = ["${spawnSlackOnWeekday}/bin/spawn-slack-on-weekday"];}
        ];

        # Prefer server-side decorations
        prefer-no-csd = true;

        # Screenshot path
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
        # screenshot-path = null; # Alternative from KDL comments

        # Animation settings
        animations = {
          enable = true; # Not explicitly 'off'
          # slowdown = 3.0; # Commented out
          # Individual animation settings can be added here if needed
        };

        debug = {
          wait-for-frame-completion-in-pipewire = [];
        };

        layer-rules = [
          {
            matches = [
              {namespace = "notifications$";}
            ];

            block-out-from = "screen-capture";
          }
        ];

        # Window rules
        window-rules = [
          # Password manager rule (example from KDL comments)
          {
            matches = [
              {app-id = "^org\\.keepassxc\\.KeePassXC$";}
              {app-id = "^org\\.gnome\\.World\\.Secrets$";}
              {app-id = "^1Password$";}
              {app-id = "^thunderbird$";}
              {app-id = "^signal$";}
              {app-id = "^vesktop$";}
              {app-id = "^slack$";}
            ];
            block-out-from = "screen-capture";
          }
          # Rounded corners rule (example from KDL comments)
          {
            # No matches means apply to all windows
            geometry-corner-radius = {
              top-left = 12.0;
              top-right = 12.0;
              bottom-left = 12.0;
              bottom-right = 12.0;
            };
            clip-to-geometry = true;
          }
          # Window cast target rule
          {
            matches = [{is-window-cast-target = true;}];
            focus-ring = {
              active = mkColor colors.red.hex;
              inactive = mkColor (lerpColor colors.red.hex colors.base.hex 0.5);
            };
            shadow = {
              # Only color is specified in KDL rule
              color = "#7d0d2d70";
            };
            tab-indicator = {
              active = mkColor colors.red.hex;
              inactive = mkColor (lerpColor colors.red.hex colors.base.hex 0.5);
            };
          }

          # fix steam popups holy fuck they're annoying
          {
            matches = [
              {app-id = "^steam$";}
            ];

            excludes = [{title = "^Steam$";}];

            open-floating = true;

            open-focused = false;

            default-floating-position = {
              relative-to = "bottom-right";
              x = 16;
              y = 16;
            };
          }

          {
            matches = [
              {
                at-startup = true;
                app-id = "^zen$";
              }
            ];

            open-maximized = true;

            open-on-workspace = "browser";
          }
          {
            matches = [
              {
                at-startup = true;
                app-id = "^spotify$";
              }
              {
                at-startup = true;
                app-id = "^vesktop$";
              }
            ];

            open-on-workspace = "chat";
          }
          {
            matches = [
              {
                at-startup = true;
                app-id = "^Slack$";
              }
              {
                at-startup = true;
                app-id = "^thunderbird$";
              }
            ];

            open-on-workspace = "work";
          }
        ];

        workspaces."01-browser" = {
          name = "browser";
        };
        workspaces."02-code" = {
          name = "code";
        };
        workspaces."03-chat" = {
          name = "chat";
        };
        workspaces."04-work" = {
          name = "work";
        };

        # Keybindings
        binds = {
          "Mod+Shift+Slash" = {action = actions.show-hotkey-overlay;};

          "Mod+Return" = {action = actions.spawn "kitty";};
          "Mod+D" = {action = actions.spawn "fuzzel";};
          "Super+Alt+L" = {action = actions.spawn "swaylock";};
          # "Mod+T" = { action = actions.spawn "bash" "-c" "notify-send hello && exec alacritty"; };

          "Mod+S" = {action = actions.set-dynamic-cast-window;};

          "Mod+Shift+S" = {action = actions.set-dynamic-cast-monitor;};

          "Mod+Z" = {action = actions.clear-dynamic-cast-target;};

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action = actions.spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action = actions.spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action = actions.spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action =
              actions.spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
          };

          "Mod+Q" = {action = actions.close-window;};

          "Mod+Left" = {action = actions.focus-column-left;};
          "Mod+Down" = {action = actions.focus-window-down;};
          "Mod+Up" = {action = actions.focus-window-up;};
          "Mod+Right" = {action = actions.focus-column-right;};
          "Mod+H" = {action = actions.focus-column-left;};
          "Mod+J" = {action = actions.focus-window-down;};
          "Mod+K" = {action = actions.focus-window-up;};
          "Mod+L" = {action = actions.focus-column-right;};

          "Mod+Ctrl+Left" = {action = actions.move-column-left;};
          "Mod+Ctrl+Down" = {action = actions.move-window-down;};
          "Mod+Ctrl+Up" = {action = actions.move-window-up;};
          "Mod+Ctrl+Right" = {action = actions.move-column-right;};
          "Mod+Ctrl+H" = {action = actions.move-column-left;};
          "Mod+Ctrl+J" = {action = actions.move-window-down;};
          "Mod+Ctrl+K" = {action = actions.move-window-up;};
          "Mod+Ctrl+L" = {action = actions.move-column-right;};

          # Alternative commands (commented out in KDL)
          # "Mod+J" = { action = actions.focus-window-or-workspace-down; };
          # "Mod+K" = { action = actions.focus-window-or-workspace-up; };
          # "Mod+Ctrl+J" = { action = actions.move-window-down-or-to-workspace-down; };
          # "Mod+Ctrl+K" = { action = actions.move-window-up-or-to-workspace-up; };

          "Mod+Home" = {action = actions.focus-column-first;};
          "Mod+End" = {action = actions.focus-column-last;};
          "Mod+Ctrl+Home" = {action = actions.move-column-to-first;};
          "Mod+Ctrl+End" = {action = actions.move-column-to-last;};

          "Mod+Shift+Left" = {action = actions.focus-monitor-left;};
          "Mod+Shift+Down" = {action = actions.focus-monitor-down;};
          "Mod+Shift+Up" = {action = actions.focus-monitor-up;};
          "Mod+Shift+Right" = {action = actions.focus-monitor-right;};
          "Mod+Shift+H" = {action = actions.focus-monitor-left;};
          "Mod+Shift+J" = {action = actions.focus-workspace-down;};
          "Mod+Shift+K" = {action = actions.focus-workspace-up;};
          "Mod+Shift+L" = {action = actions.focus-monitor-right;};

          "Mod+Ctrl+Shift+F" = {action = actions.toggle-windowed-fullscreen;};

          "Mod+Shift+Ctrl+Left" = {action = actions.move-column-to-monitor-left;};
          "Mod+Shift+Ctrl+Down" = {action = actions.move-column-to-monitor-down;};
          "Mod+Shift+Ctrl+Up" = {action = actions.move-column-to-monitor-up;};
          "Mod+Shift+Ctrl+Right" = {action = actions.move-column-to-monitor-right;};
          "Mod+Shift+Ctrl+H" = {action = actions.move-column-to-monitor-left;};
          "Mod+Shift+Ctrl+J" = {action = actions.move-column-to-monitor-down;};
          "Mod+Shift+Ctrl+K" = {action = actions.move-column-to-monitor-up;};
          "Mod+Shift+Ctrl+L" = {action = actions.move-column-to-monitor-right;};

          # Alternative move commands (commented out in KDL)
          # "Mod+Shift+Ctrl+Left" = { action = actions.move-window-to-monitor-left; };
          # "Mod+Shift+Ctrl+Left" = { action = actions.move-workspace-to-monitor-left; };

          "Mod+Page_Down" = {action = actions.focus-workspace-down;};
          "Mod+Page_Up" = {action = actions.focus-workspace-up;};
          "Mod+U" = {action = actions.focus-workspace-down;};
          "Mod+I" = {action = actions.focus-workspace-up;};
          "Mod+Ctrl+Page_Down" = {action = actions.move-column-to-workspace-down;};
          "Mod+Ctrl+Page_Up" = {action = actions.move-column-to-workspace-up;};
          "Mod+Ctrl+U" = {action = actions.move-column-to-workspace-down;};
          "Mod+Ctrl+I" = {action = actions.move-column-to-workspace-up;};

          # Alternative move commands (commented out in KDL)
          # "Mod+Ctrl+Page_Down" = { action = actions.move-window-to-workspace-down; };

          "Mod+Shift+Page_Down" = {action = actions.move-workspace-down;};
          "Mod+Shift+Page_Up" = {action = actions.move-workspace-up;};
          "Mod+Shift+U" = {action = actions.move-workspace-down;};
          "Mod+Shift+I" = {action = actions.move-workspace-up;};

          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action = actions.focus-workspace-down;
          };
          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action = actions.focus-workspace-up;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            action = actions.move-column-to-workspace-down;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            action = actions.move-column-to-workspace-up;
          };

          "Mod+WheelScrollRight" = {action = actions.focus-column-right;};
          "Mod+WheelScrollLeft" = {action = actions.focus-column-left;};
          "Mod+Ctrl+WheelScrollRight" = {action = actions.move-column-right;};
          "Mod+Ctrl+WheelScrollLeft" = {action = actions.move-column-left;};

          "Mod+Shift+WheelScrollDown" = {action = actions.focus-column-right;};
          "Mod+Shift+WheelScrollUp" = {action = actions.focus-column-left;};
          "Mod+Ctrl+Shift+WheelScrollDown" = {action = actions.move-column-right;};
          "Mod+Ctrl+Shift+WheelScrollUp" = {action = actions.move-column-left;};

          # Touchpad scroll binds (commented out in KDL)
          # "Mod+TouchpadScrollDown" = { action = actions.spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; };
          # "Mod+TouchpadScrollUp" = { action = actions.spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; };

          "Mod+1" = {action = actions.focus-workspace 1;};
          "Mod+2" = {action = actions.focus-workspace 2;};
          "Mod+3" = {action = actions.focus-workspace 3;};
          "Mod+4" = {action = actions.focus-workspace 4;};
          "Mod+5" = {action = actions.focus-workspace 5;};
          "Mod+6" = {action = actions.focus-workspace 6;};
          "Mod+7" = {action = actions.focus-workspace 7;};
          "Mod+8" = {action = actions.focus-workspace 8;};
          "Mod+9" = {action = actions.focus-workspace 9;};
          "Mod+Shift+1" = {action = actions.move-column-to-workspace 1;};
          "Mod+Shift+2" = {action = actions.move-column-to-workspace 2;};
          "Mod+Shift+3" = {action = actions.move-column-to-workspace 3;};
          "Mod+Shift+4" = {action = actions.move-column-to-workspace 4;};
          "Mod+Shift+5" = {action = actions.move-column-to-workspace 5;};
          "Mod+Shift+6" = {action = actions.move-column-to-workspace 6;};
          "Mod+Shift+7" = {action = actions.move-column-to-workspace 7;};
          "Mod+Shift+8" = {action = actions.move-column-to-workspace 8;};
          "Mod+Shift+9" = {action = actions.move-column-to-workspace 9;};

          # Alternative move commands (commented out in KDL)
          # "Mod+Ctrl+1" = { action = actions.move-window-to-workspace 1; };

          # "Mod+Tab" = { action = actions.focus-workspace-previous; }; # Commented out

          "Mod+Comma" = {action = actions.consume-window-into-column;};
          "Mod+Period" = {action = actions.expel-window-from-column;};

          "Mod+BracketLeft" = {action = actions.consume-or-expel-window-left;};
          "Mod+BracketRight" = {action = actions.consume-or-expel-window-right;};

          "Mod+R" = {action = actions.switch-preset-column-width;};
          "Mod+Shift+R" = {action = actions.switch-preset-window-height;};
          "Mod+Ctrl+R" = {action = actions.reset-window-height;};
          "Mod+F" = {action = actions.maximize-column;};
          "Mod+Shift+F" = {action = actions.fullscreen-window;};
          "Mod+C" = {action = actions.center-column;};
          "Mod+Ctrl+F" = {action = actions.expand-column-to-available-width;};

          "Mod+V" = {action = actions.toggle-window-floating;};

          "Mod+Minus" = {action = actions.set-column-width "-10%";};
          "Mod+Equal" = {action = actions.set-column-width "+10%";};

          "Mod+Shift+Minus" = {action = actions.set-window-height "-10%";};
          "Mod+Shift+Equal" = {action = actions.set-window-height "+10%";};

          # Layout switching (commented out in KDL)
          # "Mod+Space" = { action = actions.switch-layout "next"; };
          # "Mod+Shift+Space" = { action = actions.switch-layout "prev"; };

          "Print" = {action = actions.screenshot {};}; # Empty attrset for default args
          # "Ctrl+Print" = {action = actions.screenshot-screen {};}; # Empty attrset for default args
          # "Alt+Print" = {action = actions.screenshot-window {};}; # Empty attrset for default args

          "Mod+Shift+E" = {action = actions.quit {};}; # Default: no skip-confirmation
          "Ctrl+Alt+Delete" = {action = actions.quit {};};

          "Mod+Shift+P" = {action = actions.power-off-monitors;};
        };
      };
    };

    systemd.user.services = {
      swaybg = mkService {
        Unit.Description = "Wallpaper Chooser";
        Service = {
          ExecStart = "${getExe pkgs.swaybg} -i ${wallpaper}";
          Restart = "always";
        };
      };
    };
  };
}
