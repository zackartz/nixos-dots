return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
      news = { lazyvim = false },
    },
  },
  {
    "catppuccin",
    config = function()
      require("catppuccin").setup({
        transparent_background = false,
        integrations = {
          blink_cmp = true,
          nvimtree = true,
        },
        custom_highlights = function(colors)
          return {
            Normal = { bg = colors.crust },
            NormalFloat = { bg = colors.crust },

            -- Completion menu (nvim-cmp)
            Pmenu = { bg = colors.crust },
            PmenuSel = { bg = colors.surface0 },
            CmpItemAbbr = { bg = colors.crust },
            CmpItemAbbrMatch = { bg = colors.crust },

            -- Tabs
            TabLine = { bg = colors.crust },
            TabLineFill = { bg = colors.crust },
            TabLineSel = { bg = colors.crust },

            -- Status line
            StatusLine = { bg = colors.crust },
            StatusLineNC = { bg = colors.crust },

            -- Line numbers
            LineNr = { bg = colors.crust },
            SignColumn = { bg = colors.crust },
          }
        end,
        color_overrides = {
          mocha = {
            base = "#11111b",
            mantle = "#11111b",
            crust = "#11111b",
          },
        },
      })
    end,
  },
  "f-person/git-blame.nvim",
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        javascriptreact = { "prettierd" },
        javascript = { "prettierd" },
        htmlangular = { "prettierd" },
        python = { "black" },
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        jinja_lsp = {},
        emmet_ls = {
          filetypes = { "html", "jinja" },
        },
        somesass_ls = {},
        slangd = {
          settings = {
            slangd = {
              inlayHints = {
                deducedTypes = true,
                paramaterNames = true,
              },
            },
          },
        },
        nil_ls = {
          settings = {
            ["nil"] = {
              nix = {
                flake = {
                  autoEvalInputs = true,
                  nixpkgsInputName = "nixpkgs",
                  autoArchive = true,
                },
                maxMemoryMB = 4096,
              },
              formatting = {
                command = { "nixfmt" },
              },
            },
          },
        },
      },
    },
  },
  -- lua with lazy.nvim
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "jake-stewart/force-cul.nvim",
    config = function()
      require("force-cul").setup()
    end,
  },
}
