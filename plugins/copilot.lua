---@diagnostic disable: missing-fields
--- @module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",

		--- @module "copilot"
		--- @type CopilotConfig
		opts = {
			debug = false,
			suggestion = { enabled = false },
			panel = { enabled = false },
			server_opts_overrides = {
				settings = { advanced = { inlineSuggestCount = 3 } },
			},
			workspace_folders = { "~/Documents/Repositories" },
		},
	},

	-- Add CodeCompanion plugin with a Github Copilot setup to this configuration
	{
		"olimorris/codecompanion.nvim",
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
			"CodeCompanionCmd",
		},
		opts = {},
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
