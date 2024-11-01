return {
  "oysandvik94/curl.nvim",
  cmd = { "CurlOpen" },
  keys = {
    { "<leader>C", "<cmd>CurlOpen<cr>", desc = "Open Curl" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
}
