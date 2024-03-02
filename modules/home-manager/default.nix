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
    inputs.nixvim.homeManagerModules.nixvim

    ./swayidle.nix

    ../rice/hyprland
    ../rice/gtk.nix
    ../rice/kitty.nix
    ../rice/waybar
    ../rice/dunst.nix
    ../rice/wofi.nix
    ../shell
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
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
    pkgs.rustup
    pkgs.git
    pkgs.lazygit
    pkgs.spotify
    pkgs.neovide
    pkgs.wofi
    pkgs.alejandra
    pkgs.dconf
    pkgs.wl-clipboard
    pkgs.swaybg
    pkgs.btop
    pkgs.zoom-us
    pkgs.pavucontrol
    pkgs.wlogout
    pkgs.prismlauncher
    pkgs.obs-studio
    inputs.kb-gui.packages.${pkgs.system}.kb

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (pkgs.writeShellScriptBin "rebuild" ''
      #!/usr/bin/env bash
      set -e
      pushd ~/nixos/
      alejandra . &>/dev/null
      git diff -U0 **/*.nix
      git add .
      echo "[REBUILD]: rebuilding nixos"
      sudo nixos-rebuild switch --flake ~/nixos#earth &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)
      gen=$(nixos-rebuild list-generations | grep current)
      git commit -am "$gen"
      git push origin main
      popd
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/zack/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
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

  programs.nixvim = ./vim.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
