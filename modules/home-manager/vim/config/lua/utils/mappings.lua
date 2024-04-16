local M = {}

M.leader = function(key)
	return "<leader>" .. key
end
M.cmd = function(cmd)
	return "<cmd>" .. cmd .. "<CR>"
end
M.rcmd = function(cmd)
	return ":" .. cmd .. "<CR>"
end
M.lua = function(cmd)
	return "<cmd>lua " .. cmd .. "<CR>"
end
M.notify = function(cmd)
	return M.cmd("call VSCodeNotify('" .. cmd .. "')")
end

return M
