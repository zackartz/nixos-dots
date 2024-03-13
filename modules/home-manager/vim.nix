{pkgs, ...}: {
  config = {
    enable = true;

    plugins = {
      lualine = {
        enable = true;
        sections.lualine_x = ["overseer"];
      };
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
    # colorschemes.kanagawa.enable = true;
    # colorschemes.oxocarbon.enable = true;
    colorschemes.tokyonight = {
      enable = true;
      onColors = ''        function(colors)
              colors.gitSigns.add = colors.green
              colors.gitSigns.change = colors.blue
              colors.gitSigns.delete = colors.red
              colors.gitSigns.ignored = colors.bg
              colors.status_line = colors.none
              return colors
            end'';
      onHighlights = ''           function(hl, c)
                 local highlights = {
                   NormalSB = { bg = nil },
                   NormalFloat = { bg = nil },
                   FloatBorder = { fg = c.dark3 },
                   FloatTitle = { fg = c.dark3 },
                   CursorLineNr = { fg = c.blue },
                   Breakpoint = { fg = c.orange },
                   WinSeparator = { fg = c.terminal_black },
                   WinBar = { bg = nil },
                   WinBarNC = { bg = nil },
                   LspInlayHint = { fg = c.comment },

                   DiagnosticSignError = { fg = c.red },
                   DiagnosticSignWarn = { fg = c.yellow },
                   DiagnosticSignHint = { fg = c.blue },
                   DiagnosticSignInfo = { fg = c.blue },
                   DiagnosticError = { fg = c.red },
                   DiagnosticWarn = { fg = c.yellow },
                   DiagnosticHint = { fg = c.blue },
                   DiagnosticInfo = { fg = c.blue },

                   BufferLineFill = { bg = c.bg },
                   BufferLineCloseButtonSelected = { fg = c.red },
                   BufferLineError = { fg = c.red, bg = c.bg, bold = true },
                   BufferLineWarning = { fg = c.yellow, bg = c.bg, bold = true },
                   BufferLineHint = { fg = c.blue, bg = c.bg, bold = true },
                   BufferLineInfo = { fg = c.blue, bg = c.bg, bold = true },
                   BufferLineModified = { fg = c.green, bg = c.bg },
                   BufferLineDuplicate = { fg = c.comment, bg = c.bg, bold = true },
                   BufferLineDuplicateSelected = { fg = c.fg, bg = c.bg, bold = true, italic = true },
                   BufferLineTruncMarker = { bg = c.bg },

                   NeoTreeDirectoryName = { fg = c.fg },
                   NeoTreeNormalNC = { bg = c.bg },
                   NeoTreeNormal = { bg = c.bg },
                   NeoTreeGitUntracked = { fg = c.orange },
                   NeoTreeGitUnstaged = { fg = c.cyan },

                   WhichKeyFloat = { bg = c.bg },
                   FlashLabel = { fg = c.red, bg = c.bg },
                   FlashCurrent = { bg = c.fg },

                   TelescopeNormal = { bg = nil },
                   TelescopePromptPrefix = { fg = c.dark3 },
                   TelescopeBorder = { link = "FloatBorder" },

                   NotifyINFOBorder = { fg = c.blue },
                   NotifyINFOTitle = { fg = c.blue },
                   NotifyINFOIcon = { fg = c.blue },
                   NotifyERRORBorder = { fg = c.red },
                   NotifyERRORTitle = { fg = c.red },
                   NotifyERRORIcon = { fg = c.red },
                   NotifyWARNBorder = { fg = c.yellow },
                   NotifyWARNTitle = { fg = c.yellow },
                   NotifyWARNIcon = { fg = c.yellow },
                   ErrorMsg = { fg = c.red },

                   diffAdded = { fg = c.green },
                   diffRemoved = { fg = c.red },
                   diffChanged = { fg = c.blue },
                   diffNewFile = { fg = c.cyan },
                   diffOldFile = { fg = c.comment },
                   DiffAdd = { fg = c.green },
                   DiffChange = { fg = c.blue },
                   DiffDelete = { fg = c.red },
                   DiffText = { fg = c.purple },

                   DropBarSeparator = { fg = c.dark5 },
                   DropBarPick = { fg = c.red, bold = true, italic = true },
                   DropBarKind = { fg = c.fg },
                   DropBarKindFolder = { fg = c.dark5 },
                   DropBarIconUIPickPivot = { link = "DropBarPick" },
                   DropBarIconUISeparator = { link = "DropBarSeparator" },
                 }

                 for key, value in pairs(highlights) do
                   hl[key] = value
                 end

                 local dropbar_hl = {
                   "Array",
                   "Boolean",
                   "Constant",
                   "Constructor",
                   "Enum",
                   "EnumMember",
                   "Field",
                   "Function",
                   "Identifier",
                   "List",
                   "Macro",
                   "Number",
                   "Object",
                   "Operator",
                   "Package",
                   "Property",
                   "Reference",
                   "String",
                   "Type",
                   "TypeParameter",
                   "Unit",
                   "Value",
                   "Variable",
                   "Null",
                   "Specifier",
                   "BreakStatement",
                   "CaseStatement",
                   "ContinueStatement",
                   "Declaration",
                   "Delete",
                   "DoStatement",
                   "ElseStatement",
                   "ForStatement",
                   "IfStatement",
                   "Repeat",
                   "Scope",
                   "Specifier",
                   "Statement",
                   "SwitchStatement",
                   "WhileStatement",
                   "Class",
                   "Event",
                   "Interface",
                   "Method",
                   "Module",
                   "Namespace",
                   "MarkdownH1",
                   "MarkdownH2",
                   "MarkdownH3",
                   "MarkdownH4",
                   "MarkdownH5",
                   "MarkdownH6",
                 }

                 for _, value in pairs(dropbar_hl) do
                   hl["DropBarKind" .. value] = { link = "DropBarKind" }
                 end
        end'';
    };
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
        config = ''lua require("dressing").setup()'';
      }
      {
        plugin = overseer-nvim;
        config = ''lua require('overseer').setup({ task_list = { direction = "bottom" } })'';
      }
      {
        plugin = dropbar-nvim;
        config = ''lua require('dropbar').setup({ icons = { enable = true, kinds = { use_devicons = false, symbols = { File = "", Folder = "" } }} })'';
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
