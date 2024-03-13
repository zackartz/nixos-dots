{
  pkgs,
  inputs,
  ...
}: {
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
        plugin = nui-nvim;
      }
    ];

    extraConfigLua = ''
            local Terminal  = require('toggleterm.terminal').Terminal
            local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

            function _lazygit_toggle()
              lazygit:toggle()
            end

            local colors = require("tokyonight.colors")
            local tokyonight = require("lualine.themes.tokyonight")


      local sources = {}

      local icons = {
        Vim = "",
        Config = "",
        Normal = "󰡛",
        Insert = "󰌌",
        Terminal = "",
        Visual = "󰉸",
        Command = "",
        Save = "󰳻",
        NotSaved = "󱙃",
        Restore = "",
        Trash = "",
        Fedora = "",
        Lua = "",
        Github = "",
        Git = "󰊢",
        GitDiff = "",
        GitBranch = "",
        GitCommit = "",
        Add = "󰐕",
        Modified = "󰜥",
        Removed = "󰍴",
        DiffRemoved = "",
        Error = "󰅚",
        Info = "󰋽",
        Warn = "",
        Hint = "",
        Package = "󰏖",
        FileTree = "󰙅",
        Folder = "",
        EmptyFolder = "",
        FolderClock = "󰪻",
        FolderOpened = "",
        File = "",
        NewFile = "",
        DefaultFile = "󰈙",
        Color = "",
        ColorPicker = "󰴱",
        ColorOn = "󰌁",
        ColorOff = "󰹊",
        Swap = "󰓡",
        Minimap = "",
        Window = "",
        Windows = "",
        Ellipsis = "…",
        Search = "",
        TextSearch = "󱩾",
        TabSearch = "󱦞",
        FileSearch = "󰱼",
        Clear = "",
        Braces = "󰅩",
        Exit = "",
        Debugger = "",
        Breakpoint = "",
        History = "",
        Check = "󰄵",
        SmallDot = "󰧞",
        Dots = "󰇘",
        Install = "",
        Help = "󰋖",
        Clipboard = "󰅌",
        Indent = "",
        LineWrap = "󰖶",
        Comment = "󱋄",
        Close = "󰅘",
        Open = "󰏋",
        Toggle = "󰔡",
        Stop = "",
        Restart = "",
        CloseMultiple = "󰱞",
        NextBuffer = "󰮱,",
        PrevBuffer = "󰮳",
        FoldClose = "",
        FoldOpen = "",
        Popup = "󰕛",
        Vertical = "",
        Horizontal = "",
        Markdown = "󰽛",
        Up = "",
        Down = "",
        Left = "",
        Right = "",
        Variable = "",
        Symbol = "",
        Stack = "",
        Format = "󰉣",
        Edit = "󰤌",
        Fix = "",
        Run = "󰐍",
        Twilight = "󰖚",
        Recording = "󰑋",
        Notification = "󰍢",
        NotificationDismiss = "󱙍",
        NotificationLog = "󰍩",
        Code = "",
        DropDown = "󰁊",
        Web = "󰖟",
        Dependencies = "",
        Update = "󰚰",
        Database = "",
        Pin = "",
        Book = "󰂽",
        BookmarkSearch = "󰺄",
        Download = "󰇚",
      }

      local fmt = function(icon, text, space) return icons[icon] .. string.rep(" ", space or 1) .. text end

      sources.mode = {
        "mode",
        fmt = function(name)
          local map = {
            NORMAL = icons.Normal,
            INSERT = icons.Insert,
            TERMINAL = icons.Terminal,
            VISUAL = icons.Visual,
            ["V-LINE"] = icons.Visual,
            ["V-BLOCK"] = icons.Visual,
            ["O-PENDING"] = icons.Ellipsis,
            COMMAND = icons.Command,
            REPLACE = icons.Edit,
            SELECT = icons.Visual,
          }
          local icon = map[name] and map[name] or icons.Vim
          return icon .. " " .. name
        end,
        color = function()
          local colors = require("tokyonight.colors")
          local mode = vim.fn.mode()
          local map = {
            n = colors.default.blue,
            i = colors.default.green,
            c = colors.default.yellow,
            t = colors.default.cyan,
            R = colors.default.red,
            v = colors.default.magenta,
            V = colors.default.magenta,
            s = colors.default.magenta,
            S = colors.default.magenta,
          }
          return {
            fg = map[mode] or colors.default.magenta,
            bg = colors.night.bg,
          }
        end,
      }

      sources.branch = {
        "branch",
        icon = icons.GitBranch,
        color = function()
          local colors = require("tokyonight.colors")
          return { bg = colors.night.bg }
        end,
      }

      sources.diff = {
        "diff",
        symbols = {
          added = fmt("Add", ""),
          modified = fmt("Modified", ""),
          removed = fmt("Removed", ""),
        },
        color = function()
          local colors = require("tokyonight.colors")
          return { bg = colors.night.bg }
        end,
      }

      sources.filetype = { "filetype" }

      sources.diagnostics = {
        "diagnostics",
        color = function()
          local colors = require("tokyonight.colors")
          return { bg = colors.night.bg }
        end,
      }

      sources.encoding = {
        "encoding",
        color = function()
          local colors = require("tokyonight.colors")
          return { fg = colors.default.blue, bg = colors.night.bg }
        end,
      }

      sources.fileformat = {
        "fileformat",
        color = function()
          local colors = require("tokyonight.colors")
          return { fg = colors.default.blue, bg = colors.night.bg }
        end,
      }

      sources.indentation = {
        "indentation",
        fmt = function()
          local type = vim.bo[0].expandtab and "spaces" or "tabs"
          local value = vim.bo[0].shiftwidth
          return type .. ": " .. value
        end,
        color = function()
          local colors = require("tokyonight.colors")
          return { fg = colors.default.blue, bg = colors.night.bg }
        end,
      }

      sources.progress = {
        "progress",
        fmt = function(location) return vim.trim(location) end,
        color = function()
          local colors = require("tokyonight.colors")
          return { fg = colors.default.purple, bg = colors.night.bg }
        end,
      }

      sources.location = {
        "location",
        fmt = function(location) return vim.trim(location) end,
        color = function()
          local colors = require("tokyonight.colors")
          return { fg = colors.default.purple, bg = colors.night.bg }
        end,
      }

      sources.macro = {
        function() return vim.fn.reg_recording() end,
        icon = icons.Recording,
        color = function()
          local colors = require("tokyonight.colors")
          return { fg = colors.default.red }
        end,
      }

      sources.lsp = {
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          if next(clients) == nil then return "" end
          local attached_clients = vim.tbl_map(function(client) return client.name end, clients)
          return table.concat(attached_clients, ", ")
        end,
        icon = icons.Braces,
        color = function()
          local colors = require("tokyonight.colors")
          return { fg = colors.default.comment, bg = colors.night.bg }
        end,
      }

      sources.gap = {
        function() return " " end,
        color = function()
          local colors = require("tokyonight.colors")
          return { bg = colors.night.bg }
        end,
        padding = 0,
      }

            local opts = {
              options = {
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
              },
              sections = {
                lualine_a = { sources.mode },
                lualine_b = { sources.branch, sources.diff },
                lualine_c = { sources.filetype, sources.macro },
                lualine_x = { sources.lsp, sources.diagnostics },
                lualine_y = { sources.indentation, sources.encoding, sources.fileformat },
                lualine_z = { sources.progress, sources.location },
              },
            };

            vim.opt.laststatus = 3
            tokyonight.normal.c.bg = colors.night.bg
            opts.options.theme = tokyonight

            require("lualine").setup(opts)
    '';
  };
}
