return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				delay = 2000,
			},
		},
		event = "BufEnter",
	},
	{
		"akinsho/git-conflict.nvim",
		opts = {
			default_mappings = false,
		},
		event = "VeryLazy",
		keys = {
			{ "<leader>cq", "<CMD>:GitConflictListQf<CR>", desc = "[C]onflict [Q]uicklist" },
		},
	},
}