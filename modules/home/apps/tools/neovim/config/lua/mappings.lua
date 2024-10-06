require "nvchad.mappings"
local map = require "utils"
local l, cmd, rcmd, lua = map.leader, map.cmd, map.rcmd, map.lua

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", l "ng", cmd "Neogit", { desc = "Open Neogit" })
