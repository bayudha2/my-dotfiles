local M = {}

-- Setup function to define commands
function M.setup()
	local th = require("my-plugins.test-helper.core")
	th.setup({
		javascript = "npm",
	})

	local keymap = vim.keymap

	keymap.set("n", "<leader>ts", th.run_nearby_test, { desc = "run nearby test from cursor" }) -- run nearby test from cursor
	keymap.set("n", "<leader>ta", th.run_all_test, { desc = "run all available test" }) -- run all available test
	keymap.set("n", "<leader>tc", th.copy_nearby_test_command, { desc = "copy nearby test command" }) -- create nearby test command from cursor, and copy to clipboard
end

return M
