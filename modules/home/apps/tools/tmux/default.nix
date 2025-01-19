{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.tmux;
in {
  options.apps.tools.tmux = with types; {
    enable = mkBoolOpt false "Enable Tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      catppuccin.enable = true;
      historyLimit = 100000;
      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.yank
        tmuxPlugins.cpu
      ];
      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on

        set -g base-index 1
        set -g pane-base-index 1
        setw -g mode-keys vi
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        set -g @catppuccin_window_status_style "basic"
        set -g default-terminal "tmux-256color"
        set -g allow-passthrough on

        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        set -agF status-right "#{E:@catppuccin_status_cpu}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        set -ag status-right "#{E:@catppuccin_status_uptime}"

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -v -c "#{pane_current_path}"

        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix

        bind -n M-H previous-window
        bind -n M-L next-window


        bind-key C-j display-popup -E "\
            tmux list-sessions -F '#{session_name}' |\
            fzf --reverse --header 'Switch sessions' |\
            xargs tmux switch-client -t"


        set-option -g destroy-unattached on
        set-option -g exit-empty on
        set-option -g exit-unattached on

        set-hook -g after-new-session 'run-shell "tmux rename-session \"#{b:pane_current_path}\""'
        set-hook -g after-new-window 'run-shell "tmux rename-session \"#{b:pane_current_path}\""'
        set-hook -g after-kill-pane 'run-shell "tmux rename-session \"#{b:pane_current_path}\""'
        set-hook -g pane-focus-in 'run-shell "tmux rename-session \"#{b:pane_current_path}\""'
      '';
    };
  };
}
