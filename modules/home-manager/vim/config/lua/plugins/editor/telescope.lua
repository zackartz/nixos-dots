local format = require("utils.icons").fmt

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    opts = {
      defaults = {
        border = true,
        prompt_prefix = " ",
        selection_caret = format("Right", ""),
      },
      extensions = {
        fzf = {},
        aerial = {},
        dap = {},
      },
    },
  },
}
