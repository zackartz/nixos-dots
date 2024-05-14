return {
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		config = function()
			package.path = package.path
				.. ";"
				.. "/nix/store/cga26ykqb57jyiws6wvrsmw9xrqf7555-lua5.1-lua-curl-0.3.13-1/share/lua/5.1/?.lua"

			package.cpath = package.cpath
				.. ";"
				.. "/nix/store/cga26ykqb57jyiws6wvrsmw9xrqf7555-lua5.1-lua-curl-0.3.13-1/lib/lua/5.1/?.so"

			require("rest-nvim").setup()
		end,
	},
}
