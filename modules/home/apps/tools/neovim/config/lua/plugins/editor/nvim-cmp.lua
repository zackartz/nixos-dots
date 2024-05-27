return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()

			local ls = require("luasnip")
			local s = ls.snippet
			local i = ls.insert_node
			local t = ls.text_node
			local fmt = require("luasnip.extras.fmt").fmt -- Import the fmt function

			-- Define a new snippet for your specific use case
			ls.add_snippets("nix", { -- Assuming the snippet is for Nix files, adjust the filetype as necessary
				s(
					"nixcfg",
					fmt(
						[[
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.<>;
in {
  options.<> = with types; {
    enable = mkBoolOpt false "<>";
  };

  config = mkIf cfg.enable {
<>
  };
}]],
						{
							i(1), -- Cursor point 1, after config.
							i(2), -- Cursor point 2, after options.
							i(3), -- Cursor point 3, for the option description inside mkBoolOpt
							i(4), -- Cursor point 4, inside the mkIf cfg.enable block
						},
						{ delimiters = "<>" }
					)
				), -- Ensure to specify the delimiters if they differ from the default
			})
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
			local lspkind = require("lspkind")

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

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
						col_offset = -3,
						side_padding = 0,
					},
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "crates", priority = 1000 },
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
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},
				experimental = {
					ghost_text = true,
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind = lspkind.cmp_format({
							mode = "symbol_text",
							maxwidth = 50,
						})(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. strings[1] .. " "
						kind.menu = "    (" .. strings[2] .. ")"

						return kind
					end,
				},
			}
		end,
	},
}
