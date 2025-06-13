--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufEnter",
		main = "nvim-treesitter.configs",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"html",
					"css",
					"lua",
					"luadoc",
					"vim",
					"vimdoc",
					"rust",
					"php",
					"c",
					"c_sharp",
					"yaml",
					"json",
					"toml",
					"python",
					"tsx",
					"typescript",
					"javascript",
					"jsdoc",
					"astro",
					"markdown",
					"markdown_inline",
					"gitattributes",
					"gitignore",
					"ssh_config",
					"dockerfile",
				},
				sync_install = false,
				highlight = {
					enable = true,
					use_languagetree = true,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-l>",
						node_incremental = "<C-l>",
						node_decremental = "<C-h>",
					},
				},
			})
		end,
		build = ":TSUpdate",
	},
	{
		"jxnblk/vim-mdx-js",
		ft = "markdown.mdx",
	},
}
