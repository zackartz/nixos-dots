return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
      news = { lazyvim = false },
    },
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
  {
    "catppuccin",
    opts = { integrations = {
      blink_cmp = true,
    } },
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
