return {
	"isabelroses/charm-freeze.nvim",
	config = function()
		require("charm-freeze").setup({
			command = "freeze",
			output = function()
				return "./" .. os.date("%Y-%m-%d") .. "_freeze.png"
			end,
			line_numbers = true,
			font = {
				family = "Iosevka",
			},
			theme = "catppuccin-mocha",
		})
	end,
}
