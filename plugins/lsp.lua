local languages = require("languages")

local plugins = {}
local mason_ensure_installed = {}

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
	if type(highlighter) ~= "table" then
		goto continue
	end

	for _, plugin in pairs(highlighter.plugins or {}) do
		table.insert(plugins, plugin)
	end

	::continue::
end

--- @module "lazy"
--- @type LazyPluginSpec[]
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
	table.unpack(plugins),
}
