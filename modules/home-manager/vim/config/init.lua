local filetypes = require("core.filetypes")
local configurer = require("utils.configurer")
local opts = {}

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

-- Neovide config
vim.o.guifont = "Iosevka Nerd Font Mono:h14"
vim.g.neovide_transparency = 0.75

-- vim.lsp.log.set_level(vim.lsp.log_levels.INFO)
vim.filetype.add(filetypes)
