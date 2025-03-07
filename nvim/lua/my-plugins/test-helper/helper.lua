local JS = require("my-plugins.test-helper.js.test")
local GO = require("my-plugins.test-helper.go.test")

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

local TestEnum = {
	javascript = {
		getNearbyTestCmd = JS.getJSNearbyTestCmd,
		getFileTestCmd = JS.getJSFileTestCmd,
		runTest = "npm run test\\n",
	},
	go = {
		getNearbyTestCmd = GO.getGoNearbyTestCmd,
		getFileTestCmd = GO.getGoFileTestCmd,
		runTest = "go test -timeout 30s -v ./... -cover\\n",
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

H.getCurrentFile = function()
	return vim.fn.expand("%:t")
end

H.checkFileType = function(self)
	local cft = self.getFileType()
	local baseFT = self.ft[cft]

	if baseFT then
		return baseFT
	end

	return nil
end

function H:getNearbyTestCmd()
	local fullPath = self.getFullPathFile()
	local currentFile = self.getCurrentFile()
	local cft = self:checkFileType()

	if cft == nil then
		return "[test-helper] No file type match", true
	end

	local pm = self.pm[cft]
	local res, err = TestEnum[cft].getNearbyTestCmd({ fullpath = fullPath, file = currentFile }, pm)

	return res, err
end

--- @return string, boolean
function H:getFileTestCmd()
	local fullPath = self.getFullPathFile()
	local currentFile = self.getCurrentFile()
	local cft = self:checkFileType()

	if cft == nil then
		return "[test-helper] No file type match", true
	end

	local pm = self.pm[cft]
	local res, err = TestEnum[cft].getFileTestCmd({ fullpath = fullPath }, pm)

	return res, err
end

function H:copyNearbyTestCmd()
	local res, err = self:getNearbyTestCmd()
	if err then
		print(res)
		return
	end

	vim.fn.setreg("+", res)
end

function H:runNearbyTestInVsplit()
	local res, err = self:getNearbyTestCmd()
	if err then
		print(res)
		return
	end

	vim.cmd("vsplit | terminal")
	local cmdTestSpesific = ":call jobsend(b:terminal_job_id, " .. "'" .. res .. "')"
	local cmdEnter = ':call jobsend(b:terminal_job_id, "\\n")'

	vim.cmd(cmdTestSpesific)
	vim.cmd(cmdEnter)
end

function H:runFileTestInVsplit()
	local res, err = self:getFileTestCmd()
	if err then
		print(res)
		return
	end

	vim.cmd("vsplit | terminal")
	local cmdTestSpesific = ":call jobsend(b:terminal_job_id, " .. "'" .. res .. "')"
	local cmdEnter = ':call jobsend(b:terminal_job_id, "\\n")'

	vim.cmd(cmdTestSpesific)
	vim.cmd(cmdEnter)
end

function H:runAllAvailableTestInVsplit()
	local cft = self:checkFileType()

	if cft == nil then
		return "[test-helper] No file type match", true
	end

	local cmdTestAllText = TestEnum[cft].runTest

	vim.cmd("vsplit | terminal")
	local cmdTestAll = ":call jobsend(b:terminal_job_id, " .. '"' .. cmdTestAllText .. '"' .. ")"
	vim.cmd(cmdTestAll)
end

return H
