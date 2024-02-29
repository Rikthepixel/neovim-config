local mason_utils = {}

function mason_utils.install_missing(...)
	local registry = require("mason-registry")
	local packages = { ... }
	local packages_to_install = ""

	for _, package in ipairs(packages) do
		if not registry.is_installed(package) then
			packages_to_install = packages_to_install .. " " .. package
		end
	end

	if packages_to_install == "" then
		return
	end

	vim.cmd("MasonInstall " .. packages_to_install)
end

return mason_utils