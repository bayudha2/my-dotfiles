return {
	"SmiteshP/nvim-navic",
	dependecies = {
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("nvim-navic").setup()
	end,
}
