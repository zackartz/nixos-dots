{pkgs, ...}: let
  tmux-super-fingers =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
        sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
      };
    };
in {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 100000;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      bind -n M-H previous-window
      bind -n M-L next-window
    '';
  };
}
