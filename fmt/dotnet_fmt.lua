return function()
	local util = require("conform.util")

	--- @module "conform"
	--- @type conform.FileFormatterConfig
	return {
		meta = {
			description = "Dotnet standard formatter",
		},
		cwd = util.root_file(function(name)
			return name:match("%.csproj$") ~= nil or name:match("%.sln$") ~= nil
		end),
		command = "dotnet",
        stdin = false,
		args = function()
			return { "format", "--include", "$RELATIVE_FILEPATH" }
		end,
	}
end
