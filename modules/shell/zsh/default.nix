{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;
in {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.zsh = {
    enable = true;
    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      ZSH_AUTOSUGGEST_USE_ASYNC = "true";
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    };
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
      ];

      source = map (source: "source ${source}") sources;

      plugins = concatStringsSep "\n" ([
          "${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin"
        ]
        ++ source);
    in ''
      ${plugins}

      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
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
    ];

    dirHashes = {
      music = "$HOME/Music";
      media = "/run/media/$USER";
    };

    shellAliases = import ./aliases.nix {inherit pkgs lib config;};
  };
}
