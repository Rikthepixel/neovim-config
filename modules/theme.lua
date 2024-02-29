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

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		event = "BufEnter",
		opts = {
			no_italic = true,
			integration = {
				mason = true,
				harpoon = true,
			},
		},
		init = function()
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		-- Lualine theme configured by Catppuccin
		opts = {
			sections = {
				lualine_c = { "filename", harpoon_mark },
			},
		},
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
	},
}