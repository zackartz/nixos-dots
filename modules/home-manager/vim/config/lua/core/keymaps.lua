local map = require("utils.mappings")
local f = require("utils.functions")
local fmt = require("utils.icons").fmt
local l, cmd, rcmd, lua = map.leader, map.cmd, map.rcmd, map.lua

return {
  i = {
    ["jj"] = { "<esc>", "Exit insert mode" },
  },
  n = {
    -- utils
    ["vv"] = { "V", "Linewise visual" },
    [l("w")] = { cmd("w"), fmt("Save", "Save file") },
    [l("W")] = { cmd("w!"), fmt("Save", "Save file!") },
    [l("q")] = { cmd("q"), fmt("Exit", "Exit window") },
    [l("Q")] = { cmd("q!"), fmt("Exit", "Exit window!") },
    [l("p")] = { '"+p', fmt("Clipboard", "Paste from clipboard") },
    [l("P")] = { '"+P', fmt("Clipboard", "Paste from clipboard") },
    [l(":")] = { ":lua ", fmt("Lua", "Lua prompt") },
    [l("%")] = { cmd("luafile %"), fmt("Lua", "Luafile") },
    [l(";")] = { f.comment_line, fmt("Comment", "Comment line") },
    [l(" ")] = { cmd("wincmd w"), fmt("Window", "Switch window") },

    -- UI utils
    [l("uw")] = { f.toggle_wrap, fmt("LineWrap", "Toggle wrap") },
    [l("ug")] = { cmd("GuessIndent"), fmt("Indent", "Guess indent") },
    [l("uf")] = { f.set_filetype, fmt("DefaultFile", "Set filetype") },
    [l("ui")] = { f.set_indent, fmt("Indent", "Set indentation") },
    [l("uI")] = { f.set_indent_type, fmt("Indent", "Set indentation type") },
    [l("us")] = { cmd("nohlsearch"), fmt("Clear", "Clear search highlights") },

    -- Neotree
    [l("e")] = { cmd("Neotree toggle"), fmt("FileTree", "Toggle Neotree") },

    -- move.nvim
    ["<A-j>"] = { cmd("MoveLine(1)"), "Move line down" },
    ["<A-k>"] = { cmd("MoveLine(-1)"), "Move line up" },
    ["<A-h>"] = { cmd("MoveHChar(-1)"), "Move character left" },
    ["<A-l>"] = { cmd("MoveHChar(1)"), "Move character right" },

    -- ccc
    [l("cp")] = { cmd("CccPick"), fmt("ColorPicker", "Pick color") },
    [l("cc")] = { cmd("CccConvert"), fmt("Swap", "Convert color") },
    [l("ce")] = { cmd("CccHighlighterEnable"), fmt("ColorOn", "Enable highlights") },
    [l("cd")] = { cmd("CccHighlighterDisable"), fmt("ColorOff", "Disable highlights") },

    -- buffer utils
    [l("bq")] = { cmd("BufDel"), fmt("Close", "Close current buffer") },
    [l("bQ")] = { cmd("BufDel!"), fmt("Close", "close current buffer!") },
    [l("bb")] = { cmd("BufferLinePick"), fmt("Open", "Pick to open buffer") },
    [l("bd")] = { cmd("BufferLinePickClose"), fmt("Close", "Pick to close buffer") },
    [l("bl")] = { cmd("BufferLineCloseLeft"), fmt("CloseMultiple", "Close buffers to the left") },
    [l("br")] = { cmd("BufferLineCloseRight"), fmt("CloseMultiple", "Close buffers to the right") },
    [l("bn")] = { cmd("BufferLineCycleNext"), fmt("NextBuffer", "Move to next buffer") },
    [l("bp")] = { cmd("BufferLineCyclePrev"), fmt("PrevBuffer", "Move to previous buffer") },
    [l("bi")] = { cmd("BufferLineTogglePin"), fmt("Pin", "Pin buffer") },
    [l("bg")] = { f.first_buffer, fmt("PrevBuffer", "Move to first buffer") },
    [l("bG")] = { f.last_buffer, fmt("NextBuffer", "Move to last buffer") },
    [l("bv")] = { f.buf_vsplit, fmt("Vertical", "Vertical split") },
    [l("bh")] = { f.buf_hsplit, fmt("Horizontal", "Horizontal split") },

    -- gitsigns
    [l("gb")] = { cmd("Gitsigns toggle_current_line_blame"), fmt("GitDiff", "Line blame") },
    [l("gd")] = { cmd("Gitsigns diffthis"), fmt("GitDiff", "Show diff") },
    [l("gD")] = { cmd("Gitsigns toggle_deleted"), fmt("DiffRemoved", "Toggle deleted") },
    [l("gp")] = { cmd("Gitsigns preview_hunk"), fmt("Popup", "Preview hunk") },
    [l("gP")] = { cmd("Gitsigns preview_hunk_inline"), fmt("Popup", "Preview hunk inline") },
    [l("gn")] = { cmd("Gitsigns next_hunk"), fmt("Down", "Next hunk") },
    [l("gN")] = { cmd("Gitsigns prev_hunk"), fmt("Up", "Previous hunk") },
    [l("gr")] = { cmd("Gitsigns reset_hunk"), fmt("Restore", "Revert hunk") },
    [l("gs")] = { cmd("Gitsigns stage_hunk"), fmt("Save", "Stage hunk") },
    [l("gv")] = { cmd("Gitsigns select_hunk"), fmt("Visual", "Select hunk") },
    [l("gw")] = { cmd("Gitsigns toggle_word_diff"), fmt("GitDiff", "Toggle word diff") },
    [l("gg")] = { cmd("Telescope git_status"), fmt("Git", "Git status") },

    -- toggleterm
    [l("th")] = { cmd("ToggleTerm direction=horizontal"), fmt("Horizontal", "Horizontal terminal") },
    [l("tv")] = {
      cmd("ToggleTerm direction=vertical size=60"),
      fmt("Vertical", "Vertical terminal"),
    },
    [l("tf")] = { cmd("ToggleTerm direction=float"), fmt("Window", "Floating terminal") },
    [l("tl")] = { f.open_lazygit, fmt("GitBranch", "Lazygit terminal") },
    [l("tg")] = { f.open_glow, fmt("Markdown", "Glow terminal") },

    -- wincmd
    ["<C-h>"] = { cmd("wincmd h"), "Move right" },
    ["<C-j>"] = { cmd("wincmd j"), "Move down" },
    ["<C-k>"] = { cmd("wincmd k"), "Move up" },
    ["<C-l>"] = { cmd("wincmd l"), "Move left" },

    -- telescope
    [l("ff")] = { cmd("Telescope find_files"), fmt("FileSearch", "Find files") },
    [l("fF")] = { cmd("Telescope find_files hidden=true"), fmt("FileSearch", "Find all files") },
    [l("fg")] = { cmd("Telescope live_grep"), fmt("TextSearch", "Live grep") },
    [l("fb")] = { cmd("Telescope buffers"), fmt("TabSearch", "Find buffer") },
    [l("fh")] = { cmd("Telescope help_tags"), fmt("Help", "Find help") },
    [l("fd")] = { cmd("Telescope diagnostics"), fmt("Warn", "Find diagnostic") },
    [l("fs")] = { cmd("Telescope lsp_document_symbols"), fmt("Braces", "Document symbol") },
    [l("fr")] = { cmd("Telescope resume"), fmt("Run", "Resume search") },
    [l("fn")] = { cmd("Telescope notify"), fmt("Notification", "Show notifications") },
    [l("fo")] = { cmd("Telescope vim_options"), fmt("Config", "Vim options") },
    [l("f:")] = { cmd("Telescope command_history"), fmt("History", "Command history") },
    [l("fm")] = { cmd("Telescope man_pages"), fmt("Info", "Search man") },
    [l("fR")] = { cmd("Telescope reloader"), fmt("Restore", "Reload module") },
    [l("fH")] = { cmd("Telescope highlights"), fmt("Color", "Highlight group") },
    [l("ft")] = { cmd("Telescope treesitter"), fmt("Symbol", "Treesitter") },
    [l("fz")] = { cmd("Telescope current_buffer_fuzzy_find"), fmt("Search", "Buffer fuzzy find") },
    [l("fp")] = { cmd("Telescope registers"), fmt("Clipboard", "Registers") },
    [l("fq")] = { cmd("Telescope quickfix"), fmt("Fix", "Quickfix") },
    [l("gc")] = { cmd("Telescope git_bcommits"), fmt("GitCommit", "Find branch commit") },
    [l("gC")] = { cmd("Telescope git_commits"), fmt("GitCommit", "Find commit") },
    [l("gB")] = { cmd("Telescope git_branches"), fmt("GitBranch", "Find git branch") },

    -- Lazy
    [l("L")] = { cmd("Lazy"), fmt("Package", "Plugin manager") },

    -- Mason
    [l("M")] = { cmd("Mason"), fmt("Package", "Mason") },

    -- DAP
    [l("do")] = { f.open_dapui, fmt("Open", "Open debugger UI") },
    [l("dq")] = { f.close_dapui, fmt("Close", "Close debugger UI") },
    [l("dt")] = { f.toggle_dapui, fmt("Toggle", "Toggle debugger") },
    [l("dc")] = { cmd("DapTerminate"), fmt("Stop", "Terminate session") },
    [l("dr")] = { cmd("DapRestartFrame"), fmt("Restart", "Restart frame") },
    [l("db")] = { cmd("DapToggleBreakpoint"), fmt("Toggle", "Toggle breakpoint") },
    [l("dl")] = { cmd("DapShowLog"), fmt("DefaultFile", "Show logs") },
    ["<F5>"] = { cmd("DapContinue"), "Continue session" },
    ["<F9>"] = { cmd("DapToggleBreakpoint"), "Toggle breakpoint" },
    ["<F11>"] = { cmd("DapStepInto"), "Step into" },
    ["<F23>"] = { cmd("DapStepOut"), "Step out" },
    ["<F12>"] = { cmd("DapStepOver"), "Step over" },

    -- telescope DAP
    [l("dB")] = {
      lua("require('telescope').extensions.dap.list_breakpoints()"),
      fmt("Breakpoint", "List breakpoints"),
    },
    [l("dv")] = {
      lua("require('telescope').extensions.dap.variables()"),
      fmt("Variable", "List variables"),
    },
    [l("df")] = {
      lua("require('telescope').extensions.dap.frames()"),
      fmt("Stack", "List frames"),
    },
    [l("dF")] = {
      lua("require('telescope').extensions.dap.configurations()"),
      fmt("Config", "List configurations"),
    },
    [l("dC")] = {
      lua("require('telescope').extensions.dap.commands()"),
      fmt("Command", "List commands"),
    },

    -- session-manager
    [l("Ss")] = { cmd("SessionManager save_current_session"), fmt("Save", "Save session") },
    [l("Sl")] = { cmd("SessionManager load_session"), fmt("Restore", "Load session") },
    [l("SL")] = { cmd("SessionManager load_last_session"), fmt("Restore", "Load last session") },
    [l("Sd")] = { cmd("SessionManager delete_session"), fmt("Trash", "Delete session") },
    [l("SD")] = {
      cmd("SessionManager load_current_dir_session"),
      fmt("FolderClock", "Load current directory session"),
    },

    -- notify
    [l("nn")] = {
      lua("require('notify').dismiss()"),
      fmt("NotificationDismiss", "Dismiss notifications"),
    },

    -- lspconfig
    [l("li")] = { cmd("LspInfo"), fmt("Info", "Server info") },
    [l("lI")] = { cmd("LspLog"), fmt("DefaultFile", "Server logs") },
    [l("lS")] = { ":LspStart ", fmt("Run", "Start server") },
    [l("lq")] = { ":LspStop ", fmt("Stop", "Stop server") },
    [l("lR")] = { cmd("LspRestart"), fmt("Restart", "Restart server") },

    -- dropbar
    [l("ok")] = { lua("require('dropbar.api').goto_context_start()"), fmt("Up", "Context start") },
    [l("oo")] = { lua("require('dropbar.api').pick()"), fmt("Check", "Pick node") },

    -- DbUI
    [l("Dd")] = { cmd("DBUIToggle"), fmt("Toggle", "Toggle DbUI") },
    [l("Da")] = { cmd("DBUIAddConnection"), fmt("Add", "Add connection") },

    -- nvim-devdocs
    [l("v ")] = { cmd("DevdocsToggle"), fmt("Window", "Toggle floating window") },
    [l("vc")] = { cmd("DevdocsOpenCurrentFloat"), fmt("BookmarkSearch", "Open current file docs") },
    [l("vv")] = { cmd("DevdocsOpenFloat"), fmt("BookmarkSearch", "Open in floating window") },
    [l("vV")] = { cmd("DevdocsOpen"), fmt("BookmarkSearch", "Open in a normal buffer") },
    [l("vf")] = { ":DevdocsOpenFloat ", fmt("BookmarkSearch", "Open documentation") },
    [l("vi")] = { ":DevdocsInstall ", fmt("Install", "Install documentation") },
    [l("vu")] = { ":DevdocsUninstall ", fmt("Trash", "Install documentation") },

    -- crates
    [l("Cv")] = {
      lua("require('crates').show_versions_popup()"),
      fmt("Info", "Show versions popup"),
    },
    [l("Cf")] = {
      lua("require('crates').show_features_popup()"),
      fmt("Stack", "Show features popup"),
    },
    [l("Cd")] = {
      lua("require('crates').show_dependencies_popup()"),
      fmt("Dependencies", "Show dependencies popup"),
    },
    [l("Cu")] = {
      lua("require('crates').update_crate()"),
      fmt("Update", "Update crate"),
    },
    [l("CU")] = {
      lua("require('crates').update_all_crates()"),
      fmt("Update", "Update all crates"),
    },
    [l("CD")] = {
      lua("require('crates').open_documentation()"),
      fmt("DefaultFile", "Open documentation"),
    },
    [l("Ch")] = {
      lua("require('crates').open_homepage()"),
      fmt("Web", "Open homepage"),
    },
    [l("Cc")] = {
      lua("require('crates').open_crates_io()"),
      fmt("Package", "Open crates.io"),
    },
    [l("Cr")] = {
      lua("require('crates').open_repository()"),
      fmt("Github", "Open repository"),
    },
  },
  v = {
    -- move.nvim
    ["<A-k>"] = { rcmd("MoveBlock(-1)"), "Move line up" },
    ["<A-j>"] = { rcmd("MoveBlock(1)"), "Move line down" },
    ["<A-h>"] = { rcmd("MoveHBlock(-1)"), "Move character left" },
    ["<A-l>"] = { rcmd("MoveHBlock(1)"), "Move character right" },

    -- utils
    ["q"] = { "<esc>" },
    [l("y")] = { '"+y', fmt("Clipboard", "yank to clipboard") },
    [l("p")] = { '"+p', fmt("Clipboard", "Paste from clipboard") },
    [l("P")] = { '"+P', fmt("Clipboard", "Paste from clipboard") },
    [l(";")] = { f.comment_selection, fmt("Comment", "Comment selection") },

    -- gitsigns
    [l("gr")] = { cmd("Gitsigns reset_hunk"), fmt("Restore", "Revert hunk") },

    -- crates
    [l("Cu")] = { lua("require('crates').update_crates()"), fmt("Update", "Update crates") },
  },

  t = {
    -- toggleterm
    ["<esc>"] = { [[<C-\><C-n>]] },

    -- wincmd
    ["<C-h>"] = { cmd("wincmd h"), "Move right" },
    ["<C-j>"] = { cmd("wincmd j"), "Move down" },
    ["<C-k>"] = { cmd("wincmd k"), "Move up" },
    ["<C-l>"] = { cmd("wincmd l"), "Move left" },
  },
}
