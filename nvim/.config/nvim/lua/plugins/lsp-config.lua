local servers = { "lua_ls", "pyright", "jsonls", "rust_analyzer", "clangd" }
local mason_install = { "lua_ls", "pyright", "jsonls", "rust_analyzer", "jdtls", "clangd" }

return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = mason_install,
            })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            for i, server in ipairs(servers) do
                if server == "clangd" then
                    lspconfig[server].setup({
                        name = "clangd",
                        cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
                        initialization_options = {
                            fallback_flags = { "-std=c++17" },
                        },
                    })
                elseif server == "lua_ls" then
                    lspconfig[server].setup({
                        settings = {
                            Lua = {
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                            },
                        },
                    })
                else
                    lspconfig[server].setup({})
                end
            end

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {})
            vim.keymap.set({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, {})
        end,
    },
}
