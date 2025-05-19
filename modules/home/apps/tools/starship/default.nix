{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.apps.tools.starship;
in {
  options.apps.tools.starship = with types; {
    enable = mkEnableOption "Starship prompt";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      settings = {
        add_newline = false;
        format = "$username$directory$git_branch$git_status$python$rust$nodejs$nix_shell$cmd_duration$line_break$character";

        # Username display
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          show_always = true;
        };

        # Modern minimal prompt character
        character = {
          success_symbol = "[>](blue)";
          error_symbol = "[>](red)";
        };

        # Simplified directory display
        directory = {
          truncation_length = 1;
          style = "bold lavender";
          format = "[$path]($style) ";
          read_only = " ";
        };

        # Streamlined git status indicators
        git_branch = {
          format = "[$symbol$branch]($style) ";
          style = "mauve";
        };

        git_status = {
          format = "[$all_status$ahead_behind]($style) ";
          style = "bold peach";
          conflicted = "=";
          ahead = "⇡";
          behind = "⇣";
          diverged = "⇕";
          untracked = "?";
          stashed = "$";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "✗";
        };

        # Language modules with minimal styling
        python.symbol = "[](yellow) ";
        rust.symbol = "[](peach) ";
        nodejs.symbol = "[](green) ";
        nix_shell.symbol = "[](blue) ";

        # Command duration and line break
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };

        line_break.disabled = false;
      };
    };
  };
}
