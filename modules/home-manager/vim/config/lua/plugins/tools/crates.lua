return {
	"saecki/crates.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jose-elias-alvarez/null-ls.nvim",
	},
	event = { "BufRead Cargo.toml" },
	opts = {
		null_ls = {
			enabled = true,
			name = "Crates",
		},
	},
}
