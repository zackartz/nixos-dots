return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<leader>d", mode = { "n" } },
  },
  cmd = { "DapContinue", "DapToggleBreakpoint" },
  dependencies = {
    { "rcarriga/nvim-dap-ui", opts = {} },
{ "nvim-neotest/nvim-nio" },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        virt_text_pos = "eol",
      },
    },
  },
}
