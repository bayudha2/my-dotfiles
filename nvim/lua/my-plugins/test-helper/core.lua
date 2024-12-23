local H = require("my-plugins.test-helper.helper")
local M = {}

--- @param info {javascript: string|nil, go: string|nil}
function M.setup(info)
	H:new(info)
end

-- Function to run nearby test from cursor
function M.run_nearby_test()
	H:runNearbyTestInVsplit()
end

-- Function to run all available test
function M.run_all_test()
	H:runAllAvailableTestInVsplit()
end

-- Function to create nearby test command from cursor, and copy to clipboard
function M.copy_nearby_test_command()
	H:copyNearbyTestCmd()
end

return M
