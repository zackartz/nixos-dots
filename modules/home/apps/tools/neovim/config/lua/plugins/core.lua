return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
      news = { lazyvim = false },
    },
  },
  {
    "drewxs/ash.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "snacks.nvim",
    opts = {
      scroll = {
        enabled = false,
      },
      dashboard = {
        preset = {
          header = [[
          ／l、             
       （ﾟ､ ｡ ７         
      l  ~ヽ       
  じしf_,)ノ
        ]],
        },
      },
    },
  },
  -- {
  --   "uZer/pywal16.nvim",
  --   -- for local dev replace with:
  --   -- dir = '~/your/path/pywal16.nvim',
  --   config = function()
  --     vim.cmd.colorscheme("pywal16")
  --   end,
  -- },
  {
    "catppuccin",
    opts = {
      transparent_background = true,
      integrations = {
        blink_cmp = true,
      },
      -- color_overrides = {
      --   mocha = {
      --     base = "#000000",
      --     mantle = "#000000",
      --     crust = "#000000",
      --   },
      -- },
    },
  },
  "f-person/git-blame.nvim",
  { "nvim-lualine/lualine.nvim", enabled = false },
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
        htmlangular = { "prettierd" },
        python = { "black" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
    },
  },
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
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        emmet_ls = {},
        slang = {
          inlayHints = {
            deducedTypes = true,
            paramaterNames = true,
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
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup({})
  --   end,
  -- },
}
