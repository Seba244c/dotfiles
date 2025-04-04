return {
	"rcarriga/nvim-notify",
	config = function()
		vim.notify = require("notify")
		vim.keymap.set("n", "<Esc>", "<ESC>:noh<CR>:lua require('notify').dismiss()<CR>", { silent = true })

		require("notify").setup({
			background_colour = "#000000",
		})
	end,
}
