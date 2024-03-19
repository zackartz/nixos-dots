local icons = require("utils.icons").icons

return {
  { name = "DiagnosticSignError", text = icons.Error, texthl = "DiagnosticError" },
  { name = "DiagnosticSignHint", text = icons.Hint, texthl = "DiagnosticHint" },
  { name = "DiagnosticSignWarn", text = icons.Warn, texthl = "DiagnosticWarn" },
  { name = "DiagnosticSignInfo", text = icons.Info, texthl = "DiagnosticInfo" },
  { name = "DapBreakpoint", text = icons.Breakpoint, texthl = "Breakpoint" },
}
