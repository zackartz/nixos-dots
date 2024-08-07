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
  cfg = config.apps.helpers.ags;

  requiredDeps = with pkgs; [
    config.wayland.windowManager.hyprland.package
    bash
    coreutils
    gawk
    sassc
    imagemagick
    procps
    ripgrep
    util-linux
    gtksourceview
    webkitgtk
    brightnessctl
    gvfs
    accountsservice
    swww
    gnome.gnome-control-center
    nautilus
    totem
    loupe
  ];

  guiDeps = with pkgs; [
    gnome.gnome-control-center
    mission-center
    overskride
    wlogout
  ];

  dependencies = requiredDeps ++ guiDeps;
in {
  options.apps.helpers.ags = with types; {
    enable = mkBoolOpt false "Enable AGS";
  };

  config = mkIf cfg.enable {
    programs.ags = {
      enable = true;

      configDir = ./cfg;

      extraPackages = dependencies;
    };

    systemd.user.services.ags = {
      Unit = {
        Description = "Aylur's Gtk Shell";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${config.programs.ags.package}/bin/ags";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
