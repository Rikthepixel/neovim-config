return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" , "require" },
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
