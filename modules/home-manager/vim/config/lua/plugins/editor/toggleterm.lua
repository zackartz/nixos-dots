return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm" },
  opts = {
    shade_terminals = false,
    direction = "float",
    float_opts = {
      border = "rounded",
      width = 80,
    },
    highlights = {
      FloatBorder = {
        link = "FloatBorder",
      },
    },
  },
}
