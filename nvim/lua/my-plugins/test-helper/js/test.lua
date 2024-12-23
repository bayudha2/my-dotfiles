local ts_utils = require("nvim-treesitter.ts_utils")

--- @return { describe: string|nil, test: string|nil, it: string|nil }
local function getDescAndTest()
	local node = ts_utils.get_node_at_cursor()
	local tmp = {}

	while node do
		if node:type() == "call_expression" then
			local fnNameNode = node:child(0)
			local argsNode = node:child(1)

			if fnNameNode and argsNode and argsNode:type() == "arguments" then
				local strArgNode = argsNode:child(1)

				if strArgNode and strArgNode:type() == "string" then
					local fnName = vim.treesitter.get_node_text(fnNameNode, 0)
					local strArgText = vim.treesitter.get_node_text(strArgNode, 0)

					if fnName == "describe" or fnName == "test" or fnName == "it" then
						tmp[fnName] = strArgText
					end
				end
			end
		end

		node = node:parent()
	end

	return tmp
end

return {
	--- @param cft string|nil
	--- @param fullPath string
	--- @param pm {
	---     go: string,
	---     javascript: string,
	--- }
	--- @return string, boolean
	getJSTestCmd = function(fullPath, cft, pm)
		local testBaseOnTestingFramework = getDescAndTest()
		local testAnnotation = ""
		local basePath = vim.fn.getcwd():gsub("([^%w])", "%%%1") .. "%/"
		local resultPath = fullPath:gsub(basePath, "")

		if cft == nil then
			return "No file type match", true
		end

		if
			#testBaseOnTestingFramework == 0
			and testBaseOnTestingFramework["test"] == nil
			and testBaseOnTestingFramework["it"] == nil
		then
			return "No test function found at the moment", true
		end

		if testBaseOnTestingFramework["describe"] then
			local frmtDesc = testBaseOnTestingFramework["describe"]:match("^'(.*)'$")
			testAnnotation = frmtDesc
		end

		if testBaseOnTestingFramework["test"] then
			local frmtTest = testBaseOnTestingFramework["test"]:match("^'(.*)'$")
			testAnnotation = testAnnotation .. " " .. frmtTest
		end

		if testBaseOnTestingFramework["it"] then
			local frmtIt = testBaseOnTestingFramework["it"]:match("^'(.*)'$")
			testAnnotation = testAnnotation .. " " .. frmtIt
		end

		local cpm = pm[cft]
		local testCmd = cpm .. " test -- " .. resultPath .. " -t=" .. '"' .. testAnnotation .. '"'

		return testCmd, false
	end,
}
