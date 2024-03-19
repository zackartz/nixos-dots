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
      "html",
      "cssls",
      "emmet_ls",
      "tailwindcss",
      "clangd",
      "vimls",
      "jsonls",
      "taplo",
      "jdtls",
    },
  },
}
