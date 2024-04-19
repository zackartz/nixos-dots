return {
	{ "vhyrro/luarocks.nvim", priority = 1000, config = true },
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup({
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							dev = "~/notes",
						},
						index = "index.norg",
					},
				},
				["core.completion"] = {
					engine = "nvim-cmp",
				},
			})
		end,
	},
}
