{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.ohmyposh;
in {
  options.apps.tools.ohmyposh = with types; {
    enable = mkBoolOpt false "Enable OhMyPosh";
  };

  config = mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        palette = {
          os = "#ACB0BE";
          pink = "#F5BDE6";
          lavender = "#B7BDF8";
          blue = "#8AADF4";
          wight = "#FFFFFF";
          text = "#494D64";
        };
        blocks = [
          {
            alignment = "left";
            segments = [
              {
                background = "p:blue";
                foreground = "p:wight";
                "powerline_symbol" = "";
                "leading_diamond" = "█";
                style = "diamond";
                template = "{{.Icon}} ";
                type = "os";
              }
              {
                background = "p:blue";
                foreground = "p:text";
                "powerline_symbol" = "";
                style = "diamond";
                template = "{{ .UserName }}@{{ .HostName }} ";
                type = "session";
              }
              {
                background = "p:pink";
                foreground = "p:text";
                properties = {
                  "folder_icon" = "..\ue5fe..";
                  "home_icon" = "~";
                  style = "agnoster_short";
                };
                "powerline_symbol" = "";
                style = "powerline";
                template = " {{ .Path }} ";
                type = "path";
              }
              {
                background = "p:lavender";
                foreground = "p:text";
                style = "powerline";
                properties = {
                  "branch_icon" = " ";
                  "cherry_pick_icon" = " ";
                  "commit_icon" = " ";
                  "fetch_status" = false;
                  "fetch_upstream_icon" = false;
                  "merge_icon" = " ";
                  "no_commits_icon" = " ";
                  "rebase_icon" = " ";
                  "revert_icon" = " ";
                  "tag_icon" = " ";
                };
                "powerline_symbol" = "";
                template = " {{ .HEAD }} ";
                type = "git";
              }
            ];
            type = "prompt";
          }
        ];
        "final_space" = true;
        version = 2;
      };
    };
  };
}
