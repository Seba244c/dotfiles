return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<c-h>",  "<cmd><C-S>TmuxNavigateLeft<cr>" },
        { "<c-j>",  "<cmd><C-S>TmuxNavigateDown<cr>" },
        { "<c-k>",  "<cmd><C-S>TmuxNavigateUp<cr>" },
        { "<c-l>",  "<cmd><C-S>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-S>TmuxNavigatePrevious<cr>" },
    },
}
