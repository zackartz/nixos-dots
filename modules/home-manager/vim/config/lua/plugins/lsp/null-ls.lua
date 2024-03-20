return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      debug = false,
      sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.rustfmt.with({
          extra_args = { "--edition=2021" },
        }),
        null_ls.builtins.formatting.shfmt.with({
          filetypes = { "sh", "zsh" },
          extra_args = { "--indent-type Spaces" },
        }),
        null_ls.builtins.formatting.clang_format.with({
          extra_args = { "-style={IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}" },
        }),
      },
    })
  end,
}
