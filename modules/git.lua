return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		event = "BufEnter",
	},
	{
		"akinsho/git-conflict.nvim",
		opts = {
			default_mappings = false,
		},
		event = "BufEnter",
		keys = {
			{ "cq", "<CMD>:GitConflictListQf<CR>", desc = "[C]onflict [Q]uicklist" },
		},
	},
}