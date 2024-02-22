local languages = {
    html = {},
    cssls = {},
    clangd = {},
    astro = {},
    jsonls = {},
    yamlls = {},
    jdtls = {},
    rust_analyzer = {},
    intelephense = {
        settings = {
            intelephense = {
                telemetry = {
                    enabled = false,
                },
            },
        },
    },
    tailwindcss = {
        filetypes = {
            "aspnetcorerazor",
            "astro",
            "astro-markdown",
            "blade",
            "clojure",
            "django-html",
            "htmldjango",
            "edge",
            "eelixir",
            "elixir",
            "ejs",
            "erb",
            "eruby",
            "gohtml",
            "haml",
            "handlebars",
            "hbs",
            "html",
            "html-eex",
            "heex",
            "jade",
            "leaf",
            "liquid",
            "markdown",
            "mdx",
            "markdown.mdx",
            "mustache",
            "njk",
            "nunjucks",
            "php",
            "razor",
            "slim",
            "twig",
            "css",
            "less",
            "postcss",
            "sass",
            "scss",
            "stylus",
            "sugarss",
            "javascript",
            "javascriptreact",
            "reason",
            "rescript",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
        },
        init_options = {
            userLanguages = {
                eelixir = "html-eex",
                eruby = "erb",
                mdx = "markdown.mdx",
                ["markdown.mdx"] = "markdown.mdx",
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false
                }
            }
        }
    }
}

local highlights = {
    "lua"
}

vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>el', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<Leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workLeader_folders()))
        end, opts)
        vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<Leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            {
                "williamboman/mason.nvim",
                init = function () 
                    -- add binaries installed by mason.nvim to path
                    local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
                    vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
                end
            },
            "williamboman/mason-lspconfig.nvim",
            "mhartington/formatter.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(languages),
                automatic_installation = true
            })

            local lspconfig = require("lspconfig")

            for name, config in pairs(languages) do
                lspconfig[name].setup(config)
            end
        end
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
        opts = {
            settings = {
                jsx_close_tag = {
                    enable = true,
                }
            }
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        opts = {
            ensure_installed = highlights
        }
    }
    
}