return {
  "sethen/line-number-change-mode.nvim",
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
    })
    local palette = require("catppuccin.palettes").get_palette("mocha")

    if palette == nil then
      return nil
    end

    require("line-number-change-mode").setup({
      mode = {
        i = {
          bg = palette.green,
          fg = palette.mantle,
          bold = true,
        },
        n = {
          bg = palette.blue,
          fg = palette.mantle,
          bold = true,
        },
        R = {
          bg = palette.maroon,
          fg = palette.mantle,
          bold = true,
        },
        v = {
          bg = palette.mauve,
          fg = palette.mantle,
          bold = true,
        },
        V = {
          bg = palette.mauve,
          fg = palette.mantle,
          bold = true,
        },
      },
    })
  end,
}
