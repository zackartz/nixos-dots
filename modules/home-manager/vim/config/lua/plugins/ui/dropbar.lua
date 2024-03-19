return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufRead", "BufNewFile" },
    opts = {
      icons = {
        enable = true,
        kinds = {
          use_devicons = false,
          symbols = {
            File = "",
            Folder = "",
          },
        },
      },
    },
  },
}
