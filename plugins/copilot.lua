---@diagnostic disable: missing-fields
--- @module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"rikthepixel/copilot-compat.nvim",
        enabled = false,
		dev = true,
		-- lazy = false,
		--- @module "copilot-compat"
		--- @type copilot_compat.Config
		opts = {},
	},

	{
		"zbirenbaum/copilot.lua",
        enabled = false,
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
        enabled = false,
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
			"CodeCompanionCmd",
		},
		opts = function()
			return {
				ignore_warnings = true,
				display = { chat = { show_token_count = false } },
				memory = { opts = { chat = { enabled = true } } },
				extensions = {
					copilot_compat = {},
					mcphub = {
						callback = "mcphub.extensions.codecompanion",
						opts = {
							make_vars = true,
							make_slash_commands = true,
							show_result_in_chat = true,
						},
					},
				},
				rules = {
					copilot = {
						files = { ".github/instructions/*.instructions.md" },
					},
					opts = {
						chat = {
							autoload = { "default", "copilot" },
						},
					},
				},
				log_level = "DEBUG",
			}
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-lua/plenary.nvim",
			"ravitemer/mcphub.nvim",
		},
	},

	{
		"ravitemer/mcphub.nvim",
        enabled = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		build = "bundled_build.lua",
		cmd = {
			"MCPHub",
		},
		--- @module "mcphub"
		--- @type mcphub.Config
		opts = {
			use_bundled_binary = true, -- Use local `mcp-hub` binary
		},
	},
}
