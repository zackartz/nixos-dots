local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- go
  b.diagnostics.golangci_lint,
  -- b.diagnostics.gospel,
  b.diagnostics.staticcheck,
  b.formatting.gofumpt,
  b.formatting.goimports,

  -- cpp
  b.formatting.clang_format,
  b.formatting.rustfmt,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
