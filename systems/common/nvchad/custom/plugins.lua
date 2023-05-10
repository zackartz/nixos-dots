local overrides = require "custom.configs.overrides"

local utils = require "core.utils"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  {
    "folke/noice.nvim",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },
    enabled = false,
    config = function()
      require("noice").setup {
        cmdline = {
          format = {
            cmdline = {
              pattern = "^:",
              icon = " ",
              lang = "vim",
            },
            search_down = {
              kind = "search",
              pattern = "^/",
              icon = " ",
              lang = "regex",
            },
            search_up = {
              kind = "search",
              pattern = "^/",
              icon = " ",
              lang = "regex",
            },
            filter = {
              pattern = "^:%s*!",
              icon = "$",
              lang = "bash",
            },
            lua = {
              pattern = "^:%s*lua%s+",
              icon = "",
              lang = "lua",
            },
            help = { pattern = "^:%s*h%s+", icon = "" },
            input = {},
          },
        },
        popupmenu = {
          backend = "cmp",
        },
        views = {
          cmdline_popup = {
            position = {
              row = 0,
              col = "50%",
            },
            size = {
              width = "98%",
            },
            border = {
              style = "none",
              padding = { 1, 2 },
            },
            filter_options = {},
            win_options = {
              winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            },
          },
        },
      }
    end,
    lazy = false,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        auto_refresh = true,
        suggestion = { enabled = false, auto_trigger = true },
        panel = { enabled = false },
        filetypes = {
          rust = true,
        },
      }
    end,
    lazy = false,
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    opts = {
      sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
    lazy = false,
  },

  { "nvim-treesitter/nvim-treesitter-context", lazy = false },

  {
    "simrat39/rust-tools.nvim",
    config = function()
      local rt = require "rust-tools"

      -- Update this path
      local extension_path = vim.env.HOME .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.9.0-universal/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.so" -- MacOS: This may be .dylib

      rt.setup {
        hover_actions = {
          auto_focus = true,
        },
        server = {
          on_attach = function(_, bufnr)
            utils.load_mappings("lspconfig", { buffer = bufnr })
          end,
        },

        -- debugging stuff
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
      rt.inlay_hints.enable()
    end,
    lazy = false,
  },

  {
    "saecki/crates.nvim",
    tag = "v0.3.0",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
    lazy = false,
  },

  { "nvim-lua/plenary.nvim", lazy = false },
  "folke/neodev.nvim",
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function()
      local dap = require "dap"

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          -- CHANGE THIS to your path!
          command = "/home/zack/.vscode-oss/extensions/vadimcn.vscode-lldb-1.9.0-universal/adapter/codelldb",
          args = { "--port", "${port}" },

          -- On windows you may have to uncomment this:
          -- detached = false,
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      -- dap.configurations.rust = {
      --   {
      --     name = "Launch file",
      --     type = "codelldb",
      --     request = "launch",
      --     program = function()
      --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/", "file")
      --     end,
      --     cwd = "${workspaceFolder}",
      --     stopOnEntry = false,
      --   },
      -- }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "html-lsp",
        "prettier",
        "stylua",
        "rust-analyzer",
        "rustfmt",
        "typescript-language-server",
        "gopls",
        "goimports",
        "css-lsp",
      },
    },
    enable = false,
  },

  -- overrde plugin configs
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- To make a plugin not be loaded
  {
    "NvChad/nvim-colorizer.lua",
    enabled = false,
  },

  -- Uncomment if you want to re-enable which-key
  {
    "folke/which-key.nvim",
    enabled = true,
  },
}

return plugins
