local JS = require("my-plugins.test-helper.js.test")

local H = {
	pm = { -- package manager
		javascript = "npm",
		go = "go",
	},
	ft = { -- file type
		javascript = "javascript",
		typescript = "javascript",
		javascriptreact = "javascript",
		typescriptreact = "javascript",
		go = "go",
	},
}

--- @param infoPm {javascript: string|nil, go : string|nil}
function H:new(infoPm)
	local inc = {}
	setmetatable(inc, self)
	self.__index = self

	self.pm = {
		javascript = infoPm.javascript or self.pm.javascript,
		go = infoPm.go or self.pm.go,
	}

	return inc
end

H.getFileType = function()
	return vim.bo.filetype
end

H.getFullPathFile = function()
	return vim.fn.expand("%:p")
end

H.checkFileType = function(self)
	local cft = self.getFileType()
	local baseFT = self.ft[cft]

	if baseFT then
		return baseFT
	end

	return nil
end

-- 	-- TODO: create conditional base on file type
function H:getNearbyTestCmd()
	local fullPath = self.getFullPathFile()
	local cft = self:checkFileType()

	local resString, err = JS.getJSTestCmd(fullPath, cft, self.pm)
	if err then
		print(resString)
		return
	end

	return resString
end

function H:copyNearbyTestCmd()
	local testCmd = self:getNearbyTestCmd()
	vim.fn.setreg("+", testCmd)
end

function H:runNearbyTestInVsplit()
	local testCmd = self:getNearbyTestCmd()

	vim.cmd("vsplit | terminal")
	local cmdTestSpesific = ":call jobsend(b:terminal_job_id, " .. "'" .. testCmd .. "')"
	local cmdEnter = ':call jobsend(b:terminal_job_id, "\\n")'

	vim.cmd(cmdTestSpesific)
	vim.cmd(cmdEnter)
end

function H.runAllAvailableTestInVsplit()
	vim.cmd("vsplit | terminal")
	local cmdTestAll = ':call jobsend(b:terminal_job_id, "npm run test\\n")'
	vim.cmd(cmdTestAll)
end

return H
