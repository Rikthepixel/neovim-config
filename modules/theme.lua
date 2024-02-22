return {
    {
        "catppuccin/nvim",
        name = "catppuccin", 
        priority = 1000,
        lazy = false,
        opts = {
            no_italic = true,
            integration = {
                mason = true
            }
        },
        config = function(_,opts)
            require("catppuccin").setup(opts)
            vim.cmd([[colorscheme catppuccin-mocha]])
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        -- Lualine theme configured by Catppuccin
        opts = { },
        dependencies = { 
            { "nvim-tree/nvim-web-devicons", lazy = false }
        }
    }
}