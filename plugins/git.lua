--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"akinsho/git-conflict.nvim",
		opts = { default_mappings = false },
		keys = { { "<leader>cq", "<CMD>:GitConflictListQf<CR>", desc = "[C]onflict [Q]uicklist" } },
	},
}
