local icons = require("utils.icons").icons

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"luckasRanarison/neo-rename.nvim",
		},
		cmd = "Neotree",
		opts = {
			enable_git_status = true,
			close_if_last_window = true,
			auto_clean_after_session_restore = true,
			window = {
				width = 30,
				mappings = {
					["<space>"] = false,
					["s"] = false,
					["l"] = "open",
					["v"] = "open_vsplit",
					["gA"] = "git_add_all",
					["ga"] = "git_add_file",
					["gu"] = "git_unstage_file",
					["gr"] = "git_revert_file",
				},
			},
			filesystem = {
				follow_current_file = { enabled = true },
				hijack_netrw_behavior = "open_current",
				use_libuv_file_watcher = true,
			},
			default_component_configs = {
				icon = {
					folder_empty = icons.EmptyFolder,
					default = icons.DefaultFile,
				},
				indent = {
					padding = 0,
					indent_size = 1,
				},
				modified = {
					symbol = icons.SmallDot,
				},
				name = {
					use_git_status_colors = true,
				},
				git_status = {
					symbols = {
						deleted = "D",
						renamed = "R",
						modified = "M",
						added = "A",
						untracked = "U",
						ignored = "",
						staged = "",
						unstaged = "!",
						conflict = "C",
					},
				},
				diagnostics = {
					symbols = {
						hint = icons.Hint,
						info = icons.Info,
						warn = icons.Warn,
						error = icons.Error,
					},
					highlights = {
						hint = "DiagnosticSignHint",
						info = "DiagnosticSignInfo",
						warn = "DiagnosticSignWarn",
						error = "DiagnosticSignError",
					},
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			require("neo-rename").setup()
		end,
	},
}
