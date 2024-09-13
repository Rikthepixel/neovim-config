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
				gitsigns = true,
				cmp = true,
				treesitter = true,
			},
		},
		init = function()
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		opts = {
			options = {
				theme = "catppuccin",
			},
			sections = {
				lualine_c = { "filename", harpoon_mark },
			},
		},
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
	},
	{
		"felpafel/inlay-hint.nvim",
		event = "LspAttach",
		opts = {
			virt_text_pos = "inline",
		},
	},
	-- {
	-- 	"max397574/startup.nvim",
	-- 	lazy = false,
	-- 	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	-- 	opts = {
	-- 		header = {
	-- 			type = "text",
	-- 			oldfiles_directory = false,
	-- 			align = "center",
	-- 			fold_section = false,
	-- 			title = "Neovim",
	-- 			margin = 1,
	-- 			content = {
	-- 				"Hello world",
	-- 				"", -- If I delete this, I get the error.
	-- 			},
	-- 			highlight = "Normal",
	-- 			default_color = "",
	-- 			oldfiles_amount = 0,
	-- 		},
	-- 		parts = { "header" },
	-- 	},
	-- },
}
