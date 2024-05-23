{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.starship;
in {
  options.apps.tools.starship = with types; {
    enable = mkBoolOpt false "Enable Tmux";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      settings = {
        add_newline = false;
        command_timeout = 1000;
        scan_timeout = 3;
        character = {
          error_symbol = "[󰘧](bold red)";
          success_symbol = "[󰘧](bold green)";
          vicmd_symbol = "[󰘧](bold yellow)";
          format = "$symbol [|](bold bright-black) ";
        };
        git_commit = {commit_hash_length = 7;};
        line_break.disabled = false;
        lua.symbol = "[](blue) ";
        python.symbol = "[](blue) ";
        hostname = {
          ssh_only = true;
          format = "[$hostname](bold blue) ";
          disabled = false;
        };
      };
    };
  };
}
