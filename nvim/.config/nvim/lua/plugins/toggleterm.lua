return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup()
            vim.api.nvim_set_keymap(
                "n",
                "<C-d>",
                "<cmd>ToggleTerm direction=float<CR>",
                { noremap = true, silent = true }
            )
        end,
    },
    {},
}
