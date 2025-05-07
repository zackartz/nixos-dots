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

  programs.distrobox = {
    enable = true;
    containers = {
      proton-tkg = {
        image = "archlinux";
        additional_packages = "build-essential git";
      };
    };
  };

  catppuccin.mako.enable = false;

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

  catppuccin.cava.enable = true;
  catppuccin.fuzzel.enable = true;
  catppuccin.fzf.enable = true;

  work.vpn.enable = true;

  home.packages = with pkgs; [
    gimp3
    slack

    monero-cli

    zoom-us
    pandoc

    nexusmods-app-unfree

    prismlauncher
    obs-studio

    distrobox

    ungoogled-chromium
    uutils-coreutils-noprefix
    yazi
    reaper

    fragments
    inputs.posting.packages.${pkgs.system}.default

    heroic
    cartridges

    darktable

    thunderbird

    custom.nvidia-nsight

    custom.enc

    neural-amp-modeler-lv2

    nix-tree
    # inputs.g2claude.packages.${pkgs.system}.default

    mongodb-compass
    postman
    mosh

    dconf
    wl-clipboard
    pwvucontrol
    wlogout
    sway-audio-idle-inhibit
    grim
    slurp

    pods

    polari

    neovide

    nitch
    nix-output-monitor
    fastfetch

    signal-desktop
    flare-signal

    nh
    dwl

    foliate

    killall
    custom.rebuild
    custom.powermenu

    parsec-bin
    filezilla
    zed-editor
    rmpc

    inputs.zen-browser.packages.${pkgs.system}.beta

    starfetch
    lib.custom.nixos-stable.kiwix

    mpc-cli
    zathura
    gpgme.dev

    rofimoji
    renderdoc

    xwayland-satellite

    nautilus
    nautilus-python
    loupe

    openvpn
    linux-manual
    man-pages
    man-pages-posix

    ardour
  ];

  programs.vesktop = {
    enable = true;
  };

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

  programs.fuzzel.enable = true;

  programs.btop = {
    enable = true;
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
