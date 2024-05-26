local icons = require("utils.icons").icons
local fmt = require("utils.icons").fmt
local M = {}

M.mode = {
	"mode",
	fmt = function(name)
		local map = {
			NORMAL = icons.Normal,
			INSERT = icons.Insert,
			TERMINAL = icons.Terminal,
			VISUAL = icons.Visual,
			["V-LINE"] = icons.Visual,
			["V-BLOCK"] = icons.Visual,
			["O-PENDING"] = icons.Ellipsis,
			COMMAND = icons.Command,
			REPLACE = icons.Edit,
			SELECT = icons.Visual,
		}
		local icon = map[name] and map[name] or icons.Vim
		return icon .. " " .. name
	end,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		local mode = vim.fn.mode()
		local map = {
			n = colors.sapphire,
			i = colors.green,
			c = colors.yellow,
			t = colors.mauve,
			R = colors.maroon,
			v = colors.lavender,
			V = colors.lavender,
			s = colors.sky,
			S = colors.sky,
		}
		return {
			fg = colors.base,
			bg = map[mode] or colors.blue,
		}
	end,
}

M.branch = {
	"branch",
	icon = icons.GitBranch,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()

		return { bg = colors.base }
	end,
}

M.diff = {
	"diff",
	symbols = {
		added = fmt("Add", ""),
		modified = fmt("Modified", ""),
		removed = fmt("Removed", ""),
	},
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { bg = colors.base }
	end,
}

M.filetype = { "filetype" }

M.diagnostics = {
	"diagnostics",
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { bg = colors.base }
	end,
}

M.encoding = {
	"encoding",
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { fg = colors.blue, bg = colors.base }
	end,
}

M.fileformat = {
	"fileformat",
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { fg = colors.blue, bg = colors.base }
	end,
}

M.indentation = {
	"indentation",
	fmt = function()
		local type = vim.bo[0].expandtab and "spaces" or "tabs"
		local value = vim.bo[0].shiftwidth
		return type .. ": " .. value
	end,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { fg = colors.blue, bg = colors.base }
	end,
}

M.progress = {
	"progress",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { fg = colors.lavender, bg = colors.base }
	end,
}

M.location = {
	"location",
	fmt = function(location)
		return vim.trim(location)
	end,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { fg = colors.lavender, bg = colors.base }
	end,
}

M.macro = {
	function()
		return vim.fn.reg_recording()
	end,
	icon = icons.Recording,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { fg = colors.red, bg = colors.base }
	end,
}

M.lsp = {
	function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		if next(clients) == nil then
			return ""
		end
		local attached_clients = vim.tbl_map(function(client)
			return client.name
		end, clients)
		return table.concat(attached_clients, ", ")
	end,
	icon = icons.Braces,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { fg = colors.overlay0, bg = colors.base }
	end,
}

M.gap = {
	function()
		return " "
	end,
	color = function()
		local colors = require("catppuccin.palettes").get_palette()
		return { bg = colors.base }
	end,
	padding = 0,
}

return M
