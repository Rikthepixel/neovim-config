return {
    {
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup({
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
            })

            vim.keymap.set("n", "<Leader>fd", vim.lsp.buf.format, { desc = "[F]ormat [D]ocument" })
        end
    }
}