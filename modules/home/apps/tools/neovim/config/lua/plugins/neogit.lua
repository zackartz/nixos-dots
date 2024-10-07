return {
  "NeogitOrg/neogit",
  cmd = { "Neogit" },
  keys = {
    { "<leader>ng", "<cmd>Neogit<cr>", desc = "Open Neogit" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = true,
}
