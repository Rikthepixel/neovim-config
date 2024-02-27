local languages = {

	html = {},
	cssls = {},
	clangd = {},
	astro = {},
	jsonls = {},
	yamlls = {},
	jdtls = {},
	rust_analyzer = {},
	omnisharp = {},
	intelephense = {
		settings = {
			intelephense = {
				telemetry = {
					enabled = false,
				},
			},
		},
	},
	tailwindcss = {
		filetypes = {
			"aspnetcorerazor",
			"astro",
			"astro-markdown",
			"blade",
			"clojure",
			"django-html",
			"htmldjango",
			"edge",
			"eelixir",
			"elixir",
			"ejs",
			"erb",
			"eruby",
			"gohtml",
			"haml",
			"handlebars",
			"hbs",
			"html",
			"html-eex",
			"heex",
			"jade",
			"leaf",
			"liquid",
			"markdown",
			"mdx",
			"markdown.mdx",
			"mustache",
			"njk",
			"nunjucks",
			"php",
			"razor",
			"slim",
			"twig",
			"css",
			"less",
			"postcss",
			"sass",
			"scss",
			"stylus",
			"sugarss",
			"javascript",
			"javascriptreact",
			"reason",
			"rescript",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		init_options = {
			userLanguages = {
				eelixir = "html-eex",
				eruby = "erb",
				mdx = "markdown.mdx",
				["markdown.mdx"] = "markdown.mdx",
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
}

local highlights = {
	"lua",
	"tsx",
	"typescript",
	"javascript",
	"jsdoc",
	"html",
	"css",
	"c_sharp",
	"dockerfile",
	"gitattributes",
	"gitignore",
}

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "[E]rror" })
vim.keymap.set("n", "<leader>el", vim.diagnostic.setloclist, { desc = "[E]rror [L]ist" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev [D]efinition" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [D]efinition" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Search
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]o to [D]eclaration", buffer = ev.buf })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]o to [D]efinition", buffer = ev.buf })
		vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, { desc = "[G]o to [T]ype [D]efinition", buffer = ev.buf })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "[G]o to [R]eference", buffer = ev.buf })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "[G]o to [I]mplementation", buffer = ev.buf })

		-- signatures and typing
		vim.keymap.set("n", "<leader>t", vim.lsp.buf.hover, { desc = "[T]ype", buffer = ev.buf })
		vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, { desc = "[S]ignature", buffer = ev.buf })

		-- Workspaces
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[W]orkspace [A]dd", buffer = ev.buf })
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "[W]orkspace [R]emove", buffer = ev.buf })
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workLeader_folders()))
		end, { desc = "[W]orkspace [L]ist", buffer = ev.buf })

		-- Actions
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[N]ame", buffer = ev.buf })
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions", buffer = ev.buf })
	end,
})

return {
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(languages),
				automatic_installation = true,
			})

			require("rikthepixel.utils.mason").install_missing("typescript-language-server")

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

			for name, config in pairs(languages) do
				lspconfig[name].setup(vim.tbl_extend("force", {
					capabilities = capabilities,
				}, config))
			end
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip", opts = {}, version = "v2.*" },
			{ "windwp/nvim-autopairs", opts = {} },
			"onsails/lspkind.nvim",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"neovim/nvim-lspconfig",
		},
		opts = function()
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			return {
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
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
				}, {
					{ name = "buffer" },
				}),
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufEnter",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = highlights,
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
		},
		build = ":TSUpdate",
	},
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
}