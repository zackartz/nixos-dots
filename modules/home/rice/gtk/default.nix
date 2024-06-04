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
    enable = mkBoolOpt false "Enable Zsh Configuration";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      catppuccin.enable = true;

      # iconTheme = {
      #   package = pkgs.catppuccin-papirus-folders;
      #   name = "Papirus";
      # };
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

      sessionVariables = {
      };
    };
    qt = {
      enable = true;
      platformTheme = "qtct";
      style = {
        name = "Catppuccin-Mocha-Sapphire";
        package = pkgs.catppuccin-kde.override {
          flavour = ["mocha"];
          accents = ["sapphire"];
        };
      };
    };
    xdg.configFile = {
      "Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Sapphire/Catppuccin-Mocha-Sapphire.kvconfig";
        sha256 = "sha256:0n9f5hysr4k1sf9fd3sgd9fvqwrxrpcvj6vajqmb5c5ji8nv2w3c";
      };
      "Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Sapphire/Catppuccin-Mocha-Sapphire.svg";
        sha256 = "sha256:1hq9h34178h0d288hgwb0ngqnixz24m9lk0ahc4dahwqn77fndwf";
      };
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=catppuccin

        [Applications]
        catppuccin=qt5ct, org.qbittorrent.qBittorrent, hyprland-share-picker
      '';
    };
  };
}
