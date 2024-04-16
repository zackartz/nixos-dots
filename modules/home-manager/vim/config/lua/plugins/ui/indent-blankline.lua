return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {
		exclude = {
			buftypes = {
				"nofile",
				"terminal",
			},
			filetypes = {
				"help",
				"startify",
				"aerial",
				"alpha",
				"dashboard",
				"lazy",
				"neogitstatus",
				"neo-tree",
				"Trouble",
				"dbout",
				"TelescopePrompt",
			},
		},
		scope = {
			show_start = false,
			show_end = false,
			highlight = { "@keyword" },
			char = "▏",
			include = {
				node_type = {
					lua = { "table_constructor" },
				},
			},
		},
		whitespace = {
			remove_blankline_trail = true,
		},
		indent = { char = "▏" },
	},
}
