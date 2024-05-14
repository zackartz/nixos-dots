local map = require("utils.mappings")
local lsp = require("lsp.functions")
local l, cmd = map.leader, map.cmd
local fmt = require("utils.icons").fmt

return {
	["textDocument/formatting"] = {
		[l("lf")] = { lsp.format, fmt("Format", "Format buffer") },
	},
	["textDocument/publishDiagnostics"] = {
		[l("ld")] = { lsp.diagnostics, fmt("Warn", "Hover diagnostic") },
		["<A-i>"] = { lsp.next_diagnostic, "Next diagnostic" },
		["<A-o>"] = { lsp.prev_diagnostic, "Previous diagnostic" },
	},
	["textDocument/codeAction"] = {
		[l("a ")] = { cmd("CodeActionToggleLabel"), fmt("Toggle", "Toggle label") },
	},
	["textDocument/definition"] = {
		["gd"] = { lsp.definitions, "Go to definition" },
	},
	["textDocument/declaration"] = {
		["gD"] = { lsp.declarations, "Go to declaration" },
	},
	["textDocument/hover"] = {
		["K"] = { lsp.hover, "Hover info" },
	},
	["textDocument/implementation"] = {
		["gI"] = { lsp.implementations, "Symbol implementation" },
	},
	["textDocument/references"] = {
		["gr"] = { lsp.references, "Go to reference" },
	},
	["textDocument/rename"] = {
		["<leader>lr"] = { lsp.rename, fmt("Edit", "Rename symbol") },
	},
	["textDocument/signatureHelp"] = {
		["<leader>lH"] = { lsp.signature_help, fmt("Help", "Signature help") },
	},
	["textDocument/typeDefinition"] = {
		["gT"] = { lsp.type_definition, "Go to type definition" },
	},
	-- ["textDocument/codeLens"] = {
	-- 	["<leader>ll"] = { lsp.run_codelens, fmt("Run", "Run codelens") },
	-- 	["<leader>lL"] = { lsp.refresh_codelens, fmt("Restart", "Refresh codelens") },
	-- },
	["workspace/symbol"] = {
		["<leader>ls"] = { lsp.symbols, fmt("Symbol", "Workspace symbols") },
	},
	["workspace/inlayHint"] = {
		["<leader>lh"] = { lsp.toggle_inlay_hint, fmt("Toggle", "Toggle inlay hint") },
	},
}
