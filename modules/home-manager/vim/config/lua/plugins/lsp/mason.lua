local icons = require("utils.icons").icons

return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  opts = {
    ui = {
      border = "rounded",
      icons = {
        package_installed = icons.Check,
        package_pending = icons.Dots,
        package_uninstalled = icons.Install,
      },
    },
  },
}
