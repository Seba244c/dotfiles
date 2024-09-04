return {
	"Seba244c/run.nvim",
	dev = true,
	config = function()
		require("run").setup({})
		vim.keymap.set("n", "<F10>", ":Run<CR>")
	end,
}
