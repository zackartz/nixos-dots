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
    programs.tmux = let
      dreamsofcode-io-catppuccin-tmux =
        pkgs.tmuxPlugins.mkTmuxPlugin
        {
          pluginName = "catppuccin";
          version = "unstable-2023-01-06";
          src = pkgs.fetchFromGitHub {
            owner = "dreamsofcode-io";
            repo = "catppuccin-tmux";
            rev = "b4e0715356f820fc72ea8e8baf34f0f60e891718";
            sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
          };
        };
    in {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      catppuccin.enable = false;
      historyLimit = 100000;
      plugins = with pkgs; [
        {
          plugin = dreamsofcode-io-catppuccin-tmux;
          extraConfig = "";
        }
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

        set -g @catppuccin_flavor 'macchiato'
        set -g @catppuccin_window_left_separator ""
        set -g @catppuccin_window_right_separator " "
        set -g @catppuccin_window_middle_separator " █"
        set -g @catppuccin_window_number_position "right"
        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_default_text "#W"
        set -g @catppuccin_window_current_fill "number"
        set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
        set -g @catppuccin_status_modules_right "directory meetings cpu date_time uptime"
        set -g @catppuccin_status_modules_left "session"
        set -g @catppuccin_status_left_separator  " "
        set -g @catppuccin_status_right_separator " "
        set -g @catppuccin_status_right_separator_inverse "no"
        set -g @catppuccin_status_fill "icon"
        set -g @catppuccin_status_connect_separator "no"
        set -g @catppuccin_directory_text "#{b:pane_current_path}"
        set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
        set -g @catppuccin_date_time_text "%H:%M"

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
      '';
    };
  };
}
