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
in {
  options.rice.gtk = with types; {
    enable = mkBoolOpt false "Enable GTK Customization";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      # iconTheme = {
      #   package = pkgs.catppuccin-papirus-folders;
      #   name = "Papirus";
      # };
      theme = {
        name = "Tokyonight-Dark-B";
        package = pkgs.tokyonight-gtk-theme;
      };
      font = {
        name = "Iosevka";
        size = 11;
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
        breeze-icons
      ];
      pointerCursor = {
        package = pkgs.catppuccin-cursors.mochaMauve;
        name = "catppuccin-mocha-mauve-cursors";
        x11 = {
          enable = true;
          defaultCursor = "catppuccin-mocha-mauve-cursors";
        };
        size = 24;
      };
    };
  };
}
