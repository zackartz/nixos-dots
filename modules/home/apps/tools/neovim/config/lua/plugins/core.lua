return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      news = { lazyvim = false },
    },
  },
  "f-person/git-blame.nvim",
  {
    "3rd/image.nvim",
    build = false,
    lazy = false,
    config = function()
      require("image").setup({
        backend = "kitty",
        kitty_method = "normal",
        processor = "magick_cli",
        integrations = {
          markdown = {
            enabled = true,
          },
        },
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    lazy = true,
    opts = function()
      local logo = ""
      logo = string.rep("\n", 12) .. logo .. "\n\n"
      local opts = {
        theme = "hyper",
        hide = {
          statusline = true,
        },
        config = {
          header = vim.split(logo, "\n"),
          shortcut = {
            {
              desc = "Find File",
              action = "lua LazyVim.pick()()",
              key = "f",
            },
            {
              desc = "New File",
              action = "ene | startinsert",
              key = "n",
            },
            {
              desc = "Lazy",
              action = "Lazy",
              icon = "󰒲 ",
              key = "l",
            },
            {
              desc = "Quit",
              action = function()
                vim.api.nvim_input("<cmd>qa<cr>")
              end,
              key = "q",
            },
          },
          packages = { enable = true }, -- show how many plugins neovim loaded
          project = { enable = true, limit = 8 },
          mru = { limit = 10 },
        },
      }

      -- Handle reopening dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
  { "nvim-lualine/lualine.nvim", enabled = false },
  -- {
  --   "nvim-neorg/neorg",
  --   lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  --   version = "*", -- Pin Neorg to the latest stable release
  --   config = true,
  --   opts = {
  --     load = {
  --       ["core.defaults"] = {},
  --       ["core.concealer"] = {},
  --     },
  --   },
  -- },
  { "echasnovski/mini.statusline", opts = {} },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        javascriptreact = { "prettierd" },
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
