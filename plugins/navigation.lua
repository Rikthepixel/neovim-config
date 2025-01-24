local function toggle_file_mark(file_path)
	local harpoon = require("harpoon")
	local harpoon_list = harpoon:list()
	local search_item = harpoon_list.config.create_list_item(harpoon_list.config, file_path)

	for _, list_item in pairs(harpoon_list.items) do
		if list_item.value == search_item.value then
			harpoon_list:remove(search_item)
			return
		end
	end

	harpoon_list:add(search_item)
end

local function telescope_toggle_file_mark()
	local entry = require("telescope.actions.state").get_selected_entry()
	if not entry then
		return
	end

	local entry_text = entry[1]
	local _, colonIdx = string.find(entry_text, ":")
	if colonIdx then
		entry_text = string.sub(entry_text, 1, colonIdx - 1)
	end

	toggle_file_mark(entry_text)
end

local file_mark_goto_keys = {}
for i = 1, 10 do
	local num = i == 10 and 0 or i

	table.insert(file_mark_goto_keys, {
		"<leader>" .. num,
		function()
			require("harpoon"):list():select(i)
		end,
		desc = "Goto file mark " .. num,
	})
end

return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "VeryLazy",
		opts = {
			settings = {
				sync_on_ui_close = true,
				save_on_toggle = true,
			},
		},
		keys = vim.list_extend({
			{ "<leader>fm", toggle_file_mark, desc = "[F]ile [M]ark" },
			{
				"<leader>fq",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "[F]ile [Q]uick menu",
			},

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
		}, file_mark_goto_keys),
	},
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		version = "v1.3",
		keys = {
			{
				"<leader>sb",
				function()
                    require("nvim-tree.api").tree.toggle({ find_file = true })
				end,
				desc = "[S]earch [B]rowser",
			},
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{
				"antosha417/nvim-lsp-file-operations",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
			},
		},
		opts = {
			disable_netrw = true,
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			filters = {
				git_ignored = false,
				dotfiles = false,
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
					file_ignore_patterns = {
						"node_modules[\\/]",
						"%.git[\\/]",
						"package-lock.json$",
						"build[\\/]",
						"dist[\\/]",
						"obj[\\/]",
						"bin[\\/]",
					},
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