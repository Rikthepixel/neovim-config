local function toggle_file_mark(item)
	local harpoon = require("harpoon")
	local harpoon_list = harpoon:list()
	local original_length = harpoon_list:length()
	harpoon_list:append(item)
	if harpoon_list:length() ~= original_length then
		return
	end
	harpoon_list:remove(item)
	harpoon:sync()
end

local function telescope_toggle_file_mark()
	local entry = require("telescope.actions.state").get_selected_entry()
	if not entry then
		return
	end
	local harpoon = require("harpoon")
	local harpoon_list = harpoon:list()
	local entry_text = entry[1]
	local _, colonIdx = string.find(entry_text, ":")
	if colonIdx then
		entry_text = string.sub(entry_text, 1, colonIdx - 1)
	end

	local item = harpoon_list.config.create_list_item(harpoon_list.config, entry_text)

	toggle_file_mark(item)
end

local function toggle_quick_menu()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end

return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "<leader>fm", toggle_file_mark, desc = "[F]ile [M]ark" },
			{ "<leader>fq", toggle_quick_menu, desc = "[F]ile [Q]uick menu" },
			{
				"<leader>fn",
				function()
					require("harpoon"):list():next()
				end,
				desc = "[F]ile [N]ext",
			},
			{
				"<leader>fp",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "[F]ile [P]revious",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{
				"<leader>sf",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "[S]earch [F]iles",
			},
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "[S]earch [G]rep",
			},
			{
				"<leader>sr",
				function()
					require("telescope.builtin").git_files()
				end,
				desc = "[S]earch [R]epository",
			},
		},
		cmd = { "Telescope" },
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			return {
				defaults = {
					vimgrep_arguments = {
						"rg",
						"-L",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--path-separator",
						"/",
					},
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "  ",
					initial_mode = "insert",
					layout_config = {
						horizontal = {
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					file_ignore_patterns = { "node_modules[\\/]", "%.git[\\/]", "package-lock.json$", "build[\\/]", "dist[\\/]", "obj[\\/]", "bin[\\/]" },
					path_display = { "truncate" },
					mappings = {
						n = {
							["q"] = require("telescope.actions").close,
							["<leader>fm"] = telescope_toggle_file_mark,
						},
						i = {
							["<C-f>"] = telescope_toggle_file_mark,
						},
					},
				},
			}
		end,
	},
}