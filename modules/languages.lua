local list_utils = require("rikthepixel.utils.list")

local languages = {
	html = {},
	cssls = {},
	clangd = {},
	astro = {},
	jsonls = {},
	yamlls = {},
	jdtls = {},
	rust_analyzer = {},
	omnisharp = require("rikthepixel.lsp.omnisharp"),
	intelephense = require("rikthepixel.lsp.intelephense"),
	tailwindcss = require("rikthepixel.lsp.tailwind"),
	lua_ls = require("rikthepixel.lsp.lua"),
    eslint = {}
}

local highlights = {
	"lua",
	"tsx",
	"typescript",
	"javascript",
	"jsdoc",
	"html",
	"css",
	"astro",
	"c_sharp",
	"php",
	"dockerfile",
	"gitattributes",
	"gitignore",
	"vim",
	"vimdoc",
	"ssh_config",
	"toml",
	"yaml",
    "json",
	"markdown",
	"markdown_inline",
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
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Pee[K] type", buffer = ev.buf })
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Pee[k] signature", buffer = ev.buf })

		-- Workspaces
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[W]orkspace [A]dd", buffer = ev.buf })
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "[W]orkspace [R]emove", buffer = ev.buf })
		vim.keymap.set("n", "<leader>wl", function()
			vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { desc = "[W]orkspace [L]ist", buffer = ev.buf })

		-- Actions
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[N]ame", buffer = ev.buf })
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions", buffer = ev.buf })

		local clients = vim.lsp.buf_get_clients()

		local has_omnisharp = list_utils.find(clients, function(client)
			return client.name == "omnisharp"
		end)

		if has_omnisharp then
			local omnisharp_extended = require("omnisharp_extended")
			vim.keymap.set("n", "gr", omnisharp_extended.lsp_references, { desc = "[G]o to [R]eference", buffer = ev.buf })
			vim.keymap.set("n", "gi", omnisharp_extended.lsp_implementation, { desc = "[G]o to [I]mplementation", buffer = ev.buf })
			vim.keymap.set("n", "gd", omnisharp_extended.lsp_definition, { desc = "[G]o to [D]efinition", buffer = ev.buf })
		end
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
			"Hoffs/omnisharp-extended-lsp.nvim",
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