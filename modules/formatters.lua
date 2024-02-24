return {
    {
        "mhartington/formatter.nvim",
        dependencies = {
            "neovim/nvim-lspconfig"
        },
        opts = function()
            return {
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    lua = {
                        require("formatter.filetypes.lua").stylua,
                    },
                    ["*"] = {
                        require("formatter.filetypes.any").remove_trailing_whitespace
                    }
                }
            }
        end,
        keys = {
            { '<leader>fd', function() vim.lsp.buf.format { async = true } end, desc = "[F]ormat [D]ocument" }
        },
    }
}