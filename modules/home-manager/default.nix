{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zack";
  home.homeDirectory = "/home/zack";

  imports = [
    ./swayidle.nix
    ./vim/default.nix

    ../rice/hyprland
    ../rice/sway
    ../rice/gtk.nix
    ../rice/kitty.nix
    ../rice/waybar
    ../rice/dunst.nix
    ../rice/rio.nix
    ../rice/wofi.nix
    ../shell

    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
  };

  gtk.catppuccin.cursor.enable = false;

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };

  catppuccin.flavour = "macchiato";

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing it.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    pkgs.discord
    pkgs.slack
    (pkgs.nerdfonts.override {fonts = ["Iosevka"];})
    pkgs.git
    pkgs.spotify
    pkgs.neovide
    pkgs.wofi
    pkgs.alejandra
    pkgs.dconf
    pkgs.wl-clipboard
    pkgs.swaybg
    pkgs.zoom-us
    pkgs.pavucontrol
    pkgs.wlogout
    pkgs.prismlauncher
    pkgs.obs-studio
    inputs.kb-gui.packages.${pkgs.system}.kb
    pkgs.sway-audio-idle-inhibit
    pkgs.hyprshot
    pkgs.jetbrains.idea-community
    pkgs.jetbrains.datagrip

    pkgs.ungoogled-chromium
    pkgs.google-chrome # fuck

    pkgs.mongodb-compass
    pkgs.postman

    pkgs.openvpn

    pkgs.parsec-bin
    pkgs.filezilla
    pkgs.steam
    pkgs.gerbera

    pkgs.devenv
    pkgs.ghidra

    pkgs.zed-editor

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.killall
    (pkgs.writeShellScriptBin "rebuild" ''
      #!${pkgs.bash}/bin/bash
      set -e
      pushd ~/nixos/
      alejandra . &>/dev/null
      git add .
      echo "[REBUILD]: rebuilding nixos"
      sudo nixos-rebuild switch --flake ~/nixos#earth --max-jobs 4
      gen=$(nixos-rebuild list-generations | grep current)
      git commit -am "$gen"
      git push origin main
      popd
    '')
    (pkgs.writeShellScriptBin "work" ''
      #!${pkgs.bash}/bin/bash
      cd work/
      nix shell nixpkgs#openvpn
      openvpn zack_myers.ovpn
    '')
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  # programs.btop = {
  #   enable = true;
  #   catppuccin.enable = true;
  # };
  #
  # programs.lazygit = {
  #   enable = true;
  #   catppuccin.enable = true;
  # };
  #
  # programs.fzf = {
  #   enable = true;
  #   catppuccin.enable = true;
  # };

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

  # programs.nixvim = ./vim.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
