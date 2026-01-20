--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"Pocco81/auto-save.nvim",
		event = { "BufWritePre" },
		opts = {
			write_all_buffers = true,
			debounce_delay = 500,
			condition = function(buf)
				local fn = vim.fn
				local utils = require("auto-save.utils.data")

				if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), { "harpoon", "NvimTree_1" }) then
					return true -- met condition(s), can save
				end
				return false -- can't save
			end,
		},
	},
}