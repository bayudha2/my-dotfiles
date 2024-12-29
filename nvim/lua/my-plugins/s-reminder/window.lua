local M = {}

M.create_floating_window = function()
	local width = 16
	local height = 1

	-- position
	local col = vim.o.columns - 25
	local row = 1

	local buf = vim.api.nvim_create_buf(false, true)
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	-- create floating window
	local win = vim.api.nvim_open_win(buf, false, win_config)
	return { buf = buf, win = win }
end

return M
