{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.neovim;

  nvimDir = "/home/${config.home.username}/nixos/modules/home/apps/tools/neovim";
in {
  options.apps.tools.neovim = with types; {
    enable = mkBoolOpt false "Enable Neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        # Formatters
        alejandra # Nix
        black # Python
        prettierd # Multi-language
        shfmt
        isort
        stylua

        # LSP
        lua-language-server
        nixd
        rust-analyzer
        nodePackages.bash-language-server
        vscode-langservers-extracted
        nodePackages.vscode-json-languageserver
        nodePackages.typescript-language-server
        tailwindcss-language-server

        # Tools
        git
        html-tidy
        cmake
        fzf
        charm-freeze
        gcc
        gnumake
        nodejs
        fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
        sqlite
        postgresql
        mongosh
        gerbera
        vscode-extensions.vadimcn.vscode-lldb.adapter
      ];
      plugins = [
        pkgs.vimPlugins.lazy-nvim # All other plugins are managed by lazy-nvim
      ];
      extraLuaPackages = with pkgs; [
        lua51Packages.lua-curl
        lua51Packages.nvim-nio
        lua51Packages.xml2lua
        lua51Packages.mimetypes
      ];
    };

    xdg.configFile = {
      # Raw symlink to the plugin manager lock file, so that it stays writeable
      "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${nvimDir}/lazy-lock.json";
      "nvim" = {
        source = ./config;
        recursive = true;
      };
    };

    # home.activation.neovim = hm.dag.entryAfter ["linkGeneration"] ''
    #   #! /bin/bash
    #   NVIM_WRAPPER=~/.nix-profile/bin/nvim
    #   STATE_DIR=~/.local/state/nix/
    #   STATE_FILE=$STATE_DIR/lazy-lock-checksum
    #   LOCK_FILE=~/.config/nvim/lazy-lock.json
    #   HASH=$(nix-hash --flat $LOCK_FILE)
    #   CURL_DIR=${pkgs.curl}
    #
    #   [ ! -d $STATE_DIR ] && mkdir -p $STATE_DIR
    #   [ ! -f $STATE_FILE ] && touch $STATE_FILE
    #
    #   if [ "$(cat $STATE_FILE)" != "$HASH" ]; then
    #     echo "Syncing neovim plugins"
    #     PATH="$PATH:${pkgs.git}/bin" $DRY_RUN_CMD $NVIM_WRAPPER --headless "+Lazy! restore" +qa
    #     $DRY_RUN_CMD echo $HASH >$STATE_FILE
    #   else
    #     $VERBOSE_ECHO "Neovim plugins already synced, skipping"
    #   fi
    # '';
  };
}
