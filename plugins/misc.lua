--- @module "lazy"
---@type LazyPluginSpec[]
return {
	-- Should always be installed but doesn't need to be loaded eagerly
	{ "nvim-lua/plenary.nvim" },

	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
}
