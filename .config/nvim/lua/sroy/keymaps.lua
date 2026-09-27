local map = vim.keymap.set
local opts = { noremap = true, silent = true }

--General
map("n", "<Esc>",":nohlsearch<CR>",opts)
map("n", "<leader>fs", ":w<CR>", { desc = "Save file" })
map("n", "<leader>fq", ":q<CR>", { desc = "Quit" })
map("n", "<leader>fQ", ":qa!<CR>", { desc = "Quit all" })

--Better movement
-- Visual line movement when line wraps
map("n", "j","gj", opts)
map("n", "k","gk", opts)
map("v", "j","gj", opts)
map("v", "k","gk", opts)

-- Center screen on jumps
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Stay in visual mode after indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Paste without overwriting register
map("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

-- System clipboard
map("n", "<leader>y", '"+y',{ desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y',{ desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y',{ desc = "Yank line to clipboard" })

-- Delete to void register
map("n", "<leader>d", '"_d',{ desc = "Delete to void" })
map("v", "<leader>d", '"_d',{ desc = "Delete to void" })

--window / split
map("n", "<C-h>", "<C-w>h",opts)
map("n", "<C-j>", "<C-w>j",opts)
map("n", "<C-k>", "<C-w>k",opts)
map("n", "<C-l>", "<C-w>l",opts)
map("n", "<leader>sv",":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh",":split<CR>",{ desc = "Horizontal split" })
map("n", "<leader>sx",":close<CR>",{ desc = "Close split" })
map("n", "<leader>so","<C-w>o",{ desc = "Close other splits" })
map("n", "<leader>s=","<C-w>=",{ desc = "Equal split sizes" })

-- Resize splits with arrows
map("n", "<C-Up>", ":resize +2<CR>",opts)
map("n", "<C-Down>", ":resize -2<CR>",opts)
map("n", "<C-Left>", ":vertical resize +2<CR>", opts)
map("n", "<C-Right>",":vertical resize -2<CR>", opts)

--Buffer
map("n", "<leader>bb",":b #<CR>", { desc = "Switch to last buffer" })
map("n", "<leader>bn",":bnext<CR>",{ desc = "Next buffer" })
map("n", "<leader>bp",":bprev<CR>",{ desc = "Previous buffer" })
map("n", "<leader>bd",":bdelete<CR>",{ desc = "Delete buffer" })
map("n", "<leader>bD",":bdelete!<CR>", { desc = "Force delete buffer" })
map("n", "<leader>bo",":%bdelete|edit #<CR>",{ desc = "Close other buffers" })

-- Tab
map("n", "<leader>tn",":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc",":tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>to",":tabonly<CR>",{ desc = "Close other tabs" })
map("n", "<leader>tp",":tabprev<CR>",{ desc = "Previous tab" })
map("n", "<leader>tl",":tabnext<CR>",{ desc = "Next tab" })
map("n", "<leader>tf",":tabnew %<CR>", { desc = "Open current file in new tab" })

-- tab completion (for native LSP completion popup)
map("i", "<Tab>", function()
if vim.fn.pumvisible() == 1 then return "<C-n>" end
return "<Tab>"
end, { expr = true })

map("i", "<S-Tab>", function()
if vim.fn.pumvisible() == 1 then return "<C-p>" end
return "<S-Tab>"
end, { expr = true })

-- misc
-- Toggle quickfix
map("n", "<leader>q", function()
local qf = vim.fn.getwininfo()
for _, w in pairs(qf) do
if w.quickfix == 1 then vim.cmd.cclose(); return end
end
vim.cmd.copen()
end, { desc = "Toggle quickfix" })

-- Source current file
map("n", "<leader>xs", ":source %<CR>", { desc = "Source current file" })
