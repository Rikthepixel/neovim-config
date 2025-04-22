return {
	settings = {
		Lua = {
			hint = { enable = true },
			runtime = { version = "LuaJIT" },
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					vim.api.nvim_get_runtime_file("", true),
				},
			},
		},
	},
}
