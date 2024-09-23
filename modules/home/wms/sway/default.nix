{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.wms.sway;

  mkService = recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  options.wms.sway = with types; {
    enable = mkBoolOpt false "Enable Sway";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      xwayland = true;
      package = inputs.nixpkgs-wayland.packages.${pkgs.system}.sway-unwrapped;
      extraOptions = ["--unsupported-gpu"];

      config = {
        terminal = "foot";
        startup = [{command = "zen";} {command = "vesktop";} {command = "slack";} {command = "telegram-desktop";} {command = "thunderbird";}];

        menu = "killall anyrun || anyrun";

        modifier = "Mod4";

        input = {
          "Logitech USB Receiver Keyboard" = {
            accel_profile = "flat";
            pointer_accel = "0";
          };
          "Logitech USB Receiver" = {
            accel_profile = "flat";
            pointer_accel = "0";
          };
        };

        output = {
          DP-1 = {
            mode = "2560x1440@240Hz";
            adaptive_sync = "off";
          };
          HDMI-A-1 = {
            disable = "disable";
          };
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
