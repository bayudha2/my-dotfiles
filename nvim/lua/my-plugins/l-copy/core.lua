local M = {}
local copy_map = {}

--- @param mode string
M.yank_to_key = function(mode)
	local ok, char = pcall(vim.fn.getcharstr)
	if not ok or not char or #char ~= 1 then
		return
	end

	if char and #char == 1 then
		local _, line_start, column_start = unpack(vim.fn.getpos("'<"))
		local _, line_end, column_end = unpack(vim.fn.getpos("'>"))
		local lines = vim.fn.getline(line_start, line_end)

		if mode == "v" then
			if type(lines[#lines]) == "string" then
				lines[#lines] = string.sub(lines[#lines], 1, column_end)
				lines[1] = lines[1]:sub(column_start)
			end
		elseif mode == "\22" then
			if type(lines) == "table" then
				for i, value in ipairs(lines) do
					lines[i] = string.sub(value, 1, column_end)
					lines[i] = string.sub(value, column_start)
				end
			end
		end

		local copy_data = {}

		copy_data["data"] = lines
		copy_data["mode"] = mode

		copy_map[char] = copy_data
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

		print(vim.inspect(copy_map))
	end
end

local paste_mode = {
	V = "l",
	v = "c",
	["\22"] = "b",
}

M.paste_from_key = function()
	local ok, char = pcall(vim.fn.getcharstr)
	if not ok or not char or #char ~= 1 then
		return
	end

	local data = copy_map[char]
	if data and type(data) == "table" then
		-- INFO: paste base on the visual mode, (c, l, b, "")
		vim.api.nvim_put(data.data, paste_mode[data.mode], true, true)
	end
end

return M
