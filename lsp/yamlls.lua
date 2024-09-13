return function()
	return {
		settings = {
			yaml = {
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = require("schemastore").json.schemas(),
			},
		},
	}
end
