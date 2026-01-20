local function harpoon_mark()
	if not package.loaded["harpoon"] then
		return ""
	end

	local harpoon_list = require("harpoon"):list()
	local display = harpoon_list.config.create_list_item(harpoon_list.config).value
	if display == nil or display == "" then
		return ""
	end

	for i = 1, harpoon_list:length() do
		if harpoon_list:get(i).value == display then
			return "󰙒 " .. i
		end
	end
	return ""
end

--- @module "lazy"
--- @type LazyPluginSpec[]
return {

	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		opts = {
			options = {
				theme = "catppuccin",
			},
			sections = {
				lualine_c = { "filename", harpoon_mark },
				lualine_x = {
					-- "copilot",
					"diagnostics",
					"diff",
					"filetype",
				},
			},
		},
		-- dependencies = { "AndreM222/copilot-lualine" },
	},
}
