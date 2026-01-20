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

--- @module "lazy"
--- @type LazyPluginSpec[]
return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "BufEnter",
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
		version = "v1.15",
		keys = {
			{
				"<leader>fb",
				function()
					require("nvim-tree.api").tree.toggle({ find_file = true })
				end,
				desc = "[F]ind [B]rowser",
			},
		},

		opts = function()
			local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
			vim.api.nvim_create_autocmd("User", {
				pattern = "NvimTreeSetup",
				callback = function()
					local events = require("nvim-tree.api").events
					events.subscribe(events.Event.NodeRenamed, function(data)
						if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
							data = data
							Snacks.rename.on_rename_file(data.old_name, data.new_name)
						end
					end)
				end,
			})

			return {
				disable_netrw = true,
				actions = {
					open_file = { quit_on_open = true },
				},
				filesystem_watchers = {
					ignore_dirs = function(path)
						local ignored = {
							{ "node_modules", root = "package.json" },
							{ "vendor", root = "composer.json" },
							".git",
							"dist",
						}

						for _, ignore_dirs in ipairs(ignored) do
							ignore_dirs = type(ignore_dirs) == "table" and ignore_dirs or { ignore_dirs }

							local matched = false
							for _, dir in ipairs(ignore_dirs) do
								if vim.fn.match(path, dir) ~= -1 then
									matched = true
									break
								end
							end

							if type(ignore_dirs.root) ~= "string" or not matched then
								return matched
							end

							-- Check if root file exists in the directory
							local root_signature = vim.fs.joinpath(vim.fs.dirname(path), vim.fs.normalize(ignore_dirs.root))
							return not not vim.uv.fs_stat(root_signature)
						end
					end,
				},
				filters = {
					git_ignored = false,
					dotfiles = false,
				},
			}
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "[F]ind [F]iles",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "[F]ind [G]rep",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "[F]ind [R]esume",
			},
			{
				"<leader>fc",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "[F]ind [C]ursor",
			},
			{
				"<leader><leader>",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Find open buffers",
			},
		},
		cmd = { "Telescope" },
		version = "0.1.*",
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
