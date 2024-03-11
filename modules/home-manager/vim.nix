{pkgs, ...}: {
  config = {
    enable = true;

    plugins = {
      lualine.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
      rustaceanvim.enable = true;
      comment-nvim.enable = true;
      lsp-format.enable = true;
      toggleterm.enable = true;
      which-key.enable = true;
      todo-comments.enable = true;
    };

    plugins.neo-tree = {
      enable = true;
      enableGitStatus = true;
    };

    plugins.gitsigns.enable = true;

    # colorschemes.dracula.enable = true;
    # colorschemes.catppuccin.enable = true;
    colorschemes.kanagawa.enable = true;
    # colorschemes.oxocarbon.enable = true;
    # colorschemes.tokyonight.enable = true;
    options = {
      number = true;
      relativenumber = true;
      clipboard = "unnamedplus";

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      softtabstop = 2;
    };
    globals.mapleader = " ";

    plugins.bufferline = {
      enable = true;
    };

    # plugins.nvim-jdtls = {
    #   enable = true;
    #
    #   cmd = [
    #     "${pkgs.jdt-language-server}/bin/jdtls"
    #     "-data"
    #     "/home/zack/.cache/jdtls/workspace"
    #     "-configuration"
    #     "/home/zack/.cache/jdtls/config"
    #   ];
    # };

    plugins.lsp = {
      enable = true;
      servers = {
        tsserver.enable = true;
        lua-ls.enable = true;
        rust-analyzer = {
          enable = true;
          installRustc = false;
          installCargo = false;
        };
        nil_ls.enable = true;
      };
      keymaps = {
        lspBuf = {
          K = "hover";
          gD = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
        };
      };
    };

    keymaps = [
      {
        action = "<cmd>Neotree<CR>";
        key = "<leader>fe";
      }
      {
        action = "<cmd>lua _lazygit_toggle()<CR>";
        key = "<leader>gg";
      }
      {
        action = "<cmd>ToggleTerm<CR>";
        key = "<leader>h";
      }
      {
        action = "<cmd>OverseerRun<CR>";
        key = "<F36>";
      }
      {
        action = "<cmd>OverseerToggle<CR>";
        key = "<F48>";
      }
    ];

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
        snippet = {expand = "luasnip";};
        mappingPresets = ["insert"];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-space>" = "cmp.mapping.complete()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = dressing-nvim;
        config = ''lua require('dressing').setup()'';
      }
      {
        plugin = overseer-nvim;
        config = ''lua require('overseer').setup()'';
      }
    ];

    extraConfigLua = ''
      local Terminal  = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

      function _lazygit_toggle()
        lazygit:toggle()
      end
    '';
  };
}
