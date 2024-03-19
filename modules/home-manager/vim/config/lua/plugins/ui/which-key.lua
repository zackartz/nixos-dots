local format = require("utils.icons").fmt

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    require("which-key").register({
      a = { name = format("Fix", "Actions") },
      c = { name = format("Color", "Color") },
      b = { name = format("Windows", "Buffers") },
      u = { name = format("Window", "UI") },
      g = { name = format("Git", "Git") },
      t = { name = format("Terminal", "Terminal") },
      f = { name = format("Search", "Telescope") },
      l = { name = format("Braces", "LSP") },
      d = { name = format("Debugger", "Debugger") },
      n = { name = format("Notification", "Notification") },
      S = { name = format("FolderClock", "Session") },
      r = { name = format("Code", "SnipRun") },
      o = { name = format("DropDown", "Dropbar") },
      v = { name = format("Book", "DevDocs") },
      C = { name = format("Package", "Crates") },
      D = { name = format("Database", "DbUI") },
    }, { prefix = "<leader>" })
  end,
  opts = {
    key_labels = {
      ["<space>"] = " ",
    },
    icons = {
      group = "",
    },
    window = {
      border = "rounded",
    },
  },
}
