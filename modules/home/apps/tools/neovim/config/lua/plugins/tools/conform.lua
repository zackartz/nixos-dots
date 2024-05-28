return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd", "rustywind" },
			typescriptreact = { "prettierd", "rustywind" },
			svelte = { "prettierd", "rustywind" },
			astro = { "prettier", "rustywind" },
			css = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			graphql = { "prettierd" },
			lua = { "stylua" },
			python = { "black" },
			nix = { "alejandra" },
		},
		format_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 500,
		},
	},
}
