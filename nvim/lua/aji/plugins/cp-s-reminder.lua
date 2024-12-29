return {
	dir = "~/.config/nvim/lua/my-plugins/s-reminder",
	config = function()
		require("my-plugins.s-reminder").setup(nil, { latitude = "-6.923530", longitude = "107.606360" })
	end,
}
