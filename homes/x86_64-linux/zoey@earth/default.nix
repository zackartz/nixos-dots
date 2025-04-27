{
  inputs,
  pkgs,
  system,
  lib,
  ...
}: {
  # wms.hyprland.enable = true;
  wms.niri.enable = true;
  apps = {
    web.librewolf.enable = true;
    web.zen.setDefault = true;
    web.zen.enable = true;

    tools.git.enable = true;
    tools.tmux.enable = true;
    tools.neovim.enable = true;
    tools.skim.enable = true;
    tools.starship.enable = true;
    tools.direnv.enable = true;
    tools.tealdeer.enable = true;
    tools.bat.enable = true;
    tools.emacs.enable = false;

    tools.gh.enable = true;

    term.kitty.enable = true;
    term.foot.enable = true;
    term.rio.enable = true;
    term.alacritty.enable = true;
    term.ghostty.enable = true;

    music.spotify.enable = true;
    video.mpv.enable = true;

    mail.aerc.enable = true;

    helpers = {
      waybar.enable = true;
      swaync.enable = true;
    };
  };

  shells.zsh.enable = true;

  rice.gtk.enable = true;
  rice.qt.enable = true;

  services.lock.enable = true;
  services.music.enable = true;
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

  # programs.pywal2.enable = true;

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "inode/directory" = ["org.gnome.Nautilus.desktop"];

      "image/jpeg" = ["org.gnome.Loupe.desktop"];
      "image/png" = ["org.gnome.Loupe.desktop"];
      "image/gif" = ["org.gnome.Loupe.desktop"];
      "image/webp" = ["org.gnome.Loupe.desktop"];
      "image/tiff" = ["org.gnome.Loupe.desktop"];
      "image/bmp" = ["org.gnome.Loupe.desktop"];
      "image/x-icon" = ["org.gnome.Loupe.desktop"];
      "image/svg+xml" = ["org.gnome.Loupe.desktop"];

      "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-compressed-zip" = "org.gnome.FileRoller.desktop";
      "application/x-archive" = "org.gnome.FileRoller.desktop";
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
  catppuccin.flavor = "mocha";
  catppuccin.accent = "red";

  catppuccin.aerc.enable = true;

  work.vpn.enable = true;

  home.packages = with pkgs; [
    pkgs.gimp
    pkgs.slack

    pkgs.monero-cli

    pkgs.zoom-us
    pkgs.pandoc

    pkgs.prismlauncher
    pkgs.obs-studio

    pkgs.ungoogled-chromium
    pkgs.uutils-coreutils-noprefix
    pkgs.yazi
    pkgs.reaper

    pkgs.fragments
    inputs.posting.packages.${pkgs.system}.default

    pkgs.heroic
    pkgs.cartridges

    pkgs.darktable

    pkgs.thunderbird

    pkgs.custom.nvidia-nsight

    pkgs.custom.enc

    pkgs.neural-amp-modeler-lv2

    pkgs.nix-tree
    # inputs.g2claude.packages.${pkgs.system}.default

    pkgs.mongodb-compass
    pkgs.postman
    pkgs.mosh

    pkgs.dconf
    pkgs.wl-clipboard
    pkgs.pwvucontrol
    pkgs.wlogout
    pkgs.sway-audio-idle-inhibit
    pkgs.grim
    pkgs.slurp

    pkgs.pods

    pkgs.polari
    pkgs.flare-signal

    pkgs.neovide

    pkgs.nitch
    pkgs.nix-output-monitor
    pkgs.fastfetch

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

    pkgs.starfetch
    lib.custom.nixos-stable.kiwix

    pkgs.mpc-cli
    pkgs.zathura
    pkgs.gpgme.dev

    pkgs.rofimoji
    pkgs.renderdoc

    pkgs.xwayland-satellite

    pkgs.nautilus
    pkgs.nautilus-python
    pkgs.loupe

    pkgs.openvpn
    pkgs.telegram-desktop
    pkgs.linux-manual
    pkgs.man-pages
    pkgs.man-pages-posix

    pkgs.ardour

    pkgs.shadps4

    pkgs.audacity
  ];

  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
  };

  home.file.".mozilla/native-messaging-hosts/gpgmejson.json".text = builtins.toJSON {
    name = "gpgmejson";
    description = "JavaScript binding for GnuPG";
    path = "${pkgs.gpgme.dev}/bin/gpgme-json";
    type = "stdio";
    allowed_extensions = ["jid1-AQqSMBYb0a8ADg@jetpack"];
  };

  programs.cava = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      general = {
        # bars = 2;
        # channels = 2;
        # mono = "no";

        # smoothing = 0;
        # falloff = 0.0;
      };
      input = {
        method = "pulse";
        source = "alsa_output.usb-MOTU_M4_M4MA03F7DV-00.HiFi__Line1__sink.monitor";
      };
      # output = {
      #   method = "ncurses";
      # };
    };
  };

  catppuccin.fuzzel.enable = true;

  programs.fuzzel.enable = true;

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
  };

  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
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
