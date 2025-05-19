{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.shells.fish;
in {
  options.shells.fish = with types; {
    enable = mkBoolOpt false "Enable Fish Configuration";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      generateCompletions = true;
      interactiveShellInit = ''
        set -gx LC_ALL en_US.UTF-8
        set -gx SSH_AUTH_SOCK /run/user/1000/keyring/ssh
        set -gx FLAKE /home/zoey/nixos/
        set -g FZF_PREVIEW_FILE_CMD "head -n 10"
        set -g FZF_PREVIEW_DIR_CMD "ls"
      '';

      plugins = [
        {
          name = "foreign-env";
          src = pkgs.fishPlugins.foreign-env.src;
        }
        {
          name = "fzf.fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages.src;
        }
      ];

      functions = {
        pf = ''
          fzf --bind ctrl-y:preview-up,ctrl-e:preview-down \
              --bind ctrl-b:preview-page-up,ctrl-f:preview-page-down \
              --bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down \
              --bind ctrl-k:up,ctrl-j:down \
              --preview='bat --style=numbers --color=always --line-range :100 {}'
        '';

        ff = ''
          for file in (pf)
              set cmd "v $file"
              echo $cmd
              eval $cmd
          end
        '';
      };

      shellAliases = import ../aliases.nix {inherit pkgs lib config;};
    };

    home.packages = with pkgs; [
      gnumake
      # Runs programs without installing them
      comma

      # grep replacement
      ripgrep

      # ping, but with cool graph
      gping

      fzf

      # dns client
      dogdns

      # neofetch but for git repos
      onefetch

      # neofetch but for cpu's
      cpufetch

      # download from yt and other websites
      yt-dlp

      zsh-history

      # man pages for tiktok attention span mfs
      tealdeer

      # markdown previewer
      glow

      # profiling tool
      hyperfine

      imagemagick
      ffmpeg-full

      # preview images in terminal
      catimg

      # networking stuff
      nmap
      wget

      # faster find
      fd

      # http request thingy
      xh

      # generate regex
      grex

      # json thingy
      jq

      # syncthnig for acoustic people
      rsync

      figlet
      # Generate qr codes
      qrencode

      # script kidde stuff
      hcxdumptool
      hashcat

      unzip
    ];
  };
}
