return {
	"jmbuhr/otter.nvim",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	setup = function()
		require("otter").activate({ "python", "rust" }, true, true, nil)
	end,
}
