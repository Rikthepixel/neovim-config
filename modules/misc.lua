-- Note to self, only include plugins that really don't fall under any other category
return {
	{
		"Pocco81/auto-save.nvim",
		event = "VeryLazy",
		opts = {
			condition = function(buf)
				local fn = vim.fn
				local utils = require("auto-save.utils.data")

				if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), { "harpoon" }) then
					return true -- met condition(s), can save
				end
				return false -- can't save
			end,
		},
	},
}
