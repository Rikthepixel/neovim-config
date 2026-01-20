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
			local ensure_installed = {}

			local function config_lsp(lsp_name, config)
				table.insert(ensure_installed, lsp_name)

				config = config or {}
				vim.lsp.config(lsp_name, type(config) == "function" and config() or config)
			end

			config_lsp("lua_ls", require("lsp.lua"))

			config_lsp("intelephense", require("lsp.intelephense"))
            config_lsp("laravel_ls")

			config_lsp("omnisharp", require("lsp.omnisharp"))
			config_lsp("clangd")
			config_lsp("pyright")
			config_lsp("rust_analyzer")

            -- Data formats
			config_lsp("yamlls", require("lsp.yamlls"))
			config_lsp("jsonls", require("lsp.jsonls"))
			config_lsp("taplo", require("lsp.taplo"))

            -- HTML/CSS
			config_lsp("html")
			config_lsp("cssls")
			config_lsp("unocss")
			config_lsp("tailwindcss", require("lsp.tailwind"))

            -- JS-related
			config_lsp("ts_ls")
			config_lsp("eslint", require("lsp.eslint"))
			config_lsp("mdx_analyzer")
			config_lsp("emmet_ls")
			config_lsp("astro")
			config_lsp("svelte")

            config_lsp("docker_language_server")
            config_lsp("docker_compose_language_service")
            config_lsp("terraformls")

			vim.lsp.config("gdscript", {})
			vim.lsp.enable("gdscript")

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

			return { ensure_installed = ensure_installed }
		end,
	},
}