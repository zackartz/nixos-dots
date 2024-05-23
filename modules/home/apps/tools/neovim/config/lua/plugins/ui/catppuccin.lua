return {
	"catppuccin/nvim",
	name = "catppuccin",
	init = function()
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
	opts = {
		transparent_background = true,
		custom_highlights = function(colors)
			return {
				Pmenu = { bg = colors.base },
			}
		end,
		flavor = "mocha",
		integrations = {
			cmp = true,
			noice = true,
			treesitter = true,
			neotree = true,
			overseer = true,
			notify = true,
			telescope = {
				enabled = true,
				style = "nvchad",
			},
			which_key = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
		},
	},
	priority = 1000,
}