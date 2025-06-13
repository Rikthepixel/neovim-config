---@diagnostic disable: missing-fields
--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				"~/Documents/Repositories/lokaal-copilot.nvim",
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		--- @module "copilot"
		--- @type CopilotConfig
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			workspace_folders = { "~/Documents/Repositories" },
		},
	},
	{
		"tronikelis/ts-autotag.nvim",
		opts = {},
		event = "VeryLazy",
	},
	{
		"saghen/blink.cmp",
		version = "1.*",

		event = "VimEnter",

		dependencies = {
			"rafamadriz/friendly-snippets",
			"fang2hou/blink-copilot",
			"folke/lazydev.nvim",
		},

		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			keymap = {
				preset = "super-tab",
				["<A-space>"] = { "show" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				trigger = {},
				documentation = { auto_show = true },
				ghost_text = { enabled = true },
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
					},
				},
			},

			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},

			sources = {
				default = { "copilot", "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- score_offset = 100,
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						-- score_offset = 100,
						async = true,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
