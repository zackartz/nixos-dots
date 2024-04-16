local format = require("utils.icons").fmt

return {
	{
		"psliwka/vim-smoothie",
		keys = { "<C-u>", "<C-d>", "zz" },
	},

	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		keys = {
			{ "gcc", mode = { "n" }, desc = "Comment line" },
			{ "gc", mode = { "v" }, desc = "Comment selection" },
		},
		config = function()
			local ft = require("Comment.ft")

			ft.hypr = { "# %s" }

			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	{
		"NMAC427/guess-indent.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			autocmd = true,
		},
	},

	{
		"ojroques/nvim-bufdel",
		cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
		opts = { quit = false },
	},

	{
		"fedepujol/move.nvim",
		cmd = {
			"MoveLine",
			"MoveHChar",
			"MoveBlock",
			"MoveHBlock",
		},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"kylechui/nvim-surround",
		keys = {
			{ "cs", mode = { "n" }, desc = "Change surrounding pair" },
			{ "ds", mode = { "n" }, desc = "Delete surrounding pair" },
			{ "ys", mode = { "n" }, desc = "Add surrounding pair" },
			{ "S", mode = { "v" }, desc = "Add surrounding pair" },
		},
		config = function()
			require("nvim-surround").setup()
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("illuminate").configure({
				filetypes_denylist = {
					"neo-tree",
					"dropbar_menu",
					"CodeAction",
				},
			})
		end,
	},

	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{ "<leader>j", mode = { "n" }, ":TSJSplit<CR>", desc = format("Down", "Split node") },
			{ "<leader>J", mode = { "n" }, ":TSJJoin<CR>", desc = format("Up", "Join node") },
		},
		opts = {
			use_default_keymaps = false,
		},
	},
}
