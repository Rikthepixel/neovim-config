local function harpoon_mark()
    local harpoon = require("harpoon")
    if not harpoon then return "" end

    local harpoon_list = harpoon:list()
    local display = harpoon_list.config.create_list_item(harpoon_list.config).value
    if display == nil or display == "" then
        return ""
    end

    for i = 1, harpoon_list:length() do
        if (harpoon_list:get(i).value == display) then
            return "󰙒 " .. i
        end
    end
    return ""
end

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        opts = {
            no_italic = true,
            integration = {
                mason = true,
                harpoon = true
            }
        },
        init = function()
            vim.cmd("colorscheme catppuccin-mocha")
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        -- Lualine theme configured by Catppuccin
        opts = {
            sections = {
                lualine_c = {
                    "filename",
                    harpoon_mark
                }
            }
        },
        dependencies = {
            { "nvim-tree/nvim-web-devicons" }
        }
    }
}