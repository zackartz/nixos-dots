return {
	"isabelroses/charm-freeze.nvim",
	config = function()
		require("charm-freeze").setup({
			command = "freeze",
			output = function()
				return "./" .. os.date("%Y-%m-%d") .. "_freeze.png"
			end,
			theme = "catppuccin-mocha",
		})
	end,
}
