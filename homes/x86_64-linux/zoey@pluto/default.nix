{
  inputs,
  pkgs,
  system,
  lib,
  ...
}: {
  apps = {
    tools.git.enable = true;
    tools.tmux.enable = true;
    tools.neovim.enable = true;
    tools.starship.enable = true;
    tools.skim.enable = true;
    tools.direnv.enable = true;
    tools.tealdeer.enable = true;
    tools.bat.enable = true;
  };

  shells.zsh.enable = true;

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

  # catppuccin.enable = true;

  home.packages = [
    pkgs.mosh

    pkgs.nix-output-monitor
    pkgs.fastfetch

    pkgs.nh

    pkgs.killall
    pkgs.custom.rebuild
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
}
