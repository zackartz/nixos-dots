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
    services.swaync = {
      enable = true;
      style = lib.mkForce ''
        * {
          all: unset;
          font-size: 14px;
          font-family: "Adwaita Sans", "JetBrains Mono Nerd Font";
          transition: 200ms;
        }

        trough highlight {
          background: #cad3f5;
        }

        scale trough {
          margin: 0rem 1rem;
          background-color: #363a4f;
          min-height: 8px;
          min-width: 70px;
        }

        slider {
          background-color: #8aadf4;
        }

        .floating-notifications.background .notification-row .notification-background {
          box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #363a4f;
          border-radius: 12.6px;
          margin: 18px;
          background-color: #24273a;
          color: #cad3f5;
          padding: 0;
        }

        .floating-notifications.background .notification-row .notification-background .notification {
          padding: 7px;
          border-radius: 12.6px;
        }

        .floating-notifications.background .notification-row .notification-background .notification.critical {
          box-shadow: inset 0 0 7px 0 #ed8796;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content {
          margin: 7px;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .summary {
          color: #cad3f5;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .time {
          color: #a5adcb;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .body {
          color: #cad3f5;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
          min-height: 3.4em;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
          border-radius: 7px;
          color: #cad3f5;
          background-color: #363a4f;
          box-shadow: inset 0 0 0 1px #494d64;
          margin: 7px;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #363a4f;
          color: #cad3f5;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #7dc4e4;
          color: #cad3f5;
        }

        .floating-notifications.background .notification-row .notification-background .close-button {
          margin: 7px;
          padding: 2px;
          border-radius: 6.3px;
          color: #24273a;
          background-color: #ed8796;
        }

        .floating-notifications.background .notification-row .notification-background .close-button:hover {
          background-color: #ee99a0;
          color: #24273a;
        }

        .floating-notifications.background .notification-row .notification-background .close-button:active {
          background-color: #ed8796;
          color: #24273a;
        }

        .control-center {
          box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #363a4f;
          border-radius: 12.6px;
          margin: 18px;
          background-color: #24273a;
          color: #cad3f5;
          padding: 14px;
        }

        .control-center .widget-title > label {
          color: #cad3f5;
          font-size: 1.3em;
        }

        .control-center .widget-title button {
          border-radius: 7px;
          color: #cad3f5;
          background-color: #363a4f;
          box-shadow: inset 0 0 0 1px #494d64;
          padding: 8px;
        }

        .control-center .widget-title button:hover {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #5b6078;
          color: #cad3f5;
        }

        .control-center .widget-title button:active {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #7dc4e4;
          color: #24273a;
        }

        .control-center .notification-row .notification-background {
          border-radius: 7px;
          color: #cad3f5;
          background-color: #363a4f;
          box-shadow: inset 0 0 0 1px #494d64;
          margin-top: 14px;
        }

        .control-center .notification-row .notification-background .notification {
          padding: 7px;
          border-radius: 7px;
        }

        .control-center .notification-row .notification-background .notification.critical {
          box-shadow: inset 0 0 7px 0 #ed8796;
        }

        .control-center .notification-row .notification-background .notification .notification-content {
          margin: 7px;
        }

        .control-center .notification-row .notification-background .notification .notification-content .summary {
          color: #cad3f5;
        }

        .control-center .notification-row .notification-background .notification .notification-content .time {
          color: #a5adcb;
        }

        .control-center .notification-row .notification-background .notification .notification-content .body {
          color: #cad3f5;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * {
          min-height: 3.4em;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
          border-radius: 7px;
          color: #cad3f5;
          background-color: #181926;
          box-shadow: inset 0 0 0 1px #494d64;
          margin: 7px;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #363a4f;
          color: #cad3f5;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #7dc4e4;
          color: #cad3f5;
        }

        .control-center .notification-row .notification-background .close-button {
          margin: 7px;
          padding: 2px;
          border-radius: 6.3px;
          color: #24273a;
          background-color: #ee99a0;
        }

        .close-button {
          border-radius: 6.3px;
        }

        .control-center .notification-row .notification-background .close-button:hover {
          background-color: #ed8796;
          color: #24273a;
        }

        .control-center .notification-row .notification-background .close-button:active {
          background-color: #ed8796;
          color: #24273a;
        }

        .control-center .notification-row .notification-background:hover {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #8087a2;
          color: #cad3f5;
        }

        .control-center .notification-row .notification-background:active {
          box-shadow: inset 0 0 0 1px #494d64;
          background-color: #7dc4e4;
          color: #cad3f5;
        }

        .notification.critical progress {
          background-color: #ed8796;
        }

        .notification.low progress,
        .notification.normal progress {
          background-color: #8aadf4;
        }

        .control-center-dnd {
          margin-top: 5px;
          border-radius: 8px;
          background: #363a4f;
          border: 1px solid #494d64;
          box-shadow: none;
        }

        .control-center-dnd:checked {
          background: #363a4f;
        }

        .control-center-dnd slider {
          background: #494d64;
          border-radius: 8px;
        }

        .widget-dnd {
          margin: 0px;
          font-size: 1.1rem;
        }

        .widget-dnd > switch {
          font-size: initial;
          border-radius: 8px;
          background: #363a4f;
          border: 1px solid #494d64;
          box-shadow: none;
        }

        .widget-dnd > switch:checked {
          background: #363a4f;
        }

        .widget-dnd > switch slider {
          background: #494d64;
          border-radius: 8px;
          border: 1px solid #6e738d;
        }

        .widget-mpris .widget-mpris-player .widget-mpd {
          background: #363a4f;
          padding: 7px;
        }

        .widget-mpris .widget-mpris-title .widget-mpd .widget-mpd-title {
          font-size: 1.2rem;
        }

        .widget-mpris .widget-mpris-subtitle .widget-mpd .widget-mpd-subtitle {
          font-size: 0.8rem;
        }

        .widget-menubar > box > .menu-button-bar > button > label {
          font-size: 3rem;
          padding: 0.5rem 2rem;
        }

        .widget-menubar > box > .menu-button-bar > :last-child {
          color: #ed8796;
        }

        .power-buttons button:hover,
        .powermode-buttons button:hover,
        .screenshot-buttons button:hover {
          background: #363a4f;
        }

        .control-center .widget-label > label {
          color: #cad3f5;
          font-size: 2rem;
        }

        .widget-buttons-grid {
          padding-top: 1rem;
        }

        .widget-buttons-grid > flowbox > flowboxchild > button label {
          font-size: 2.5rem;
        }

        .widget-volume {
          padding-top: 1rem;
        }

        .widget-volume label {
          font-size: 1.5rem;
          color: #7dc4e4;
        }

        .widget-volume trough highlight {
          background: #7dc4e4;
        }

        .widget-backlight trough highlight {
          background: #eed49f;
        }

        .widget-backlight label {
          font-size: 1.5rem;
          color: #eed49f;
        }

        .widget-backlight .KB {
          padding-bottom: 1rem;
        }

        .image {
          padding-right: 0.5rem;
        }
      '';
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "graphical-session.target";
      style = ''
        ${builtins.readFile ./style.css}
      '';
      settings = let
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
            format = "{}°C ";
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
            format-wifi = " {bandwidthDownBytes}  {bandwidthUpBytes}";
            format-ethernet = " {bandwidthDownBytes}  {bandwidthUpBytes}";
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
            spacing = 10;
          };

          "clock#simpleclock" = {
            tooltip = false;
            format = "{:%H:%M}";
          };

          "temperature" = {
            hwmon-path-abs = "/sys/devices/platform/asus-ec-sensors/hwmon/hwmon3";
            input_filename = "temp2_input";
            critical-threshold = 70;
            format = "{temperatureC}°C ";
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
            "format-muted" = "";
            "format-icons" = {
              headphone = "";
              default = ["" ""];
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
