{
  options,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.helpers.waybar;
in {
  options.apps.helpers.waybar = with types; {
    enable = mkBoolOpt false "Enable WayBar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = ''
        * {
          min-height: 0;
          min-width: 0;
          font-family: Lexend, "JetBrainsMono NFP";
          font-size: 16px;
          font-weight: 600;
        }

        window#waybar {
          transition-property: background-color;
          transition-duration: 0.5s;
          /* background-color: #1e1e2e; */
          /* background-color: #181825; */
          background-color: #11111b;
          /* background-color: rgba(24, 24, 37, 0.6); */
        }

        #workspaces button {
          padding: 0.3rem 0.6rem;
          margin: 0.4rem 0.25rem;
          border-radius: 6px;
          /* background-color: #181825; */
          background-color: #1e1e2e;
          color: #cdd6f4;
        }

        #workspaces button:hover {
          color: #1e1e2e;
          background-color: #cdd6f4;
        }

        #workspaces button.active {
          background-color: #1e1e2e;
          color: #89b4fa;
        }

        #workspaces button.urgent {
          background-color: #1e1e2e;
          color: #f38ba8;
        }

        #clock,
        #pulseaudio,
        #custom-logo,
        #custom-power,
        #custom-spotify,
        #custom-notification,
        #cpu,
        #tray,
        #memory,
        #window,
        #mpris {
          padding: 0.3rem 0.6rem;
          margin: 0.4rem 0.25rem;
          border-radius: 6px;
          /* background-color: #181825; */
          background-color: #1e1e2e;
        }

        #mpris.playing {
          color: #a6e3a1;
        }

        #mpris.paused {
          color: #9399b2;
        }

        #custom-sep {
          padding: 0px;
          color: #585b70;
        }

        window#waybar.empty #window {
          background-color: transparent;
        }

        #cpu {
          color: #94e2d5;
        }

        #memory {
          color: #cba6f7;
        }

        #clock {
          color: #74c7ec;
        }

        #clock.simpleclock {
          color: #89b4fa;
        }

        #window {
          color: #cdd6f4;
        }

        #pulseaudio {
          color: #b4befe;
        }

        #pulseaudio.muted {
          color: #a6adc8;
        }

        #custom-logo {
          color: #89b4fa;
        }

        #custom-power {
          color: #f38ba8;
        }

        tooltip {
          background-color: #181825;
          border: 2px solid #89b4fa;
        }
      '';

      settings = {
        mainBar = {
          layer = "bottom";
          position = "top";
          height = 40;
          spacing = 2;
          exclusive = true;
          "gtk-layer-shell" = true;
          passthrough = false;
          "fixed-center" = true;
          "modules-left" = ["hyprland/workspaces" "hyprland/window"];
          "modules-center" = ["mpris"];
          "modules-right" = [
            "cpu"
            "memory"
            "pulseaudio"
            "clock"
            "clock#simpleclock"
            "tray"
            "custom/notification"
            "custom/power"
          ];

          "custom/spotify" = {
            format = "  {}";
            "return-type" = "json";
            "on-click" = "playerctl -p spotify play-pause";
            "on-click-right" = "spotifatius toggle-liked";
            "on-click-middle" = "playerctl -p spotify next";
            exec = "spotifatius monitor";
          };

          mpris = {
            player = "spotify";
            "dynamic-order" = ["artist" "title"];
            format = "{player_icon} {dynamic}";
            "format-paused" = "{status_icon} <i>{dynamic}</i>";
            "status-icons" = {
              paused = "";
            };
            "player-icons" = {
              default = "";
            };
          };

          "hyprland/workspaces" = {
            "on-click" = "activate";
            format = "{id}";
            "all-outputs" = true;
            "disable-scroll" = false;
            "active-only" = false;
          };

          "hyprland/window" = {
            format = "{title}";
          };

          tray = {
            "show-passive-items" = true;
            spacing = 10;
          };

          "clock#simpleclock" = {
            tooltip = false;
            format = " {:%H:%M}";
          };

          clock = {
            format = " {:L%a %d %b}";
            calendar = {
              format = {
                days = "<span weight='normal'>{}</span>";
                months = "<span color='#cdd6f4'><b>{}</b></span>";
                today = "<span color='#f38ba8' weight='700'><u>{}</u></span>";
                weekdays = "<span color='#f9e2af'><b>{}</b></span>";
                weeks = "<span color='#a6e3a1'><b>W{}</b></span>";
              };
              mode = "month";
              "mode-mon-col" = 1;
              "on-scroll" = 1;
            };
            "tooltip-format" = "<span color='#cdd6f4' font='Lexend 16'><tt><small>{calendar}</small></tt></span>";
          };

          cpu = {
            format = " {usage}%";
            tooltip = true;
            interval = 1;
          };

          memory = {
            format = " {used:0.1f}Gi";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            "format-muted" = "  muted";
            "format-icons" = {
              headphone = "";
              default = [" " " " " "];
            };
            "on-click" = "pavucontrol";
          };

          "custom/sep" = {
            format = "|";
            tooltip = false;
          };

          "custom/power" = {
            tooltip = false;
            "on-click" = "wlogout -p layer-shell &";
            format = "⏻";
          };

          "custom/notification" = {
            escape = true;
            exec = "swaync-client -swb";
            "exec-if" = "which swaync-client";
            format = "{icon}";
            "format-icons" = {
              none = "󰅺";
              notification = "󰡟";
            };
            "on-click" = "sleep 0.1 && swaync-client -t -sw";
            "return-type" = "json";
            tooltip = false;
          };
        };
      };
    };
  };
}
