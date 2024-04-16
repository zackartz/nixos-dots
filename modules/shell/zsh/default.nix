{
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
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

    dirHashes = {
      music = "$HOME/Music";
      media = "/run/media/$USER";
    };

    shellAliases = import ./aliases.nix {inherit pkgs lib config;};
    plugins = [
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
      }
      {
        name = "zsh-history";
        src = pkgs.zsh-history;
      }
      {
        name = "zsh-fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
      {
        name = "zsh-f-sy-h";
        src = pkgs.zsh-f-sy-h;
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
      }
      {
        name = "zsh-navigation-tools";
        src = pkgs.zsh-navigation-tools;
      }
    ];
  };
}
