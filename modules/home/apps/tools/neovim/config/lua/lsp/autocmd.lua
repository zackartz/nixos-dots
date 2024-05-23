local lsp = require("lsp.functions")

return {
	-- ["textDocument/codeLens"] = {
	-- 	event = { "BufEnter", "InsertLeave" },
	-- 	opts = {
	-- 		group = vim.api.nvim_create_augroup("LspCodelens", {}),
	-- 		callback = lsp.refresh_codelens,
	-- 	},
	-- },
	["textDocument/formatting"] = {
		event = "BufWritePost",
		opts = {
			group = vim.api.nvim_create_augroup("LspFormatting", {}),
			callback = lsp.format,
		},
	},
}
