--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			no_italic = true,
			integration = {
				mason = true,
				harpoon = true,
				gitsigns = true,
				blink = true,
				treesitter = true,
			},
		},
		init = function()
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
	{ "nvim-tree/nvim-web-devicons" },
}
