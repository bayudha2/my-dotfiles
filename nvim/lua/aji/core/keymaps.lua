vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search hightlights" })

-- vertical movement
keymap.set("n", "J", "5j", { desc = "Go down for 5 row"})
keymap.set("v", "J", "5j", { desc = "Go down for 5 row on visual mode"})
keymap.set("n", "K", "5k", { desc = "Go up for 5 row", remap = true })
keymap.set("v", "K", "5k", { desc = "Go up for 5 row on visual mode", remap = true })
keymap.set("n", "{", "{", { desc = "Go up to blank row and center view"})
keymap.set("n", "}", "}", { desc = "Go down to blank row and center view"})

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- Make splits equal size
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- Close current split

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- Open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- Close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) -- Go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) -- Go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) -- Open current buffer in new tab

keymap.set("n", "<leader>m1", "<cmd>tabn 1<CR>", { desc = "Jump to tab 1" }) -- Jump to tab 1  on current nvim
keymap.set("n", "<leader>m2", "<cmd>tabn 2<CR>", { desc = "Jump to tab 2" }) -- Jump to tab 2  on current nvim
keymap.set("n", "<leader>m3", "<cmd>tabn 3<CR>", { desc = "Jump to tab 3" }) -- Jump to tab 3  on current nvim
keymap.set("n", "<leader>m4", "<cmd>tabn 4<CR>", { desc = "Jump to tab 4" }) -- Jump to tab 4  on current nvim
keymap.set("n", "<leader>m5", "<cmd>tabn 5<CR>", { desc = "Jump to tab 5" }) -- Jump to tab 5  on current nvim
