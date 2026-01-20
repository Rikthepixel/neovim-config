--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"folke/snacks.nvim",
		lazy = false,
		--- @module "snacks"
		--- @type snacks.Config
		opts = {
			-- Editor
			indent = {
				animate = { enabled = false },
				scope = { enabled = false },
			},
			words = {},
			dim = {},
			scratch = {},

			-- UI
			statuscolumn = {},
			dashboard = {},
			notifier = {},
			terminal = {},

			-- Fixes
			rename = {},
			bigfile = {},
		},

		keys = {
			{
				"<leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<c-_>",
				function()
					Snacks.terminal()
				end,
				desc = "which_key_ignore",
			},
			{
				"<leader>z",
				function()
					Snacks.dim()
				end,
				desc = "Toggle Dim Mode",
			},
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select Scratch Buffer",
			},
		},
	},
}
