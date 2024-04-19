return {
	{ "vhyrro/luarocks.nvim", priority = 1000, config = true },
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								dev = "~/notes",
							},
							default_workspace = "dev",
							index = "index.norg",
						},
					},
					["core.completion"] = {
						config = {
							engine = "nvim-cmp",
						},
					},
					["core.keybinds"] = {},
					["core.ui.calendar"] = {},
					["core.export"] = {},
					["core.looking-glass"] = {},
					["core.qol.toc"] = {},
					["core.qol.todo_items"] = {},
					["core.esupports.hop"] = {},
					["core.esupports.indent"] = {},
					["core.summary"] = {},
				},
			})
		end,
	},
}
