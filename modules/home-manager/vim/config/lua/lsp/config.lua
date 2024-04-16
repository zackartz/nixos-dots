local M = {}

M.set_autocmd = function(client, bufnr)
	local capability_map = require("lsp.autocmd")

	for capability, map in pairs(capability_map) do
		if client.supports_method(capability) then
			vim.api.nvim_clear_autocmds({ group = map.opts.group, buffer = bufnr })
			map.opts.buffer = bufnr
			vim.api.nvim_create_autocmd(map.event, map.opts)
		end
	end
end

M.set_keymaps = function(client, bufnr)
	local capability_map = require("lsp.keymaps")

	for capability, maps in pairs(capability_map) do
		if client.supports_method(capability) then
			for key, map in pairs(maps) do
				vim.keymap.set("n", key, map[1], { desc = map[2], buffer = bufnr })
			end
		end
	end
end

require("lspconfig").tsserver.setup({})
local handlers = require("lsp.handlers") -- Adjust the path as necessary

local function setup_all_servers()
	for server, setup_fn in pairs(handlers) do
		if type(setup_fn) == "function" then
			-- Call the setup function for each server
			setup_fn()
			print("Setup LSP server:", server) -- Optional: for debugging
		end
	end
end

setup_all_servers()

return M
