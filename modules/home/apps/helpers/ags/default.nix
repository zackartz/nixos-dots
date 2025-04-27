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
    webkitgtk_4_1
    brightnessctl
    gvfs
    accountsservice
    swww
    gnome-control-center
    nautilus
    totem
    loupe
  ];

  guiDeps = with pkgs; [
    gnome-control-center
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

      # Generate _colors.scss with our theme colors
      configDir = pkgs.runCommand "ags-config" {} ''
        cp -r ${./cfg} $out
        chmod -R +w $out
        cat > $out/scss/_colors.scss << EOF
        /* Generated from lib/theme/default.nix */
        $rosewater: ${colors.rosewater.hex};
        $flamingo: ${colors.flamingo.hex};
        $pink: ${colors.pink.hex};
        $mauve: ${colors.mauve.hex};
        $red: ${colors.red.hex};
        $maroon: ${colors.maroon.hex};
        $peach: ${colors.peach.hex};
        $yellow: ${colors.yellow.hex};
        $green: ${colors.green.hex};
        $teal: ${colors.teal.hex};
        $sky: ${colors.sky.hex};
        $sapphire: ${colors.sapphire.hex};
        $blue: ${colors.blue.hex};
        $lavender: ${colors.lavender.hex};
        $text: ${colors.text.hex};
        $subtext1: ${colors.subtext1.hex};
        $subtext0: ${colors.subtext0.hex};
        $overlay2: ${colors.overlay2.hex};
        $overlay1: ${colors.overlay1.hex};
        $overlay0: ${colors.overlay0.hex};
        $surface2: ${colors.surface2.hex};
        $surface1: ${colors.surface1.hex};
        $surface0: ${colors.surface0.hex};
        $base: ${colors.base.hex};
        $mantle: ${colors.mantle.hex};
        $crust: ${colors.crust.hex};

        /* Default accent color */
        $accent: ${colors.sapphire.hex};
        EOF
      '';

      extraPackages = dependencies;
    };

    systemd.user.services.ags = {
      Unit = {
        Description = "Aylur's Gtk Shell";
        PartOf = [
          "tray.target"
          "hyprland-session.target"
        ];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${config.programs.ags.package}/bin/ags";
        Restart = "on-failure";
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}
