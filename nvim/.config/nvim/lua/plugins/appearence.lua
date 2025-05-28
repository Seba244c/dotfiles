return {
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
			vim.keymap.set("n", "<Esc>", "<ESC>:noh<CR>:lua require('notify').dismiss()<CR>", { silent = true })

			require("notify").setup({
				background_colour = "#000000",
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				transparent_background = true,
				integrations = {
					neotree = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
