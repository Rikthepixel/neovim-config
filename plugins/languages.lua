local languages = require("languages")

local plugins = {}
local mason_ensure_installed = {}
local treesitter_ensure_installed = {}

-- Installs required plugins according to Language Servers and Highlighters
for _, language_server in pairs(languages.language_servers) do
	if type(language_server) == "string" then
		goto continue
	end

	for _, plugin in pairs(language_server.plugins or {}) do
		table.insert(plugins, plugin)
	end
	for _, mason in pairs(language_server.mason or {}) do
		table.insert(mason_ensure_installed, mason)
	end

	::continue::
end

for _, highlighter in pairs(languages.highlighters) do
	if type(highlighter) == "string" then
		table.insert(treesitter_ensure_installed, highlighter)
		goto continue
	end

	if type(highlighter.name) == "string" then
		table.insert(treesitter_ensure_installed, highlighter.name)
	end

	for _, plugin in pairs(highlighter.plugins or {}) do
		table.insert(plugins, plugin)
	end
	for _, mason in pairs(highlighter.mason or {}) do
		table.insert(mason_ensure_installed, mason)
	end

	::continue::
end

return {
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"Hoffs/omnisharp-extended-lsp.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			local ensure_installed = {}

			for _, language in pairs(languages.language_servers) do
				if type(language) == "string" then
					table.insert(ensure_installed, language)
				elseif type(language.name) == "string" then
					table.insert(ensure_installed, language.name)
				end
			end

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_installation = true,
			})
			require("utils.mason").install_missing(table.unpack(mason_ensure_installed))

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

			for _, language in pairs(languages.language_servers) do
				local config = { capabilities = capabilities }

				if type(language) == "string" then
					lspconfig[language].setup(config)
					goto continue
				end

				if type(language.config) == "table" then
					config = vim.tbl_extend("force", config, language.config or {})
				elseif type(language.config) == "function" then
					config = vim.tbl_extend("force", config, language.config() or {})
				end

				if not language.name then
					goto continue
				end

				lspconfig[language.name].setup(config)

				::continue::
			end

			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "[E]rror" })
			vim.keymap.set("n", "<leader>el", vim.diagnostic.setloclist, { desc = "[E]rror [L]ist" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev [D]efinition" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next [D]efinition" })

			vim.g.inlay_hints = false
			vim.keymap.set("n", "<leader>th", function()
				vim.g.inlay_hints = not vim.g.inlay_hints
				for _, client in ipairs(vim.lsp.get_clients()) do
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(vim.g.inlay_hints)
					end
				end
			end, { desc = "[T]oggle [H]ints" })

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
					vim.keymap.set(
						"n",
						"<leader>wr",
						vim.lsp.buf.remove_workspace_folder,
						{ desc = "[W]orkspace [R]emove", buffer = ev.buf }
					)
					vim.keymap.set("n", "<leader>wl", function()
						vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, { desc = "[W]orkspace [L]ist", buffer = ev.buf })

					-- Actions
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[N]ame", buffer = ev.buf })
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions", buffer = ev.buf })

					for _, client in ipairs(vim.lsp.get_clients()) do
						if client.name == "omnisharp" then
							local omnisharp_extended = require("omnisharp_extended")
							vim.keymap.set("n", "gr", omnisharp_extended.lsp_references, { desc = "[G]o to [R]eference", buffer = ev.buf })
							vim.keymap.set(
								"n",
								"gi",
								omnisharp_extended.lsp_implementation,
								{ desc = "[G]o to [I]mplementation", buffer = ev.buf }
							)
							vim.keymap.set("n", "gd", omnisharp_extended.lsp_definition, { desc = "[G]o to [D]efinition", buffer = ev.buf })
							break
						end
					end
				end,
			})
		end,
	},
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
		opts = function()
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
			table.remove({}, 2)

			--- @module "cmp"
			--- @type cmp.ConfigSchema
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
				---@diagnostic disable-next-line: missing-fields
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
					{ name = "lazydev" },
				}, {
					{ name = "buffer" },
				}),
				experimental = {
					ghost_text = true,
				},
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufEnter",
		main = "nvim-treesitter.configs",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = treesitter_ensure_installed,
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
	table.unpack(plugins),
}
