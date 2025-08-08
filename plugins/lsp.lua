--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{ "Hoffs/omnisharp-extended-lsp.nvim", ft = { "csharp" } },
	{
		"mason-org/mason-lspconfig.nvim",
		event = "BufEnter",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
			"b0o/schemastore.nvim",
		},
		opts = function()
			local language_servers = {
				["tailwindcss"] = require("lsp.tailwind"),
				["lua_ls"] = require("lsp.lua"),
				["intelephense"] = require("lsp.intelephense"),
				["omnisharp"] = require("lsp.omnisharp"),
				["yamlls"] = require("lsp.yamlls"),
				["jsonls"] = require("lsp.jsonls"),
				["taplo"] = require("lsp.taplo"),
				"html",
				"cssls",
				"unocss",
				"clangd",
				"pyright",
				"eslint",
				"mdx_analyzer",
				"rust_analyzer",
				"astro",
				"ts_ls",
                "emmet_ls",
			}

			local ensure_installed = {}
			for server, config in pairs(language_servers) do
				if type(server) == "number" and type(config) == "string" then
					table.insert(ensure_installed, config)
				end
				if type(server) == "string" and (type(config) == "table" or type(config) == "function") then
					table.insert(ensure_installed, server)
					vim.lsp.config(server, type(config) == "function" and config() or config)
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local bufnr = ev.buf
					local opts = { buffer = bufnr }

					local map = vim.keymap.set

					map("n", "<leader>e", vim.diagnostic.open_float, opts)
					map("n", "<leader>el", vim.diagnostic.setloclist, opts)
					map("n", "[d", vim.diagnostic.goto_prev, opts)
					map("n", "]d", vim.diagnostic.goto_next, opts)

					map("n", "<leader>rn", vim.lsp.buf.rename, opts)
					map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

					map("n", "K", vim.lsp.buf.hover, opts)

					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.name == "omnisharp" then
						local omnisharp_extended = require("omnisharp_extended")

						map("n", "gr", omnisharp_extended.lsp_references, opts)
						map("n", "gi", omnisharp_extended.lsp_implementation, opts)
						map("n", "gd", omnisharp_extended.lsp_definition, opts)
					else
						map("n", "gr", vim.lsp.buf.references, opts)
						map("n", "gd", vim.lsp.buf.definition, opts)
					end
				end,
			})

			return {
				ensure_installed = ensure_installed,
			}
		end,
	},
}
