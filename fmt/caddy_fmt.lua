return function()
	--- @module "conform"
	--- @type conform.FileFormatterConfig
	return {
		meta = { description = "Caddy formatter" },
		command = "caddy",
		stdin = true,
		args = { "fmt", "-" },
	}
end
