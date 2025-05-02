--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		opts = {
			no_italic = true,
			integration = {
				mason = true,
				harpoon = true,
				gitsigns = true,
				cmp = true,
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
}