require("vim-options")

function open_CS()
    --vim.api
    vim.cmd.edit(vim.fn.stdpath("config") .. "/cs.txt")
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

vim.api.nvim_create_user_command("CS", open_CS, {})

-- Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins" },
        { import = "plugins.code" },
    },
    dev = {
        path = "~/Dev",
        fallback = true,
    },
})
