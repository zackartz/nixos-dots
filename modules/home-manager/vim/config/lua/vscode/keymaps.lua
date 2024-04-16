local map = require("utils.mappings")
local l, cmd, rcmd, notify = map.leader, map.cmd, map.rcmd, map.notify

return {
	n = {
		-- utils
		[l("p")] = { '"+p' },
		[l("P")] = { '"+P' },
		[l(":")] = { ":lua " },

		[l("us")] = { cmd("nohlsearch") },
		[l(";")] = { cmd("VSCodeCommentary") },

		-- vscode actions
		[l("w")] = { notify("workbench.action.files.save") },
		[l("e")] = { notify("workbench.view.explorer") },
		[l("bq")] = { notify("workbench.action.closeActiveEditor") },
		[l("bn")] = { notify("workbench.action.nextEditorInGroup") },
		[l("bp")] = { notify("workbench.action.previousEditorInGroup") },
		[l("um")] = { notify("editor.action.toggleMinimap") },
		[l("ff")] = { notify("workbench.action.quickOpen") },
		[l("fs")] = { notify("workbench.action.gotoSymbol") },
		[l("nn")] = { notify("notifications.clearAll") },
		[l("nl")] = { notify("notifications.showList") },

		["gr"] = { notify("editor.action.goToReferences") },
		[l("lr")] = { notify("editor.action.rename") },

		-- move.nvim
		["<A-j>"] = { cmd("MoveLine(1)") },
		["<A-k>"] = { cmd("MoveLine(-1)") },
		["<A-h>"] = { cmd("MoveHChar(-1)") },
		["<A-l>"] = { cmd("MoveHChar(1)") },
	},
	v = {
		-- utils
		["q"] = { "<esc>" },
		[l("y")] = { '"+y' },
		[l("p")] = { '"+p' },
		[l("P")] = { '"+P' },

		[l(";")] = { cmd("VSCodeCommentary") },

		-- move.nvim
		["<A-j>"] = { rcmd("MoveBlock(1)") },
		["<A-k>"] = { rcmd("MoveBlock(-1)") },
		["<A-h>"] = { rcmd("MoveHBlock(-1)") },
		["<A-l>"] = { rcmd("MoveHBlock(1)") },
	},
}
