local mason_utils = require("rikthepixel.utils.mason")

return {
	{
		"mhartington/formatter.nvim",
		lazy = false,
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
						require("formatter.filetypes.javascript").prettierd,
					},
					javascriptreact = {
						require("formatter.filetypes.javascriptreact").prettierd,
					},
					typescript = {
						require("formatter.filetypes.typescript").prettierd,
					},
					typescriptreact = {
						require("formatter.filetypes.typescriptreact").prettierd,
					},
				},
			}
		end,
		keys = {
			{ "<leader>fd", "<CMD>:Format<CR>", desc = "[F]ormat [D]ocument" },
		},
	},
}