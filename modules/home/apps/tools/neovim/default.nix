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

  lazy-nix-helper-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazy-nix-helper.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "b-src";
      repo = "lazy-nix-helper.nvim";
      rev = "63b20ed071647bb492ed3256fbda709e4bfedc45";
      hash = "sha256-TBDZGj0NXkWvJZJ5ngEqbhovf6RPm9N+Rmphz92CS3Q=";
    };
  };

  sanitizePluginName = input: let
    name = strings.getName input;
    intermediate = strings.removePrefix "vimplugin-" name;
    result = strings.removePrefix "lua5.1-" intermediate;
  in
    result;

  pluginList = plugins: strings.concatMapStrings (plugin: "  [\"${sanitizePluginName plugin.name}\"] = \"${plugin.outPath}\",\n") plugins;
in {
  options.apps.tools.neovim = with types; {
    enable = mkBoolOpt false "Enable Neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      catppuccin.enable = false;
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
        rustywind

        # LSP
        lua-language-server
        nixd
        rust-analyzer
        nodePackages.bash-language-server
        vscode-langservers-extracted
        nodePackages.vscode-json-languageserver
        nodePackages.typescript-language-server
        tailwindcss-language-server
        clang

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
      plugins = with pkgs.vimPlugins; [
        lazy-nix-helper-nvim
        lazy-nvim
      ];
      extraLuaPackages = with pkgs; [
        lua51Packages.lua-curl
        lua51Packages.nvim-nio
        lua51Packages.xml2lua
        lua51Packages.mimetypes
      ];
      extraLuaConfig = ''
        local plugins = {
        	${pluginList config.programs.neovim.plugins}
        }
        local lazy_nix_helper_path = "${lazy-nix-helper-nvim}"
        if not vim.loop.fs_stat(lazy_nix_helper_path) then
        	lazy_nix_helper_path = vim.fn.stdpath("data") .. "/lazy_nix_helper/lazy_nix_helper.nvim"
        	if not vim.loop.fs_stat(lazy_nix_helper_path) then
        		vim.fn.system({
        			"git",
        			"clone",
        			"--filter=blob:none",
        			"https://github.com/b-src/lazy_nix_helper.nvim.git",
        			lazy_nix_helper_path,
        		})
        	end
        end

        -- add the Lazy Nix Helper plugin to the vim runtime
        vim.opt.rtp:prepend(lazy_nix_helper_path)

        -- call the Lazy Nix Helper setup function
        local non_nix_lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        local lazy_nix_helper_opts = { lazypath = non_nix_lazypath, input_plugin_table = plugins }
        require("lazy-nix-helper").setup(lazy_nix_helper_opts)

        -- get the lazypath from Lazy Nix Helper
        local lazypath = require("lazy-nix-helper").lazypath()
        if not vim.loop.fs_stat(lazypath) then
        	vim.fn.system({
        		"git",
        		"clone",
        		"--filter=blob:none",
        		"https://github.com/folke/lazy.nvim.git",
        		"--branch=stable", -- latest stable release
        		lazypath,
        	})
        end
        vim.opt.rtp:prepend(lazypath)

        local filetypes = require("core.filetypes")
        local configurer = require("utils.configurer")
        local opts = {}

        if vim.g.vscode then
        	-- VSCode Neovim
        	opts.spec = "vscode.plugins"
        	opts.options = require("vscode.options")
        	opts.keymaps = require("vscode.keymaps")
        else
        	-- Normal Neovim
        	opts.spec = "plugins"
        	opts.options = require("core.options")
        	opts.keymaps = require("core.keymaps")
        	opts.autocmd = require("core.autocmd")
        	opts.signs = require("core.signs")
        end

        configurer.setup(opts)

        local handlers = require("lsp.handlers") -- Adjust the path as necessary

        local function setup_all_servers()
        	for server, setup_fn in pairs(handlers) do
        		if type(setup_fn) == "function" then
        			-- Call the setup function for each server
        			setup_fn()
        		end
        	end
        end

        setup_all_servers()

        vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
        vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
        vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
        vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

        vim.keymap.set("i", "<left>", '<cmd>echo "Use h to move!!"<CR>')
        vim.keymap.set("i", "<right>", '<cmd>echo "Use l to move!!"<CR>')
        vim.keymap.set("i", "<up>", '<cmd>echo "Use k to move!!"<CR>')
        vim.keymap.set("i", "<down>", '<cmd>echo "Use j to move!!"<CR>')
        -- Neovide config
        vim.o.guifont = "Iosevka Nerd Font Mono:h14"
        vim.g.neovide_transparency = 0.75

        -- vim.lsp.log.set_level(vim.lsp.log_levels.INFO)
        vim.filetype.add(filetypes)
      '';
    };

    xdg.configFile = {
      "nvim" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
