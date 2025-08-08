--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"akinsho/git-conflict.nvim",
		opts = { default_mappings = false },
		keys = { { "<leader>cq", "<CMD>:GitConflictListQf<CR>", desc = "[C]onflict [Q]uicklist" } },
	},
	{
		"lewis6991/gitsigns.nvim",
		version = "*", -- Latest stable version
		event = "BufEnter",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = { delay = 2000 },
		},
	},
}
