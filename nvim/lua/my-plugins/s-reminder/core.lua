local W = require("my-plugins.s-reminder.window")
local M = {
	filename = "schedule.txt",
	loc = {
		longitude = nil,
		latitude = nil,
	},
}

--- @param prayName string
--- @param prayTime string
function M:createPrayReminder(prayName, prayTime)
	local ct = os.date("*t")
	local phtime, pmtime = prayTime:match("([^:]+):([^:]+)")

	local ctOnMinute = (ct.hour * 60) + ct.min
	local ptimeOnMinute = (tonumber(phtime) * 60) + tonumber(pmtime)
	local remainingTimeOnMinute = ptimeOnMinute - ctOnMinute

	if remainingTimeOnMinute < 0 then
		return
	end

	-- reminder exact pray time
	vim.defer_fn(function()
		self.start_presentation("      " .. prayName, 300)
	end, remainingTimeOnMinute * 60 * 1000)

	if remainingTimeOnMinute - 5 < 0 then
		return
	end

	-- reminder -5 minutes of pray time
	vim.defer_fn(function()
		self.start_presentation(prayName .. " on 5 mins", 299)
	end, (remainingTimeOnMinute - 5) * 60 * 1000)
end

-- will run on next day, if user online till next day (mid night 00:01)
function M:reschedulePrayTime()
	local ct = os.date("*t")
	local midnightOnMinute = (24 * 60) + 1 -- +1 minute for 00:01
	local ctOnMinute = (ct.hour * 60) + ct.min
	local timeTillRescheduleOnMinute = midnightOnMinute - ctOnMinute

	vim.defer_fn(function()
		self:setupReminder(self.filename, self.loc)
	end, timeTillRescheduleOnMinute * 60 * 1000)
end

--- @param filename string|nil name of the file
--- @param loc { longitude: string | nil, latitude: string | nil} | nil location table with longitude, latitude value (required)
function M:setupReminder(filename, loc)
	local locErrMessage =
		"[s-reminder] please set langitude and latitude of your current location, so reminder can be start."
	local locFinderURL = "[s-reminder] you can check you current location on https://www.latlong.net"

	if loc == nil then
		print(locErrMessage)
		print(locFinderURL)
		return
	end

	if loc.longitude == nil or loc.latitude == nil then
		print(locErrMessage)
		print(locFinderURL)
		return
	end

	self.filename = filename or self.filename
	self.loc = loc

	self:setupSchedule()
	self:reschedulePrayTime()
end

function M:setupSchedule()
	local infoSource = debug.getinfo(1, "S").source:sub(2)
	local pathSchedule = ""

	local fmtdSource = infoSource:match("(.*/)")
	pathSchedule = fmtdSource .. self.filename

	local file = io.open(pathSchedule, "r+")

	if file then
		local i = 1
		local scheduleT = {}

		-- read file
		for line in file:lines() do
			-- INFO: doesn't need to auto update loc, let user update the loc them self :)))

			if i == 1 and self.getCurrentDate() ~= line then -- if current schedule file date is not updated,
				local isFail, tPrayer = self:getScheduleToday()
				if isFail then
					print("[s-reminder] failed fetching schedule")
					return
				end

				file:seek("set", 0)
				file:write(self.getCurrentDate() .. "\n")
				for key, val in pairs(tPrayer) do
					file:write(key .. "=" .. val .. "\n")
				end

				file:close()

				self:setupSchedule() -- OPTIMIZE: wanted to avoid recrusive way, but for temporary way
				return
			end

			if i ~= 1 and type(line) == "string" then
				local key, val = line:match("([^=]+)=([^=]+)")
				scheduleT[key] = val
			end

			i = i + 1
		end

		for key, val in pairs(scheduleT) do
			self:createPrayReminder(key, val)
		end

		file:close()
	else -- if schedule file doesn't exist
		file = io.open(pathSchedule, "w+")
		if file then
			local isFail, tPrayer = self:getScheduleToday()
			if isFail then
				print("[s-reminder] failed fetching schedule")
				return
			end

			file:write(self.getCurrentDate() .. "\n")
			for key, val in pairs(tPrayer) do
				file:write(key .. "=" .. val .. "\n")
			end

			file:close()
		else
			print("[s-reminder] failed creating schedule")
		end
	end
end

--- @return boolean, table
function M:getScheduleToday()
	local cd = self.getCurrentDate()

	local handle = io.popen(
		"curl -s -w '%{http_code}' \"http://api.aladhan.com/v1/timings/"
			.. cd
			.. "?latitude="
			.. self.loc.latitude
			.. "&longitude="
			.. self.loc.longitude
			.. '"'
	)

	if handle ~= nil then
		local resp = handle:read("*all")
		handle:close()

		local statusCode = resp:sub(-3)
		if statusCode ~= "200" then
			return true, {}
		end

		local tPrayer = self.getPrayTimeFromJsonString(resp)

		return false, tPrayer
	end

	return true, {}
end

--- @return string
function M.getCurrentDate()
	local ct = os.date("*t")
	return ct.day .. "-" .. ct.month .. "-" .. ct.year
end

--- @param message string prayer namer e.g tzuhur, asr, magrhib
--- @param selfCloseTime integer self close timer on seconds
function M.start_presentation(message, selfCloseTime)
	local float = W.create_floating_window()
	vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, { message })

	vim.keymap.set("n", "<leader>gq", function()
		vim.api.nvim_win_close(float.win, true)
		pcall(vim.keymap.del, "n", "<leader>gq")
	end, { desc = "close window shalah reminder" })

	vim.defer_fn(function()
		if vim.api.nvim_win_is_valid(float.win) then
			vim.api.nvim_win_close(float.win, true)
			pcall(vim.keymap.del, "n", "<leader>gq")
		end
	end, selfCloseTime * 1000)
end

--- @param json string json string from respon data fetch
function M.getPrayTimeFromJsonString(json)
	local tPrayer = {}

	-- fajr
	local _, endIdxFajr = json:find('"Fajr":"')
	tPrayer["Fajr"] = json:sub(endIdxFajr + 1, endIdxFajr + 5)

	-- dhuhr
	local _, endIdxDhuhr = json:find('"Dhuhr":"')
	tPrayer["Dhuhr"] = json:sub(endIdxDhuhr + 1, endIdxDhuhr + 5)

	-- asr
	local _, endIdxAsr = json:find('"Asr":"')
	tPrayer["Asr"] = json:sub(endIdxAsr + 1, endIdxAsr + 5)

	-- maghrib
	local _, endIdxMaghrib = json:find('"Maghrib":"')
	tPrayer["Maghrib"] = json:sub(endIdxMaghrib + 1, endIdxMaghrib + 5)

	-- isha
	local _, endIdxIsha = json:find('"Isha":"')
	tPrayer["Isha"] = json:sub(endIdxIsha + 1, endIdxIsha + 5)

	return tPrayer
end

return M
