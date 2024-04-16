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
      # zsh-history
      # zsh-fzf-tab
      # zsh-f-sy-h
      # zsh-autocomplete
      # zsh-you-should-use
      # zsh-navigation-tools
    ];
  };
}
