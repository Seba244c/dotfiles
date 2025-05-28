return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
		vim.keymap.set("n", "<A-q>", ":Telescope buffers<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<C-q>", function()
			local bufnr = vim.api.nvim_get_current_buf()
			local buffers = vim.fn.getbufinfo({ buflisted = 1 })
			if #buffers > 1 then
				vim.cmd("bnext") -- go to next buffer
				vim.cmd("bd " .. bufnr) -- delete the previous buffer
			else
				vim.cmd("bd " .. bufnr)
			end
		end, { noremap = true, silent = true })
		require("bufferline").setup({
			options = {
				offsets = {
					{
						filetype = "neo-tree",
						text = "Files",
						highlight = "Directory",
						seperator = true,
					},
				},
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local sym = e == "error" and " " or (e == "warning" and " " or " ")
						s = s .. n .. sym
					end
					return s
				end,
			},
		})
	end,
}
