return {
	{
		"goolord/alpha-nvim",
        lazy = false,
		config = function()
			require("alpha").setup(require("alpha.themes.theta").config)
		end,
	},
}