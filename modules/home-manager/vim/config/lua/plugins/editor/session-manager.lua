return {
	"Shatur/neovim-session-manager",
	cmd = { "SessionManager" },
	config = function()
		local config = require("session_manager.config")
		require("session_manager").setup({
			autoload_mode = config.AutoloadMode.Disabled,
		})
	end,
}
