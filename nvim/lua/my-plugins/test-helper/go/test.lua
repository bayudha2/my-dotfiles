local ts_utils = require("nvim-treesitter.ts_utils")

--- @return string|nil
local function getTestName()
	local node = ts_utils.get_node_at_cursor()

	while node do
		if node:type() == "function_declaration" then
			local nodeText = vim.treesitter.get_node_text(node, 0)
			local funcName = nodeText:match("func%s([%w_]+)")

			if funcName and funcName:sub(1, 4):lower() == "test" then
				return funcName
			end
		end

		node = node:parent()
	end
end

return {
	--- @param path {
	---   fullpath: string,
	---   file: string,
	--- }
	--- @param pm string
	--- @return string, boolean
	getGoNearbyTestCmd = function(path, pm)
		local res = getTestName()
		local basePath = vim.fn.getcwd():gsub("([^%w])", "%%%1")
		local subFullwithBasePath = path.fullpath:gsub(basePath, "")
		local fmtdFile = path.file:gsub("([^%w])", "%%%1")
		local resPath = "." .. subFullwithBasePath:gsub(fmtdFile, "")

		if res == nil then
			return "[test-helper] No test function found at the moment", true
		end

		local testCmd = pm .. " test -timeout 15s -v -run " .. res .. " " .. resPath .. " -cover"
		-- .. " -coverprofile=cover.out"

		return testCmd, false
	end,
	--- @param path {
	---   fullpath: string,
	--- }
	--- @param pm string
	--- @return string, boolean
	getGoFileTestCmd = function(path, pm)
		local basePath = vim.fn.getcwd():gsub("([^%w])", "%%%1")
		local subFullwithBasePath = "." .. path.fullpath:gsub(basePath, ""):match("(.*/)")

		local testCmd = pm .. " test -timeout 15s -v " .. subFullwithBasePath .. " -cover"
		return testCmd, false
	end,
}
