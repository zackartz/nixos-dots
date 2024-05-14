local filetypes = require("core.filetypes")
local configurer = require("utils.configurer")
local opts = {}

package.path = package.path
	.. ";"
	.. "/nix/store/cga26ykqb57jyiws6wvrsmw9xrqf7555-lua5.1-lua-curl-0.3.13-1/share/lua/5.1/?.lua"
	.. "/nix/store/cga26ykqb57jyiws6wvrsmw9xrqf7555-lua5.1-lua-curl-0.3.13-1/share/lua/5.1/?/?.lua"

package.cpath = package.cpath
	.. ";"
	.. "/nix/store/cga26ykqb57jyiws6wvrsmw9xrqf7555-lua5.1-lua-curl-0.3.13-1/lib/lua/5.1/lcurl.so"

if vim.g.vscode then
	-- VSCode Neovim
	opts.spec = "vscode.plugins"
	opts.options = require("vscode.options")
	opts.keymaps = require("vscode.keymaps")
else
	-- Normal Neovim
	opts.spec = "plugins"
	opts.options = require("core.options")
	opts.keymaps = require("core.keymaps")
	opts.autocmd = require("core.autocmd")
	opts.signs = require("core.signs")
end

configurer.setup(opts)

local handlers = require("lsp.handlers") -- Adjust the path as necessary

local function setup_all_servers()
	for server, setup_fn in pairs(handlers) do
		if type(setup_fn) == "function" then
			-- Call the setup function for each server
			setup_fn()
		end
	end
end

setup_all_servers()

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("i", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("i", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("i", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("i", "<down>", '<cmd>echo "Use j to move!!"<CR>')
-- Neovide config
vim.o.guifont = "Iosevka Nerd Font Mono:h14"
vim.g.neovide_transparency = 0.75

-- vim.lsp.log.set_level(vim.lsp.log_levels.INFO)
vim.filetype.add(filetypes)
