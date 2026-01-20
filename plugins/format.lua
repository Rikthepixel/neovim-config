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

			local js_like = { "standardjs", "prettierd", "prettier" }
			local ts_like = { "standardts", "prettierd", "prettier" }

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
					dotnet_fmt = require("fmt.dotnet_fmt"),
                    caddy_fmt = require("fmt.caddy_fmt")
				},
				formatters_by_ft = {
					lua = { "stylua" },
					php = { "pint" },
					javascript = js_like,
					javascriptreact = js_like,
					typescript = ts_like,
					typescriptreact = ts_like,
					svelte = ts_like,
					json = { "prettierd", "prettier" },
					yaml = { "prettierd", "prettier" },
					cs = { "dotnet_fmt" },
                    terraform = { "terraform_fmt" },
                    caddy = { "caddy_fmt" },
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
