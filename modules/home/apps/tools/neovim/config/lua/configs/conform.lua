local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt" },
    css = { "prettier" },
    html = { "prettier" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    nix = { "alejandra" }
  },

  format_on_save = {
    --   -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
