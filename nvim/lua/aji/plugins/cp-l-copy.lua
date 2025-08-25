return {
	dir = "~/.config/nvim/lua/my-plugins/l-copy",
	config = function()
		require("my-plugins.l-copy").setup()
	end,
}
