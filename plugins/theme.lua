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
	{
		"goolord/alpha-nvim",
		lazy = false,
		config = function()
			require("alpha").setup(require("alpha.themes.theta").config)
		end,
	},
	{ "nvim-tree/nvim-web-devicons", },
}
