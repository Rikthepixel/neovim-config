--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufEnter",
		branch = "master",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		--- @diagnostic disable-next-line: missing-fields
		--- @type TS.CONF
		opts = {
			ensure_installed = {
				"html",
				"css",
				"lua",
				"luadoc",
				"vim",
				"vimdoc",
				"rust",
				"php",
				"phpdoc",
				"blade",
				"c",
				"c_sharp",
				"yaml",
				"json",
				"toml",
				"python",
				"gdscript",
				"tsx",
				"typescript",
				"javascript",
				"jsdoc",
				"astro",
				"svelte",
				"markdown",
				"markdown_inline",
				"gitattributes",
				"gitignore",
				"caddy",
				"ssh_config",
				"dockerfile",
				"terraform",
			},
			sync_install = false,
			highlight = {
				enable = true,
				use_languagetree = true,
			},
            additional_vim_regex_highlighting = false,
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-l>",
					node_incremental = "<C-l>",
					node_decremental = "<C-h>",
				},
			},
		},
	},
	{
		"jxnblk/vim-mdx-js",
		ft = "markdown.mdx",
	},
	{
		"isobit/vim-caddyfile",
		ft = { "Caddyfile" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},
}