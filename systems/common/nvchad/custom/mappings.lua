---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>tc"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "toggle transparency",
    },
    ["<leader>rl"] = {
      function()
        require("rust-tools").hover_actions.hover_actions()
      end,
      "rust hover actions",
    },
    ["<leader>rr"] = {
      function()
        require("rust-tools").runnables.runnables()
      end,
      "rust runnables",
    },
    ["<leader>re"] = {
      function()
        require("rust-tools").expand_macro.expand_macro()
      end,
      "expand rust macro",
    },
    ["<leader>rlr"] = {
      function()
        require("rust-tools").hover_range.hover_range()
      end,
      "rust hover range",
    },
    ["<leader>rc"] = {
      function()
        require("rust-tools").open_cargo_toml.open_cargo_toml()
      end,
      "open cargo.toml",
    },
    ["<leader>rp"] = {
      function()
        require("rust-tools").parent_module.parent_module()
      end,
      "open rust parent module",
    },
    ["<leader>rj"] = {
      function()
        require("rust-tools").join_lines.join_lines()
      end,
      "rust join lines",
    },
    ["<F5>"] = {
      function()
        require("dap").continue()
      end,
      "nvim dap continue",
    },
    ["<F10>"] = {
      function()
        require("dap").step_over()
      end,
      "nvim dap step_over",
    },
    ["<F11>"] = {
      function()
        require("dap").step_into()
      end,
      "nvim dap step_into",
    },
    ["<F12>"] = {
      function()
        require("dap").step_out()
      end,
      "nvim dap step_out",
    },
    ["<leader>b"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "nvim dap toggle breakpoint",
    },
    ["<leader>B"] = {
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint Condition: ")
      end,
      "nvim set breakpoint with condition",
    },
    ["<leader>lp"] = {
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
      end,
      "nvim set breakpoint log message",
    },
    ["<leader>dr"] = {
      function()
        require("dap").repl.open()
      end,
      "nvim dap open repl",
    },
    ["<leader>rdb"] = {
      function()
        require("rust-tools").debuggables.debuggables()
      end,
      "rust debuggables",
    },
    ["<leader>do"] = {
      function()
        require("dapui").open()
      end,
      "open debug ui",
    },
    ["<leader>dc"] = {
      function()
        require("dapui").close()
      end,
      "close debug ui",
    },
    ["ca"] = {
      function()
        require("copilot.suggestion").accept_line()
      end,
    },
    ["cn"] = {
      function()
        require("copilot.suggestion").next()
      end,
    },
    ["cp"] = {
      function()
        require("copilot.suggestion").prev()
      end,
    },
  },
}

-- more keybinds!

return M
