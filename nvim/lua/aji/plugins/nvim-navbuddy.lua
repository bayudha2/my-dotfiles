return {
	"SmiteshP/nvim-navbuddy",
	requires = {
		"neovim/nvim-lspconfig",
		"SmiteshP/nvim-navic",
		"MunifTanjim/nui.nvim",
		"numToStr/Comment.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		-- TODO: fill the NavicIcons color
		-- https://github.com/SmiteshP/nvim-navbuddy/issues/59
		vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = "#04b59b", fg = "#04b59b" })
		vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = "#04b59b", fg = "#04b59b" })
		vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = "#04b59b", fg = "#04b59b" })
		vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = "#ffe600", fg = "#ffe600" })
		vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = "#81c3dd", fg = "#81c3dd" })
		vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = "#81c3dd", fg = "#81c3dd" })
		vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = "#ffe600", fg = "#ffe600" })
		vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = "#81c3dd", fg = "#81c3dd" })
		vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = "#358bc1", fg = "#358bc1" })
		vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = "#d18441", fg = "#d18441" })
		vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = "#a8c59f", fg = "#a8c59f" })
    
		-- vim.api.nvim_set_hl(0, "NavicIconsFile",          {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsModule",        {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsPackage",       {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsConstructor",   {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsEnum",          {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsInterface",     {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsBoolean",       {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsArray",         {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsObject",        {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsKey",           {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsNull",          {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsEnumMember",    {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsEvent",         {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsOperator",      {default = true, bg = "#000000", fg = "#ffffff"})
		-- vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", {default = true, bg = "#000000", fg = "#ffffff"})

		-- File          = "󰈙 ",
		-- Module        = " ",
		-- Namespace     = "󰌗 ",
		-- Package       = " ",
		-- Class         = "󰌗 ",
		-- Method        = "󰆧 ",
		-- Property      = " ",
		-- Field         = " ",
		-- Constructor   = " ",
		-- Enum          = "󰕘",
		-- Interface     = "󰕘",
		-- Function      = "󰊕 ",
		-- Variable      = "󰆧 ",
		-- Constant      = "󰏿 ",
		-- String        = " ",
		-- Number        = "󰎠 ",
		-- Boolean       = "◩ ",
		-- Array         = "󰅪 ",
		-- Object        = "󰅩 ",
		-- Key           = "󰌋 ",
		-- Null          = "󰟢 ",
		-- EnumMember    = " ",
		-- Struct        = "󰌗 ",
		-- Event         = " ",
		-- Operator      = "󰆕 ",
		-- TypeParameter = "󰊄 "

		require("nvim-navbuddy").setup({
			window = {
				border = "rounded",
			},
			lsp = {
				auto_attach = true, -- If set to true, you don't need to manually use attach function
				preference = nil, -- list of lsp server names in order of preference
			},
			source_buffer = {
				follow_node = true, -- Keep the current node in focus on the source buffer
				highlight = true, -- Highlight the currently focused node
			},
		})

		vim.keymap.set("n", "<leader>nb", "<cmd>Navbuddy<CR>", { desc = "Open/toggle Navbuddy modal" }) -- open Navbuddy popup display
	end,
}
