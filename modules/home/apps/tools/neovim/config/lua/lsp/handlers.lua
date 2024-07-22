local M = {}

local make_config = function(name, config)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.colorProvider = { dynamicRegistration = true }
	local extended_config = vim.tbl_extend("error", { capabilities = capabilities }, config)

	return function()
		require("lspconfig")[name].setup(extended_config)
	end
end

-- Default handler
-- M[1] = function(server_name)
-- make_config(server_name, {})()
-- end

M.lua_ls = make_config("lua_ls", {
	settings = {
		Lua = {
			hint = {
				enable = true,
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

M.nil_ls = make_config("nixd", {})

M.jdtls = make_config("jdtls", {
	settings = {
		java = {
			signatureHelp = { enabled = true },
			configuration = {
				updateBuildConfiguration = "interactive",
				-- runtimes = {
				--   {
				--     name = "JavaSE-11",
				--     path = "/usr/lib/jvm/java-11-openjdk/",
				--     default = true
				--   },
				--   -- {
				--   --   name = "JavaSE-17",
				--   --   path = "/usr/lib/jvm/java-17-openjdk/",
				--   -- },
				-- },
			},

			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
	},
})

M.cssls = make_config("cssls", {
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
})

M.texlab = make_config("texlab", {})
M.astro = make_config("astro", {})

M.tailwindcss = make_config("tailwindcss", {
	on_attach = function()
		local bufnr = vim.api.nvim_get_current_buf()
		require("document-color").buf_attach(bufnr)
	end,
})

M.clangd = make_config("clangd", {
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
	},
})

M.tsserver = make_config("tsserver", {})

return M
