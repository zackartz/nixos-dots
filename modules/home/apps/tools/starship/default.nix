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
    home.packages = [
      pkgs.custom.getgithost
    ];

    programs.starship = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      settings = {
        add_newline = false;
        command_timeout = 1000;
        scan_timeout = 10;
        format = ''
          $username$shlvl$kubernetes''${custom.dir}''${custom.home_dir}$directory''${custom.git_host}$git_branch$git_commit$git_state$git_status$hg_branch$docker_context$package$cmake$dart$dotnet$elixir$elm$erlang$golang$helm$java$julia$kotlin$nim$nodejs$ocaml$perl$php$purescript$python$ruby$rust$swift$terraform$vagrant$zig$nix_shell$conda$aws$gcloud$openstack$env_var$crystal$custom$cmd_duration$lua$line_break$jobs$status$character
        '';
        character = {
          success_symbol = "[>](#89b4fa)[>](#f5c2e7)[>](#f2cdcd)";
          error_symbol = "[>>>](red)";
        };
        directory = {
          truncation_length = 1;
          format = "[ $path ]($style)[$read_only]($read_only_style) ";
          style = "fg:white bg:black bold";
          read_only = "  ";
          read_only_style = "fg:black bg:red";
        };
        git_commit = {commit_hash_length = 7;};
        git_branch = {format = "[$symbol$branch]($style) ";};
        git_status = {
          conflicted = "[<](white)=[$count](bright-white bold)[>](white)";
          ahead = "[<](white)⇡[$count](bright-white bold)[>](white)";
          behind = "[<](white)⇣[$count](bright-white bold)[>](white)";
          diverged = "[<](white)⇕⇡[$ahead_count](bright-white bold)⇣[$behind_count](bright-white)[>](white)";
          untracked = "[<](white)?[$count](bright-white bold)[>](white)";
          stashed = "[<](white)$[$count](bright-white bold)[>](white)";
          modified = "[<](white)![$count](bright-white bold)[>](white)";
          staged = "[<](white)+[$count](bright-white bold)[>](white)";
          renamed = "[<](white)»[$count](bright-white bold)[>](white)";
          deleted = "[<](white)✗[$count](bright-white bold)[>](white)";
        };
        custom = {
          home_dir = {
            command = "echo  ";
            when = "[ \"$PWD\" == \"$HOME\" ]";
            shell = "[\"bash\",\"--norc\",\"--noprofile\"]";
            style = "fg:bright-white bg:bright-black";
            format = "[ $output ]($style)";
          };
          dir = {
            command = "echo  ";
            when = "[ \"$PWD\" != \"$HOME\" ]";
            shell = "[\"bash\",\"--norc\",\"--noprofile\"]";
            style = "fg:blue bg:bright-black";
            format = "[ $output ]($style)";
          };
          git_host = {
            command = "getgithost";
            when = "git rev-parse --is-inside-work-tree 2> /dev/null";
            shell = "[\"bash\",\"--norc\",\"--noprofile\"]";
            style = "bright-yellow bold";
            format = "at [$output]($style)";
          };
        };
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
