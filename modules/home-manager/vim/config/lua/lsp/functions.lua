local M = {}

M.definitions = function() vim.cmd("Telescope lsp_definitions") end
M.type_definition = function() vim.lsp.buf.type_definition() end
M.declarations = function() vim.lsp.buf.declaration() end
M.implementations = function() vim.cmd("Telescope lsp_implementations") end
M.references = function() vim.cmd("Telescope lsp_references") end
M.hover = function() vim.lsp.buf.hover() end
M.rename = function() vim.lsp.buf.rename() end
M.signature_help = function() vim.lsp.buf.signature_help() end
M.symbols = function() vim.cmd("Telescope lsp_workspace_symbols") end
M.refresh_codelens = function() vim.lsp.codelens.refresh() end
M.run_codelens = function() vim.lsp.codelens.run() end
M.toggle_inlay_hint = function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) end

M.diagnostics = function()
  local _, win = vim.diagnostic.open_float()
  if win then
    vim.api.nvim_win_set_config(win, { border = "rounded" })
    vim.wo[win].signcolumn = "yes:1"
  end
end
M.next_diagnostic = function() vim.diagnostic.goto_next() end
M.prev_diagnostic = function() vim.diagnostic.goto_prev() end

M.format = function()
  vim.api.nvim_create_autocmd("TextChanged", {
    group = vim.api.nvim_create_augroup("ApplyFormattingEdit", {}),
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      vim.cmd("silent noautocmd update")
      vim.diagnostic.show()
      vim.api.nvim_del_augroup_by_name("ApplyFormattingEdit")
    end,
  })
  vim.lsp.buf.format({
    async = true,
    filter = function(client) return client.name == "null-ls" end,
  })
end

return M
