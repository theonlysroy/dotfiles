-- Alias
local map = vim.keymap.set
local default_opts = {
	noremap = true,
	silent = true
}

-- Better defaults
-- stay in visual mode after indent
map("v", "<", "<gv", default_opts)
map("v", ">", ">gv", default_opts)

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", default_opts)
map("v", "K", ":m '<-1<CR>gv=gv", default_opts)

-- Center screen on half-page jumps
map("n", "<C-d>", "<C-d>zz", default_opts)
map("n", "<C-u>", "<C-u>zz", default_opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", default_opts)
map("n", "<C-j>", "<C-w>j", default_opts)
map("n", "<C-k>", "<C-w>k", default_opts)
map("n", "<C-l>", "<C-w>l", default_opts)

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", default_opts)

-- Keep paste buffer when pasting over selection
map("x", "<leader>p", '"_dP', default_opts)

-- Buffer management
map("n", "<leader>bd", ":bdelete<CR>", default_opts)
map("n", "<leader>bn", ":bnext<CR>", default_opts)
map("n", "<leader>bp", ":bprev<CR>", default_opts)
