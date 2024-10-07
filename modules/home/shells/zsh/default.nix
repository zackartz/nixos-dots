{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.shells.zsh;

  inherit (builtins) concatStringsSep;
in {
  options.shells.zsh = with types; {
    enable = mkBoolOpt false "Enable Zsh Configuration";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      sessionVariables = {
        LC_ALL = "en_US.UTF-8";
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";
        SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
        FLAKE = "/home/zoey/nixos/";
      };
      enableAutosuggestions = true;
      history = {
        save = 2137;
        size = 2137;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
      };

      initExtra = let
        sources = with pkgs; [
          "${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"
          "${zsh-history}/share/zsh/init.zsh"
          "${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
          "${zsh-f-sy-h}/share/zsh/site-functions/F-Sy-H.plugin.zsh"
          # "${zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
          "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
          "${zsh-navigation-tools}/share/zsh/site-functions/zsh-navigation-tools.plugin.zsh"
          "${oh-my-zsh}/share/oh-my-zsh/plugins/colored-man-pages/colored-man-pages.plugin.zsh"
        ];

        source = map (source: "source ${source}") sources;

        plugins = concatStringsSep "\n" ([
            "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
          ]
          ++ source);
      in ''
        ${plugins}

        export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';

      plugins = [
        {
          name = "zsh-tmux";
          file = "zsh-tmux.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "laggardkernel";
            repo = "zsh-tmux";
            rev = "v1.1.0";
            sha256 = "sha256-BB9L84HjUnV1OUIp2U2lHYHEg5q4p/TgqLcsCvInkC8=";
          };
        }
        {
          name = "zsh-autocomplete";
          file = "zsh-autocomplete.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "marlonrichert";
            repo = "zsh-autocomplete";
            rev = "008caaea55780dd2b55f119d6880c5b89e5e4bb2";
            sha256 = "sha256-jibIHwT/oVQUSxVrT0SGFSMu1N05szPyHZ4Qc7v6Ntc=";
          };
        }
      ];

      dirHashes = {
        music = "$HOME/Music";
        media = "/run/media/$USER";
      };

      shellAliases = import ./aliases.nix {inherit pkgs lib config;};
    };

    home.packages = with pkgs; [
      gnumake
      # Runs programs without installing them
      comma

      # grep replacement
      ripgrep

      # ping, but with cool graph
      gping

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
