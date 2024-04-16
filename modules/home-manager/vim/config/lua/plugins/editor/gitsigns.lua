return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { hl = "GitSignsAdd", text = "▎" },
			change = { hl = "GitSignsChange", text = "▎" },
			untracked = { hl = "GitSignsAdd", text = "▎" },
			delete = { hl = "GitSignsDelete", text = "▎" },
			topdelete = { hl = "GitSignsDelete", text = "▎" },
			changedelete = { hl = "GitSignsChange", text = "▎" },
		},
		preview_config = {
			border = "none",
		},
	},
}
