---@diagnostic disable: missing-fields
--- @module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"rikthepixel/copilot-rules.nvim",
		dev = true,
		-- lazy = false,
		--- @module "copilot-rules"
		--- @type copilot_rules.Config
		opts = {},
	},

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
				settings = {
					telemetry = { telemetryLevel = "off" },
					advanced = { inlineSuggestCount = 3 },
				},
			},
			workspace_folders = { "~/Documents/Repositories" },
			filetypes = { markdown = true },
		},
	},

	{
		"olimorris/codecompanion.nvim",
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
			"CodeCompanionCmd",
		},
		opts = function()
			return {
				-- adapters = {
				-- 	ollama_gemma = function()
				-- 		return require("codecompanion.adapters").extend("ollama", {
				-- 			name = "ollama_gemma",
				-- 			schema = { model = { default = "gemma3:12b" } },
				-- 		})
				-- 	end,
				-- },
				-- strategies = {
				-- 	chat = { adapter = "ollama_gemma" },
				-- 	inline = { adapter = "ollama_gemma" },
				-- 	cmd = { adapter = "ollama_gemma" },
				-- },
				display = { chat = { show_token_count = false } },
				extensions = { copilot_rules = {} },
				log_level = "DEBUG",
			}
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
