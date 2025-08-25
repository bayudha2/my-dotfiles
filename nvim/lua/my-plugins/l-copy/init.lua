local M = {}

local keymap = vim.keymap

function M.setup()
	keymap.set(
		"v",
		"<leader>y",
		[[:<C-u>lua vim.schedule(function() require'my-plugins.l-copy.core'.yank_to_key(vim.fn.visualmode()) end)<CR>]],
		{ desc = "copy selected text", noremap = true }
	) -- lazy copy to a key char

	keymap.set(
		"n",
		"<leader>p",
		[[:<C-u>lua vim.schedule(function() require'my-plugins.l-copy.core'.paste_from_key() end)<CR>]],
		{ desc = "paste from stored copy", noremap = true }
	) -- paste from copied lazy
end

return M
