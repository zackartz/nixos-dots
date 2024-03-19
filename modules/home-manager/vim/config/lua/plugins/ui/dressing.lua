return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  config = function()
    local theme = require("telescope.themes").get_dropdown()

    theme.layout_config = {
      width = 60,
      height = 17,
    }

    require("dressing").setup({
      input = {
        enabled = false,
      },
      select = {
        backend = { "telescope" },
        telescope = theme,
      },
    })
  end,
}
