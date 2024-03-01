local formatter_utils = require("rikthepixel.utils.formatter")
local mason_utils = require("rikthepixel.utils.mason")
local node_utils = require("rikthepixel.utils.node")

local function make_js_formatters(flavor)
	return formatter_utils.make_switch(require("formatter.filetypes." .. flavor).prettierd, {
		{
			function()
				return node_utils.includes_some_packages("prettier", "prettierd")
			end,
			require("formatter.filetypes." .. flavor).prettierd,
		},
		{
			function()
				return node_utils.includes_some_packages("standard")
			end,
			require("formatter.filetypes." .. flavor).standard,
		},
		{
			function()
				return node_utils.includes_some_packages("ts-standard")
			end,
			function()
				return {
					exe = "ts-standard",
					args = { "--stdin", "--fix" },
					stdin = true,
					try_node_modules = true,
				}
			end,
		},
	})
end

return {
	{
		"mhartington/formatter.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		opts = function()
			mason_utils.install_missing("prettierd", "stylua")

			return {
				logging = true,
				log_level = vim.log.levels.ERROR,
				filetype = {
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					javascript = {
						make_js_formatters("javascript"),
					},
					javascriptreact = {
						make_js_formatters("javascriptreact"),
					},
					typescript = {
						make_js_formatters("typescript"),
					},
					typescriptreact = {
						make_js_formatters("typescriptreact"),
					},
                    cs = {
                        require("formatter.filetypes.cs").dotnetformat
                    }
				},
			}
		end,
		keys = {
			{ "<leader>fd", "<CMD>:Format<CR>", desc = "[F]ormat [D]ocument" },
		},
	},
}