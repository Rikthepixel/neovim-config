--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fd",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "[F]ormat [D]ocument",
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		opts = function()
			require("utils.mason").install_missing("prettierd", "stylua", "pint")

			---@module "conform"
			---@type conform.setupOpts
			return {
				default_format_opts = { lsp_format = "fallback" },
				formatters = {
					standardts = require("fmt.standardts"),
					dotnetformat = require("fmt.dotnetformat"),
				},
				formatters_by_ft = {
					lua = { "stylua" },
					php = { "pint" },
					javascript = { "standardjs", "prettier", "prettierd", stop_after_first = true },
					typescript = { "standardts", "prettier", "prettierd", stop_after_first = true },
					javascriptreact = { "standardjs", "prettier", "prettierd", stop_after_first = true },
					typescriptreact = { "standardts", "prettier", "prettierd", stop_after_first = true },
					json = { "prettier", "prettierd", stop_after_first = true },
					cs = { "dotnetformat", stop_after_first = true },
					yaml = { "prettier", "prettierd", stop_after_first = true },
					_ = { "trim_whitespace" },
				},

				format_on_save = {
					timeout_ms = 500,
					async = true,
					lsp_format = "fallback",
				},
			}
		end,
	},
}
