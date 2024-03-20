return {
  { "folke/neodev.nvim", ft = "lua", opts = {} },
  {
    "b0o/schemastore.nvim",
    ft = "json",
    config = function()
      require("lspconfig").jsonls.setup({
        capabilities = require("lsp.capabilities"),
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
{
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  ft = { 'rust' },
}
}
