{pkgs, ...}: {
  config = {
    enable = true;

    plugins = {
      # lualine = {
      #   enable = true;
      #   sections.lualine_x = ["overseer"];
      # };
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
      closeIfLastWindow = true;
      autoCleanAfterSessionRestore = true;
      window = {
        width = 30;
      };
      filesystem = {
        followCurrentFile.enabled = true;
        hijackNetrwBehavior = "open_current";
        useLibuvFileWatcher = true;
      };
      defaultComponentConfigs = {
        icon = {
          folderEmpty = "";
          default = "󰈙";
        };
        indent = {
          padding = 0;
          indentSize = 1;
        };
        modified = {
          symbol = "󰧞";
        };
        name = {
          useGitStatusColors = true;
        };
        gitStatus = {
          symbols = {
            deleted = "D";
            renamed = "R";
            modified = "M";
            added = "A";
            untracked = "U";
            ignored = "";
            staged = "";
            unstaged = "!";
            conflict = "C";
          };
        };
        diagnostics = {
          symbols = {
            hint = "";
            info = "󰋽";
            warn = "";
            error = "󰅚";
          };
          highlights = {
            hint = "DiagnosticSignHint";
            info = "DiagnosticSignInfo";
            warn = "DiagnosticSignWarn";
            error = "DiagnosticSignError";
          };
        };
      };
    };

    plugins.noice = {
      enable = true;
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        hover = {
          opts = {
            silent = true;
          };
        };
      };
      presets = {
        bottom_search = false;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = false;
        lsp_doc_border = "rounded";
      };
    };

    plugins.notify.enable = true;

    plugins.gitsigns.enable = true;
    plugins.crates-nvim.enable = true;

    plugins.dap = {
      enable = true;
      extensions.dap-ui.enable = true;
    };

    # colorschemes.dracula.enable = true;
    # colorschemes.catppuccin.enable = true;
    # colorschemes.kanagawa.enable = true;
    # colorschemes.oxocarbon.enable = true;

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
      diagnostics = "nvim_lsp";
      diagnosticsUpdateInInsert = true;
      diagnosticsIndicator = null;
      offsets = [
        {
          filetype = "neo-tree";
          text = " NeoTree";
          text_align = "left";
          separator = "│";
        }
        {
          filetype = "dapui_watches";
          text = " DapUI";
          text_align = "left";
          separator = "|";
        }
        {
          filetype = "dbui";
          text = " DbUI";
          text_align = "left";
          separator = "|";
        }
      ];
    };

    plugins.indent-blankline = {
      enable = true;
      extraOptions = {
        exclude = {
          buftypes = [
            "nofile"
            "terminal"
          ];
          filetypes = [
            "help"
            "startify"
            "aerial"
            "alpha"
            "dashboard"
            "neogitstatus"
            "neo-tree"
            "TelescopePrompt"
          ];
        };
        scope = {
          show_start = false;
          show_end = false;
          highlight = ["@keyword"];
          char = "▏";
          include = {
            node_type = {
              lua = ["table_constructor"];
            };
          };
        };
        whitespace = {
          remove_blankline_trail = true;
        };
        indent = {char = "▏";};
      };
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
        svelte.enable = true;
        tailwindcss.enable = true;
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
        snippet = {
          expand = ''            function(args)
              require('luasnip').lsp_expand(args.body)
            end'';
        };
        mappingPresets = ["insert"];
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = dressing-nvim;
        config = ''lua require("dressing").setup()'';
      }
      {
        plugin = overseer-nvim;
        config = ''lua require('overseer').setup({ task_list = { direction = "bottom" } })'';
      }
      {
        plugin = nui-nvim;
      }
      {
        plugin = lualine-nvim;
      }
      {
        plugin = base46;
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
