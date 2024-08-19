return function()
	local util = require("conform.util")

	---@type conform.FileFormatterConfig
	return {
		meta = {
			url = "https://standardjs.com",
			description = "Typescript Standard style guide, linter, and formatter.",
		},
		cwd = util.root_file({ ".editorconfig", "package.json" }),
		command = util.from_node_modules("ts-standard"),
		args = { "--fix", "--stdin" },
	}
end

