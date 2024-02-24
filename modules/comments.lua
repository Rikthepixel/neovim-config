return {
    {
        'numToStr/Comment.nvim',
        keys = {
            {
                "<leader>/",
                function() require("Comment.api").toggle.linewise.current() end,
                desc = "Toggle comment line",
            },
            {
                "<leader>/",
                "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
                desc = "Toggle comment",
                mode = "v"
            }
        },
        opts = function()
            return {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }
        end,
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                config = function()
                    vim.g.skip_ts_context_commentstring_module = true
                    require('ts_context_commentstring').setup({ enable_autocmd = false, })
                end
            }
        }
    }
}