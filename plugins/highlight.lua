local languages = require("languages")
local treesitter_ensure_installed = {}
local plugins = {}

for _, highlighter in pairs(languages.highlighters) do
	if type(highlighter) == "string" then
		table.insert(treesitter_ensure_installed, highlighter)
		goto continue
	end

	if type(highlighter.name) == "string" then
		table.insert(treesitter_ensure_installed, highlighter.name)
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
		"nvim-treesitter/nvim-treesitter",
		event = "BufEnter",
		main = "nvim-treesitter.configs",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = treesitter_ensure_installed,
				sync_install = false,
				highlight = {
					enable = true,
					use_languagetree = true,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-l>",
						node_incremental = "<C-l>",
						node_decremental = "<C-h>",
					},
				},
			})
		end,
		build = ":TSUpdate",
	},
    table.unpack(plugins)
}
