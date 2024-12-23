return {
	dir = "~/.config/nvim/lua/my-plugins/test-helper", -- Local plugin path
	config = function()
		require("my-plugins.test-helper").setup()
	end,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
}
