function confirm(opts)
  local cmp = require("blink.cmp")
  opts = vim.tbl_extend("force", { select = true }, opts or {})
  return function(fallback) end
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  { "nvim-lualine/lualine.nvim", enabled = false },
  { "echasnovski/mini.statusline", opts = {} },
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
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    tag = "v3.8.2",
    ---@module "ibl"
    ---@type ibl.config
    -- opts = {
    --   debounce = 100,
    --   indent = { char = "|" },
    --   whitespace = { highlight = "Whitespace", "NonText" },
    -- },
  },
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
    dependencies = { "rafamadriz/friendly-snippets", "saghen/blink.compat" },

    build = "cargo build --release",

    sources = {
      completion = {
        enabled_providers = { "lsp", "path", "snippets", "buffer", "dadbod", "crates" },
      },

      providers = {
        dadbod = {
          name = "vim-dadbod-completion",
          module = "blink.compat",
          opts = {},
        },
        crates = {
          name = "crates",
          module = "blink.compat",
          opts = {},
        },
      },
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = {
          function(cmp)
            if cmp.is_in_snippet() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
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
