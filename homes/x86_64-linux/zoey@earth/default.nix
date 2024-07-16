{
  inputs,
  pkgs,
  system,
  lib,
  ...
}: {
  wms.hyprland.enable = true;
  apps = {
    web.firefox.enable = true;
    web.librewolf.enable = true;
    web.librewolf.setDefault = true;

    tools.git.enable = true;
    tools.tmux.enable = true;
    tools.neovim.enable = true;
    tools.skim.enable = true;
    tools.starship.enable = true;
    tools.direnv.enable = true;
    tools.tealdeer.enable = true;
    tools.bat.enable = true;

    tools.gh.enable = true;

    term.kitty.enable = true;

    music.spotify.enable = true;

    helpers = {
      anyrun.enable = true;
      ags.enable = true;
    };
  };

  shells.zsh.enable = true;

  rice.gtk.enable = true;

  services.lock.enable = true;

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

    pkgs.thunderbird

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

    pkgs.xfce.thunar
    pkgs.feh
    pkgs.nitch
    pkgs.nix-output-monitor
    pkgs.fastfetch

    pkgs.nh
    pkgs.dwl

    pkgs.foliate

    pkgs.killall
    pkgs.custom.rebuild
    pkgs.custom.powermenu

    pkgs.parsec-bin
    pkgs.filezilla
    pkgs.ghidra
    pkgs.zed-editor
    pkgs.openvpn
    pkgs.telegram-desktop
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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
      ExecStart = "${inputs.kb-gui.packages.${pkgs.system}.kb}/bin/kb";
    };
  };
}
