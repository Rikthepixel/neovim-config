return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
			{ "windwp/nvim-autopairs", opts = {} },
			"onsails/lspkind.nvim",
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"neovim/nvim-lspconfig",
			-- {
			-- 	dir = "~/Documents/Repositories/lokaal-copilot.nvim",
			-- 	name = "lokaal-copilot.nvim",
			-- 	--- @type lokaal_copilot.Config
			-- 	opts = {
			-- 		models = {
			-- 			reasoning = "gemma3:4b",
			-- 			coding = "deepseek-coder:6.7b",
			-- 		},
			-- 	},
			-- 	dependencies = { "nvim-lua/plenary.nvim" },
			-- },
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						"~/Documents/Repositories/lokaal-copilot.nvim",
						"LazyVim",
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			require("luasnip").config.setup({})
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip").filetype_extend("typescript", { "tsdoc" })
			require("luasnip").filetype_extend("javascript", { "jsdoc" })
			require("luasnip").filetype_extend("lua", { "luadoc" })
			require("luasnip").filetype_extend("php", { "phpdoc" })
			require("luasnip").filetype_extend("json", { "npm" })
			require("luasnip").filetype_extend("lua", { "lazydev" })
			local cmp_default_config = require("cmp.config.default")()

			--- @module "cmp"
			--- @type cmp.ConfigSchema
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				---@diagnostic disable-next-line: missing-fields
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
						symbol_map = {
							Copilot = "",
						},
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<A-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "luasnip" },
					{ name = "lazydev" },
				}, {
					{ name = "buffer" },
					-- { name = "lokaal-copilot" },
				}),
				sorting = {
					priority_weight = 2,
					comparators = {
						-- require("lokaal-copilot.integrations.cmp.compare"),
						table.unpack(cmp_default_config.sorting.comparators),
					},
				},
				experimental = {
					ghost_text = true,
				},
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "buffer" } }, { { name = "cmdline" } }),
				---@diagnostic disable-next-line: missing-fields
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}