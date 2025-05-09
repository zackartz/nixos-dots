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
      systemd.enable = true;
      systemd.target = "graphical-session.target";
      style = ''
        /* Custom colors from lib/theme/default.nix */
        @define-color rosewater ${colors.rosewater.hex};
        @define-color flamingo ${colors.flamingo.hex};
        @define-color pink ${colors.pink.hex};
        @define-color mauve ${colors.mauve.hex};
        @define-color red ${colors.red.hex};
        @define-color maroon ${colors.maroon.hex};
        @define-color peach ${colors.peach.hex};
        @define-color yellow ${colors.yellow.hex};
        @define-color green ${colors.green.hex};
        @define-color teal ${colors.teal.hex};
        @define-color sky ${colors.sky.hex};
        @define-color sapphire ${colors.sapphire.hex};
        @define-color blue ${colors.blue.hex};
        @define-color lavender ${colors.lavender.hex};
        @define-color text ${colors.text.hex};
        @define-color subtext1 ${colors.subtext1.hex};
        @define-color subtext0 ${colors.subtext0.hex};
        @define-color overlay2 ${colors.overlay2.hex};
        @define-color overlay1 ${colors.overlay1.hex};
        @define-color overlay0 ${colors.overlay0.hex};
        @define-color surface2 ${colors.surface2.hex};
        @define-color surface1 ${colors.surface1.hex};
        @define-color surface0 ${colors.surface0.hex};
        @define-color base ${colors.base.hex};
        @define-color mantle ${colors.mantle.hex};
        @define-color crust ${colors.crust.hex};

        ${builtins.readFile ./mullvad-style.css}
        ${builtins.readFile ./style.css}
      '';
      settings = let
        # Import the Mullvad scripts
        mullvad-status = import ./mullvad-status.nix {inherit pkgs;};
        mullvad-server-list = import ./mullvad-server-list.nix {inherit pkgs;};
        mullvad-menu = import ./mullvad-menu.nix {inherit pkgs;};

        # Script to toggle Mullvad connection
        mullvad-toggle = pkgs.writeShellScriptBin "mullvad-toggle" ''
          set -euo pipefail
          if mullvad status | grep -q "Connected"; then
              mullvad disconnect
          else
              mullvad connect
          fi
          # Optional: trigger a Waybar refresh if needed, though interval should handle it
          # pkill -SIGRTMIN+8 waybar
        '';

        cava = pkgs.writeShellScriptBin "cava" "${builtins.readFile ./bar.sh}";
      in {
        mainBar = {
          layer = "bottom";
          position = "top";
          height = 40;
          spacing = 2;
          exclusive = true;
          "gtk-layer-shell" = true;
          passthrough = false;
          "fixed-center" = true;
          "modules-left" = ["hyprland/workspaces" "hyprland/window" "niri/workspaces" "niri/window" "network#speed" "custom/cava-system" "custom/cava-tt"];
          "modules-center" = ["mpris"];
          "modules-right" = [
            "cpu"
            "memory"
            "temperature"
            "custom/gpu-usage"
            "custom/gpu-mem"
            "custom/gpu-temp"
            "pulseaudio"
            "custom/mullvad"
            "custom/weather"
            "clock"
            "clock#simpleclock"
            "tray"
            "custom/notification"
            "custom/power"
          ];

          "custom/spotify" = {
            format = "{}";
            "return-type" = "json";
            "on-click" = "playerctl -p spotify play-pause";
            "on-click-right" = "spotifatius toggle-liked";
            "on-click-middle" = "playerctl -p spotify next";
            exec = "spotifatius monitor";
          };

          "custom/mullvad" = {
            format = "{}";
            return-type = "json";
            interval = 1;
            exec = "${mullvad-status}/bin/mullvad-status-waybar";
            "on-click" = "${mullvad-toggle}/bin/mullvad-toggle";
            "on-click-right" = "${mullvad-menu}/bin/mullvad-menu";
            tooltip = true;
          };

          mpd = {
            format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {title}";
            "format-disconnected" = "Disconnected ";
            "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            "interval" = 10;
            "consume-icons" = {
              "on" = " ";
            };
            "random-icons" = {
              "off" = "<span color=\"#f53c3c\"></span> ";
              "on" = " ";
            };
            "repeat-icons" = {
              "on" = " ";
            };
            "single-icons" = {
              "on" = "1 ";
            };
            "state-icons" = {
              "paused" = "";
              "playing" = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "";
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

          "custom/cava-system" = {
            format = "{}";
            exec = "${cava}/bin/cava alsa_output.usb-MOTU_M4_M4MA03F7DV-00.HiFi__Line1__sink.monitor";
          };

          "custom/cava-tt" = {
            format = "{}";
            exec = "${cava}/bin/cava cava-line-in.monitor";
          };

          "custom/weather" = {
            "format" = "{}°F";
            interval = 3600;
            exec = "${lib.getExe pkgs.wttrbar} --location 'Holland,MI' --fahrenheit --mph";
            return-type = "json";
          };

          "custom/gpu-temp" = {
            interval = 10;
            exec = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
            format = "{}°C ";
            tooltip = false;
          };

          "custom/gpu-mem" = {
            interval = 10;
            exec = "nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | awk '{printf \"%.1f\", $1/1024}'";
            format = "{}Gi";
            tooltip = false;
          };

          "custom/gpu-usage" = {
            interval = 2;
            exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
            format = "{}%";
            tooltip = false;
          };

          "network#speed" = {
            interval = 1;
            format = "{ifname}%%";
            format-wifi = " {bandwidthDownBytes}  {bandwidthUpBytes}";
            format-ethernet = " {bandwidthDownBytes}  {bandwidthUpBytes}";
            format-disconnected = "󰌙";
            tooltip-format = "{ipaddr}";
            format-linked = "󰈁 {ifname} (No IP)";
            tooltip-format-wifi = "{essid} {icon} {signalStrength}%";
            tooltip-format-ethernet = "{ifname} 󰌘";
            tooltip-format-disconnected = "󰌙 Disconnected";
            max-length = 22;
            min-length = 20;
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
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
            spacing = 2;
          };

          "clock#simpleclock" = {
            tooltip = false;
            format = "{:%H:%M}";
          };

          "temperature" = {
            hwmon-path-abs = "/sys/devices/platform/asus-ec-sensors/hwmon/hwmon3";
            input_filename = "temp2_input";
            critical-threshold = 70;
            format = "{temperatureC}°C ";
            format-critical = "󰸁 {temperatureC}°C";
          };

          clock = {
            format = "{:L%a %d %b}";
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
            format = "{usage}%";
            tooltip = true;
            interval = 1;
          };

          memory = {
            interval = 1;
            format = "{used:0.1f}Gi";
          };

          pulseaudio = {
            format = "{icon}  {volume}%";
            "format-muted" = "";
            "format-icons" = {
              headphone = "";
              default = ["" ""];
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
