local function toggle_file_mark()
    local harpoon = require("harpoon")
    local harpoon_list = harpoon:list()
    local original_length = harpoon_list:length()
    harpoon_list:append()
    if harpoon_list:length() ~= original_length then
        return
    end
    harpoon_list:remove()
    harpoon:sync()
end

local function toggle_quick_menu()
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list())
end


return {
    {
        'nvim-telescope/telescope.nvim',
        keys = {
            { "<leader>sf", function() require("telescope.builtin").find_files() end, desc = "[S]earch [F]iles" },
            { "<leader>sg", function() require("telescope.builtin").live_grep() end,  desc = "[S]earch [G]rep" },
            { "<leader>sr", function() require("telescope.builtin").git_files() end,  desc = "[S]earch [R]epository" },
        },
        cmd = { "Telescope" },
        tag = '0.1.5',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons"
        },
    },
    {
        'ThePrimeagen/harpoon',
        branch = "harpoon2",
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = {},
        keys = {
            { "<leader>fm", toggle_file_mark,                                desc = "[F]ile [M]ark" },
            { "<leader>fq", toggle_quick_menu,                               desc = "[F]ile [Q]uick menu" },
            { "<leader>fn", function() require("harpoon"):list():next() end, desc = "[F]ile [N]ext" },
            { "<leader>fp", function() require("harpoon"):list():prev() end, desc = "[F]ile [P]revious" },
        },
    }
}