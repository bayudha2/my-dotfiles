local M = {}
local wd = require("my-plugins.s-reminder.core")

--- @param filename string name of the file
--- @param loc { longitude: string | nil, latitude: string | nil} | nil location table with longitude, latitude value (required)
function M.setup(filename, loc)
	wd:setupReminder(filename, loc)
end

return M
