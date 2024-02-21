return {
    plugins = {
        {
            "catppuccin/nvim",
            name = "catppuccin", 
            priority = 1000,
            lazy = false,
            opts = {
                no_italic = true
            },
            config = function(plugin, opts)
                require("catppuccin").setup(opts)
                vim.cmd([[colorscheme catppuccin-mocha]])
            end
        }
    }
}