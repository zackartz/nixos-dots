{
  pkgs,
  lib,
  config,
  theme,
  ...
}: let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = with theme.colors; {
      clock = true;
      color = base;
      font = "Work Sans";
      image = "${theme.wallpaper}";
      show-failed-attempts = false;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = "00000000";
      ring-color = "00000000";
      inside-color = "00000000";
      key-hl-color = "f2cdcd";
      separator-color = "00000000";
      text-color = text;
      text-caps-lock-color = "";
      line-ver-color = love;
      ring-ver-color = rose;
      inside-ver-color = base;
      text-ver-color = text;
      ring-wrong-color = foam;
      text-wrong-color = foam;
      inside-wrong-color = base;
      inside-clear-color = base;
      text-clear-color = text;
      ring-clear-color = iris;
      line-clear-color = base;
      line-wrong-color = base;
      bs-hl-color = foam;
      line-uses-ring = false;
      grace = 2;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%d.%m";
      fade-in = "0.1";
      ignore-empty-password = true;
    };
  };
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        event = "lock";
        command = "${pkgs.gtklock}/bin/gtklock";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 310;
        command = suspendScript.outPath;
      }
    ];
  };

  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
}
