return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "rust",
        "go",
        "javascript",
        "typescript",
      },
    },
  },

  {
    "oysandvik94/curl.nvim",
    cmd = { "CurlOpen" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>co", "<cmd>CurlOpen<cr>", desc = "Open Curl" },
    },
    config = function()
      local curl = require "curl"
      curl.setup {}

      vim.keymap.set("n", "<leader>co", function()
        curl.open_global_tab()
      end, { desc = "Open a curl tab with gloabl scope" })

      -- These commands will prompt you for a name for your collection
      vim.keymap.set("n", "<leader>csc", function()
        curl.create_scoped_collection()
      end, { desc = "Create or open a collection with a name from user input" })

      vim.keymap.set("n", "<leader>cgc", function()
        curl.create_global_collection()
      end, { desc = "Create or open a global collection with a name from user input" })

      vim.keymap.set("n", "<leader>fsc", function()
        curl.pick_scoped_collection()
      end, { desc = "Choose a scoped collection and open it" })

      vim.keymap.set("n", "<leader>fgc", function()
        curl.pick_global_collection()
      end, { desc = "Choose a global collection and open it" })
    end,
  },
  {
    "saecki/crates.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    event = { "BufRead Cargo.toml" },
    opts = {
      null_ls = {
        enabled = true,
        name = "Crates",
      },
    },
  },
  { "laytan/cloak.nvim", lazy = false, opts = { cloak_length = 64 } },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = {
      keymaps = {
        toggle = "<leader>dd", -- default '<leader>dd'
        go_to_definition = "<leader>dx", -- default '<leader>dx'
      },
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = {
      "DBUI",
      "DBUIAddConnection",
      "DBUIClose",
      "DBUIToggle",
      "DBUIFindBuffer",
      "DBUIRenameBuffer",
      "DBUILastQueryInfo",
    },
    config = function()
      vim.g.db_ui_notification_width = 1
      vim.g.db_ui_debug = 1

      local cmp = require "cmp"

      cmp.setup.filetype({ "sql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "NeogitOrg/neogit",
    branch = "master",
    cmd = { "Neogit" },
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
  },
}
