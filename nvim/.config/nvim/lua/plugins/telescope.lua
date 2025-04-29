return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-n>", builtin.git_files, {})
			vim.keymap.set("n", "<leader>fn", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

			vim.keymap.set("n", "<C-f>", builtin.lsp_document_symbols, {})
			vim.keymap.set("n", "<A-f>", builtin.lsp_dynamic_workspace_symbols, {})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"^jdt://",
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
