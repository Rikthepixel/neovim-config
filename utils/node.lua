local node_utils = {}

function node_utils.includes_some_packages(...)
	local packages = { ... }
	if #packages == 0 then
		return true
	end

	local buf_name = vim.api.nvim_buf_get_name(0)
	local path = buf_name == "" and vim.fn.getcwd() or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
	local node_modules = vim.fs.find("node_modules", {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = path,
	})

	if not node_modules[1] then
		return false
	end

	node_modules = node_modules[1]

	for _, package in ipairs(packages) do
		if vim.fn.isdirectory(node_modules .. "/" .. package) == 1 then
			return true
		end
	end

	return false
end

return node_utils