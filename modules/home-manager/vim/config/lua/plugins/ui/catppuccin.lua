return {
	"catppuccin/nvim",
	name = "catppuccin",
	init = function()
		vim.cmd.colorscheme("catppuccin")
	end,
	opts = {
		transparent_background = true,
		integrations = {
			cmp = true,
			noice = true,
			treesitter = true,
			neotree = true,
		},
	},
	priority = 1000,
}
