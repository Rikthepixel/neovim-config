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
				notify_no_formatters = false,
				notify_on_error = false,
				default_format_opts = {
					stop_after_first = true,
					lsp_format = "fallback",
				},
				formatters = {
					standardts = require("fmt.standardts"),
					dotnetformat = require("fmt.dotnetformat"),
				},
				formatters_by_ft = {
					lua = { "stylua" },
					php = { "pint" },
					javascript = { "standardjs", "prettier", "prettierd" },
					typescript = { "standardts", "prettier", "prettierd" },
					javascriptreact = { "standardjs", "prettier", "prettierd" },
					typescriptreact = { "standardts", "prettier", "prettierd" },
					json = { "prettier", "prettierd" },
					cs = { "dotnetformat" },
					yaml = { "prettier", "prettierd" },
					_ = { "trim_whitespace" },
				},
				-- format_on_save = {
				-- 	timeout_ms = 3000,
				-- 	async = true,
				-- },
			}
		end,
	},
}
