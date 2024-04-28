local M = {}

local make_config = function(name, config)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.colorProvider = { dynamicRegistration = true }
	local extended_config = vim.tbl_extend("error", { capabilities = capabilities }, config)

	return function()
		require("lspconfig")[name].setup(config)
	end
end

-- Default handler
-- M[1] = function(server_name)
-- make_config(server_name, {})()
-- end

M.lua_ls = make_config("lua_ls", {
	settings = {
		Lua = {
			hint = {
				enable = true,
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

M.nil_ls = make_config("nixd", {})

M.cssls = make_config("cssls", {
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
})

-- M.tailwindcss = make_config("tailwindcss", {
-- on_attach = function()
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	require("document-color").buf_attach(bufnr)
-- end,
-- })

M.clangd = make_config("clangd", {
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
	},
})

M.tsserver = make_config("tsserver", {})

return M
