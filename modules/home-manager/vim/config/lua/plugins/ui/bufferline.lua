local format = require("utils.icons").fmt

return {
	"akinsho/bufferline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = "nvim-tree/nvim-web-devicons",
	after = "catppuccin",
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			diagnostics_update_in_insert = true,
			diagnostics_indicator = nil,
			indicator = "none",
			offsets = {
				{
					filetype = "neo-tree",
					text = format("Folder", "NeoTree"),
					text_align = "left",
					separator = "│",
				},
				{
					filetype = "dapui_watches",
					text = format("Debugger", "DapUI"),
					text_align = "left",
					separator = "│",
				},
				{
					filetype = "dbui",
					text = format("Database", "DbUI"),
					text_align = "left",
					separator = "│",
				},
			},
		},
	},
	config = function(_, opts)
		-- local colors = require("tokyonight.colors")
		--
		-- vim.opt.showtabline = 2
		-- opts.highlights = {
		-- 	background = { bg = colors.night.bg },
		-- 	close_button = { bg = colors.night.bg },
		-- 	separator = { fg = colors.night.bg, bg = colors.night.bg },
		-- 	offset_separator = { bg = colors.night.bg },
		-- 	pick = { bg = colors.night.bg },
		-- }

		local mocha = require("catppuccin.palettes").get_palette("mocha")

		opts = {
			highlights = require("catppuccin.groups.integrations.bufferline").get({
				styles = { "italic", "bold" },
				custom = {
					all = {
						fill = { bg = "#000000" },
					},
					mocha = {
						background = { fg = mocha.text },
					},
					latte = {
						background = { fg = mocha.base },
					},
				},
			}),
		}

		require("bufferline").setup(opts)
	end,
}
