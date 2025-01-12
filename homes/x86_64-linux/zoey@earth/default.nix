{
  inputs,
  pkgs,
  system,
  lib,
  ...
}: {
  wms.hyprland.enable = true;
  apps = {
    web.librewolf.enable = true;

    tools.git.enable = true;
    tools.tmux.enable = true;
    tools.neovim.enable = true;
    tools.skim.enable = true;
    tools.starship.enable = true;
    tools.direnv.enable = true;
    tools.tealdeer.enable = true;
    tools.bat.enable = true;
    tools.emacs.enable = true;

    tools.gh.enable = true;

    term.kitty.enable = true;
    term.foot.enable = true;
    # term.rio.enable = true;
    term.alacritty.enable = true;
    term.ghostty.enable = true;

    music.spotify.enable = true;

    helpers = {
      rofi.enable = true;
      waybar.enable = true;
    };
  };

  shells.zsh.enable = true;

  rice.gtk.enable = true;

  services.lock.enable = true;
  services.music.enable = true;
  services.pm-bridge.enable = true;
  services.pm-bridge.nonInteractive = true;
  services.udiskie.enable = true;

  xdg.enable = true;
  programs = {
    gpg.enable = true;
    man.enable = true;
    eza.enable = true;
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "zen_twilight.desktop";
      "x-scheme-handler/http" = "zen_twilight.desktop";
      "x-scheme-handler/https" = "zen_twilight.desktop";
      "x-scheme-handler/about" = "zen_twilight.desktop";
      "x-scheme-handler/unknown" = "zen_twilight.desktop";

      "inode/directory" = ["org.gnome.Nautilus.desktop"];

      "image/jpeg" = ["org.gnome.Loupe.desktop"];
      "image/png" = ["org.gnome.Loupe.desktop"];
      "image/gif" = ["org.gnome.Loupe.desktop"];
      "image/webp" = ["org.gnome.Loupe.desktop"];
      "image/tiff" = ["org.gnome.Loupe.desktop"];
      "image/bmp" = ["org.gnome.Loupe.desktop"];
      "image/x-icon" = ["org.gnome.Loupe.desktop"];
      "image/svg+xml" = ["org.gnome.Loupe.desktop"];
    };
  };

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      "default-folder-viewer" = "list-view";
      "search-filter-time-type" = "last_modified";
    };
    "org/gnome/terminal/legacy/profiles:" = {
      "default" = "kitty";
    };
    "org/gnome/Loupe" = {
      "interpolation-quality" = "high"; # Set image scaling quality
      "zoom-gesture" = true; # Enable zoom gesture
    };
  };

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "pink";

  home.packages = [
    pkgs.gimp
    pkgs.slack

    pkgs.zoom-us
    pkgs.elisa

    pkgs.prismlauncher
    pkgs.obs-studio

    pkgs.ungoogled-chromium
    pkgs.uutils-coreutils-noprefix
    pkgs.yazi

    pkgs.thunderbird

    pkgs.custom.nvidia-nsight

    pkgs.custom.enc

    pkgs.nix-tree

    pkgs.mongodb-compass
    pkgs.postman
    pkgs.mosh

    pkgs.dconf
    pkgs.wl-clipboard
    pkgs.pavucontrol
    pkgs.wlogout
    pkgs.sway-audio-idle-inhibit
    pkgs.grim
    pkgs.slurp

    pkgs.neovide

    pkgs.nitch
    pkgs.nix-output-monitor
    pkgs.fastfetch

    # inputs.g2claude.packages.${pkgs.system}.default

    pkgs.signal-desktop

    pkgs.nh
    pkgs.dwl

    pkgs.foliate

    pkgs.killall
    pkgs.custom.rebuild
    pkgs.custom.powermenu

    pkgs.parsec-bin
    pkgs.filezilla
    pkgs.zed-editor
    pkgs.rmpc

    inputs.zen-browser.packages.${pkgs.system}.beta
    pkgs.mpc-cli

    pkgs.nautilus
    pkgs.nautilus-python
    pkgs.loupe

    pkgs.openvpn
    pkgs.telegram-desktop
    pkgs.linux-manual
    pkgs.man-pages
    pkgs.man-pages-posix
  ];

  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
  };

  programs.cava = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.btop = {
    enable = true;
    catppuccin.enable = true;
    extraConfig = ''
      update_ms = 100
      vim_keys = true
    '';
  };

  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
  };

  systemd.user.services.xwaylandvideobridge = {
    Unit = {
      Description = "Tool to make it easy to stream wayland windows and screens to exisiting applications running under Xwayland";
    };
    Service = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.xwaylandvideobridge;
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };

  systemd.user.services.kb-gui = {
    Unit = {
      Description = "KB Time/Date thing";
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      ExecStart = "${inputs.kb-gui.packages.${pkgs.system}.default}/bin/kb";
    };
  };
}
