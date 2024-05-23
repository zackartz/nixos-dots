local format = require("utils.icons").fmt

return {
	"luckasRanarison/clear-action.nvim",
	event = "LspAttach",
	opts = {
		signs = {
			show_count = false,
			show_label = true,
			combine = true,
		},
		popup = {
			hide_cursor = true,
		},
		mappings = {
			code_action = { "<leader>la", format("Fix", "Code action") },
			apply_first = { "<leader>aa", format("Fix", "Apply") },
			quickfix = { "<leader>aq", format("Fix", "Quickfix") },
			quickfix_next = { "<leader>an", format("Fix", "Quickfix next") },
			quickfix_prev = { "<leader>ap", format("Fix", "Quickfix prev") },
			refactor = { "<leader>ar", format("Fix", "Refactor") },
			refactor_inline = { "<leader>aR", format("Fix", "Refactor inline") },
			actions = {
				["rust_analyzer"] = {
					["Import"] = { "<leader>ai", format("Fix", "Import") },
					["Replace if"] = { "<leader>am", format("Fix", "Replace if with match") },
					["Fill match"] = { "<leader>af", format("Fix", "Fill match arms") },
					["Wrap"] = { "<leader>aw", format("Fix", "Wrap") },
					["Insert `mod"] = { "<leader>aM", format("Fix", "Insert mod") },
					["Insert `pub"] = { "<leader>aP", format("Fix", "Insert pub mod") },
					["Add braces"] = { "<leader>ab", format("Fix", "Add braces") },
				},
			},
		},
		quickfix_filters = {
			["rust_analyzer"] = {
				["E0412"] = "Import",
				["E0425"] = "Import",
				["E0433"] = "Import",
				["unused_imports"] = "remove",
			},
		},
	},
}
