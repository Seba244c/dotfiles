local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Lua
                    null_ls.builtins.formatting.stylua,

                    -- C+++
                    null_ls.builtins.formatting.clang_format,

                    -- JS (Eslint and Prettier)
                    -- Python
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    -- Github Actions?
                    null_ls.builtins.diagnostics.actionlint,
                    -- Fish
                    null_ls.builtins.diagnostics.fish,
                    null_ls.builtins.formatting.fish_indent,
                    -- Yaml
                    null_ls.builtins.diagnostics.yamllint,
                },
                on_init = function(new_client, _)
                    new_client.offset_encoding = "utf-32"
                    new_client.offsetEncoding = "utf-32"
                end,
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format()
                            end,
                        })
                    end
                end,
            })

            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = nil,
                automatic_installation = true,
            })
        end,
    },
}
