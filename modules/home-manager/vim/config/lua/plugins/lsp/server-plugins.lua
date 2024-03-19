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
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("rust-tools").setup({
        tools = {
          inlay_hints = {
            auto = false,
          },
        },
        server = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
              },
              checkOnSave = {
                features = "all",
              },
            },
          },
        },
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(
            "/home/luckas/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
            "/home/luckas/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
          ),
        },
      })
    end,
  },
}
