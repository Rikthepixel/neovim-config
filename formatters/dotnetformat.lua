return function()
	local util = require("conform.util")

	---@type conform.FileFormatterConfig
	return {
		meta = {
			url = "https://standardjs.com",
			description = "Typescript Standard style guide, linter, and formatter.",
		},
		cwd = util.root_file(function(name)
			return name:match("%.csproj$") ~= nil or name:match("%.sln$") ~= nil
		end),
		command = "dotnet",
		args = { "format" },
	}
end
