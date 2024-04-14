{pkgs, ...}: let
  dreamsofcode-io-catppuccin-tmux =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "dreamsofcode-io-catppuccin-tmux";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "dreamsofcode-io";
        repo = "catppuccin-tmux";
        rev = "b4e0715356f820fc72ea8e8baf34f0f60e891718";
        sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
      };
    };
in {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 100000;
    plugins = with pkgs; [
      {
        plugin = dreamsofcode-io-catppuccin-tmux;
        extraConfig = "";
      }
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
