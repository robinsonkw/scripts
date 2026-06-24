-- ~/.config/nvim/lua/config/keymaps.lua
local map = vim.keymap.set

-- General
map("n", "<leader><space>", ":nohlsearch<CR>", { silent = true })
map("n", "<leader>w", ":w<CR>", { silent = true })
map("n", "<leader>rn", ":set relativenumber!<CR>", { silent = true })

-- Window navigation & resize
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-Left>", ":vertical resize +3<CR>", { silent = true })
map("n", "<C-Right>", ":vertical resize -3<CR>", { silent = true })
map("n", "<C-Up>", ":resize +3<CR>", { silent = true })
map("n", "<C-Down>", ":resize -3<CR>", { silent = true })
