return function(config_name, plugins_path)
	local lazy_packages = vim.fn.stdpath("data") .. "/" .. config_name .. "/lazy"
	local lazy_path = lazy_packages .. "/lazy.nvim"

	if not vim.loop.fs_stat(lazy_path) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazy_path,
		})
	end

	if not vim.loop.fs_stat(lazy_path) then
		return vim.notify_once("FATAL: Lazy could not be loaded")
	end

	vim.opt.rtp:prepend(lazy_path)

	--- @module "lazy"
	require("lazy").setup(plugins_path, {
		root = lazy_packages,
		defaults = { lazy = true },
		change_detection = { notify = false },
		install = { colorscheme = { "catppuccin-mocha", "habamax" } },
		dev = {
			path = "~/Documents/Repositories/",
			-- fallback = true,
		},
		lockfile = vim.fn.stdpath("config") .. "/lua/" .. config_name .. "/lazy-lock.json",
	})
end
