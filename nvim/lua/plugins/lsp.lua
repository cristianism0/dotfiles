return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
    },

    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client:supports_method("textDocument/completion") then
                    vim.lsp.completion.enable(true, client.id)
                end
            end,
        })

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "clangd",
                "ruff",
                "basedpyright",
                "gopls"
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    })
                end,

                ["clangd"] = function()
                    require("lspconfig").clangd.setup({
                        -- cmd = { "clangd", "--all-scopes-completion" }
                    })
                end,
            }
        })

        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = "Open Autocomplete" })
        vim.keymap.set('i', '<C-y>', function()
            if vim.fn.pumvisible() ~= 0 then
                return '<C-y>'
            else
                return '<C-y>'
            end
        end, { expr = true })
    end
}
