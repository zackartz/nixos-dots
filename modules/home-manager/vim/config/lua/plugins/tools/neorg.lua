return {
	{ "vhyrro/luarocks.nvim", priority = 1000, config = true },
	{ "nvim-neorg/neorg", dependencies = { "luarocks.nvim" }, lazy = false, version = "*", config = true },
}
