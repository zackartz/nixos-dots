return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<leader>d", mode = { "n" } },
  },
  cmd = { "DapContinue", "DapToggleBreakpoint" },
  dependencies = {
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "nvim-dap" },
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        handlers = {},
        ensure_installed = {
          "codelldb",
          "node-debug2-adapter",
        },
      },
    },
    { "rcarriga/nvim-dap-ui", opts = {} },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        virt_text_pos = "eol",
      },
    },
  },
}
