--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		event = "BufEnter",
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
}
