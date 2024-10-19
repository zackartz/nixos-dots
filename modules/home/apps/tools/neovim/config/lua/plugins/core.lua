return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets/",
      })
    end,
  },
  "direnv/direnv.vim",
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
        typescript = { "prettierd" },
        javascript = { "prettierd" },
      },
    },
  },
  { "hrsh7th/nvim-cmp", enabled = false },
  {
    "jake-stewart/force-cul.nvim",
    config = function()
      require("force-cul").setup()
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",

    build = "cargo build --release",

    opts = {
      keymap = {
        show = "<C-S-space>",
        accept = "<Enter>",
        select_prev = { "<S-Tab>", "<C-j>", "<C-p>" },
        select_next = { "<C-Tab>", "<C-k>", "<C-n>" },

        snippet_forward = "<Tab>",
        snippet_backward = "<C-S-Tab>",
      },

      windows = {
        documentation = {
          auto_show = true,
        },
      },

      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }

      -- experimental signature help support
      -- trigger = { signature_help = { enabled = true } }
    },
  },
}
