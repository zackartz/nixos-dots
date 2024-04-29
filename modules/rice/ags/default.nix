{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
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
  ];

  guiDeps = with pkgs; [
    gnome.gnome-control-center
    mission-center
    overskride
    wlogout
  ];

  dependencies = requiredDeps ++ guiDeps;

  cfg = config.programs.ags;
in {
  imports = [inputs.ags.homeManagerModules.default];

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
      ExecStart = "${cfg.package}/bin/ags";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
