return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
			"windwp/nvim-autopairs",
		},
		opts = function()
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			local icons = {
				branch = "",
				bullet = "•",
				o_bullet = "○",
				check = "✔",
				d_chev = "∨",
				ellipses = "…",
				file = "╼",
				hamburger = "≡",
				lock = "",
				r_chev = ">",
				ballot_x = " ",
				up_tri = " ",
				info_i = " ",
				--  ballot_x = '✘',
				--  up_tri = '▲',
				--  info_i = '¡',
			}

			local function get_lsp_completion_context(completion, source)
				local ok, source_name = pcall(function()
					return source.source.client.config.name
				end)
				if not ok then
					return nil
				end

				if source_name == "tsserver" then
					return completion.detail
				elseif source_name == "pyright" and completion.labelDetails ~= nil then
					return completion.labelDetails.description
				elseif source_name == "clang_d" then
					local doc = completion.documentation
					if doc == nil then
						return
					end

					local import_str = doc.value

					local i, j = string.find(import_str, '["<].*[">]')
					if i == nil then
						return
					end

					return string.sub(import_str, i, j)
				end
			end

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			local lspkind_status_ok, lspkind = pcall(require, "lspkind")
			local snip_status_ok, luasnip = pcall(require, "luasnip")

			if not snip_status_ok then
				return
			end

			return {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						side_padding = 4,
					},
					documentation = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						side_padding = 4,
					},
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "crates", priority = 1000 },
					{ name = "vim-dadbod-completion", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
					{ name = "neorg", priority = 250 },
				}),
				mapping = {
					["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-y>"] = cmp.config.disable,
					["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				formatting = {
					-- format = lspkind_status_ok and lspkind.cmp_format({
					-- 	mode = "symbol",
					-- 	maxwidth = 25,
					-- 	ellipsis_char = "...",
					-- 	before = function(entry, vim_item)
					-- 		if vim_item.kind == "Color" and entry.completion_item.documentation then
					-- 			local _, _, r, g, b =
					-- 				string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
					-- 			if r then
					-- 				local color = string.format("%02x", r)
					-- 					.. string.format("%02x", g)
					-- 					.. string.format("%02x", b)
					-- 				local group = "Tw_" .. color
					-- 				if vim.fn.hlID(group) < 1 then
					-- 					vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
					-- 				end
					-- 				vim_item.kind_hl_group = group
					-- 				return vim_item
					-- 			end
					-- 		end
					-- 		return vim_item
					-- 	end,
					-- }),
					format = function(entry, vim_item)
						if not require("cmp.utils.api").is_cmdline_mode() then
							local abbr_width_max = 25
							local menu_width_max = 20

							local choice = require("lspkind").cmp_format({
								ellipsis_char = icons.ellipsis,
								maxwidth = abbr_width_max,
								mode = "symbol",
							})(entry, vim_item)

							choice.abbr = vim.trim(choice.abbr)

							local abbr_width = string.len(choice.abbr)
							if abbr_width < abbr_width_max then
								local padding = string.rep(" ", abbr_width_max - abbr_width)
								vim_item.abbr = choice.abbr .. padding
							end

							local cmp_ctx = get_lsp_completion_context(entry.completion_item, entry.source)
							if cmp_ctx ~= nil and cmp_ctx ~= "" then
								choice.menu = cmp_ctx
							else
								choice.menu = ""
							end

							local menu_width = string.len(choice.menu)
							if menu_width > menu_width_max then
								choice.menu = vim.fn.strcharpart(choice.menu, 0, menu_width_max - 1)
								choice.menu = choice.menu .. icons.ellipses
							else
								local padding = string.rep(" ", menu_width_max - menu_width)
								choice.menu = padding .. choice.menu
							end

							return choice
						else
							local abbr_width_min = 20
							local abbr_width_max = 50

							local choice = require("lspkind").cmp_format({
								ellipsis_char = icons.ellipses,
								maxwidth = abbr_width_max,
								mode = "symbol",
							})(entry, vim_item)

							choice.abbr = vim.trim(choice.abbr)

							local abbr_width = string.len(choice.abbr)
							if abbr_width < abbr_width_min then
								local padding = string.rep(" ", abbr_width_min - abbr_width)
								vim_item.abbr = choice.abbr .. padding
							end

							return choice
						end
					end,
				},
			}
		end,
	},
}
