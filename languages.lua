return {
	language_servers = {
		-- HTML
		"html",

		-- CSS
		"cssls",
		"unocss",
		{
			name = "tailwindcss",
			config = require("lsp.tailwind"),
		},

		-- LUA
		{
			name = "lua_ls",
			config = require("lsp.lua"),
		},

		-- RUST
		"rust_analyzer",

		-- PHP
		{
			name = "intelephense",
			config = require("lsp.intelephense"),
		},

		-- C
		"clangd",

		-- C#
		{
			name = "omnisharp",
			config = require("lsp.omnisharp"),
		},

		-- YAML/JSON/TOML
		{
			name = "yamlls",
			config = require("lsp.yamlls"),
		},
		{
			name = "jsonls",
			config = require("lsp.jsonls"),
		},
		{
			name = "taplo",
			config = require("lsp.taplo"),
		},

		-- PYTHON
		"pyright",

		-- JS
		{
			mason = { "typescript-language-server" },
			plugins = {
				{
					"pmizio/typescript-tools.nvim",
					dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
					ft = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
					opts = {
						settings = {
							jsx_close_tag = {
								enable = true,
							},
						},
					},
				},
			},
		},
		"eslint",

		-- MDX
		{
			name = "mdx_analyzer",
			config = function()
				vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
				vim.filetype.add({ extension = { mdx = "mdx" } })
			end,
		},

		-- ASTRO
		"astro",
	},
	highlighters = {
		-- HTML
		"html",

		-- CSS
		"css",

		-- LUA
		"lua",
		"luadoc",

		-- VIM
		"vim",
		"vimdoc",

		-- RUST
		"rust",

		-- PHP
		"php",

		-- C
		"c",

		-- C#
		"c_sharp",

		-- YAML/JSON/TOML
		"yaml",
		"json",
		"toml",

		-- PYTHON
		"python",

		-- JS
		"tsx",
		"typescript",
		"javascript",
		"jsdoc",

		-- ASTRO
		"astro",

		-- MARKDOWN/MDX
		"markdown",
		"markdown_inline",
		{
			plugins = {
				{
					"jxnblk/vim-mdx-js",
					ft = "markdown.mdx",
				},
			},
		},

		-- GIT
		"gitattributes",
		"gitignore",

		-- SSH
		"ssh_config",

		-- DOCKER
		"dockerfile",
	},
	copilot_completions = {
		"lua",
		"php",

		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",

		"markdown",
		"markdown.mdx",
		"astro",
	},
}
