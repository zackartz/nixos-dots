local format = require("utils.icons").fmt

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		require("which-key").register({
			{ "<leader>C", group = format("Package", "Crates") },
			{ "<leader>D", group = format("Database", "DbUI") },
			{ "<leader>S", group = format("FolderClock", "Session") },
			{ "<leader>a", group = format("Fix", "Actions") },
			{ "<leader>b", group = format("Windows", "Buffers") },
			{ "<leader>c", group = format("Color", "Color") },
			{ "<leader>d", group = format("Debugger", "Debugger") },
			{ "<leader>f", group = format("Search", "Telescope") },
			{ "<leader>g", group = format("Git", "Git") },
			{ "<leader>l", group = format("Braces", "LSP") },
			{ "<leader>n", group = format("Notification", "Notification") },
			{ "<leader>o", group = format("DropDown", "Dropbar") },
			{ "<leader>r", group = format("Code", "SnipRun") },
			{ "<leader>t", group = format("Terminal", "Terminal") },
			{ "<leader>u", group = format("Windows", "UI") },
			{ "<leader>v", group = format("Book", "DevDocs") },
		})
	end,
	opts = {
		key_labels = {
			["<space>"] = " ",
		},
		icons = {
			group = "",
		},
		window = {
			border = "rounded",
		},
	},
}
