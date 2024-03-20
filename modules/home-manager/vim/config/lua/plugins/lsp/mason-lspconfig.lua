return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    handlers = require("lsp.handlers"),
    ensure_installed = {
      "rust_analyzer",
      "tsserver",
      "lua_ls",
      "bashls",
      "cssls",
      "tailwindcss",
      "jsonls",
    },
  },
}
