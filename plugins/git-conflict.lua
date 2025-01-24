return {
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