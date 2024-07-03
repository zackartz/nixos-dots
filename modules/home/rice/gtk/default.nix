{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.rice.gtk;
  ctp = config.catppuccin;
in {
  options.rice.gtk = with types; {
    enable = mkBoolOpt false "Enable GTK Customization";
  };

  config = mkIf cfg.enable {
    catppuccin.pointerCursor.enable = true;

    gtk = {
      enable = true;

      font = {
        name = "Iosevka";
        size = 11;
      };

      theme = {
        name = "Tokyonight-Dark-B";
        package = pkgs.tokyonight-gtk-theme;
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          accent = ctp.accent;
          flavor = ctp.flavor;
        };
      };

      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk2.extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
    };

    home = {
      packages = with pkgs; [
        qt5.qttools
        qt6Packages.qtstyleplugin-kvantum
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
      ];
    };
  };
}
