{
  config,
  lib,
  ...
}: let
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
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        ''${mod},RETURN,exec,kitty''

        "${mod},D,exec,wofi --show drun"
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

        "${mod},Print,exec, pauseshot"
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
  };
}
