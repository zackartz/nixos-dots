return {
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		config = function()

			require("rest-nvim").setup()
		end,
	},
}
