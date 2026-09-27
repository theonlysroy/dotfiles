local map = vim.keymap.set

-- File explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })

-- Fuzzy finder (mini.pick)
map("n", "<leader>ff", ":Pick files<CR>", { silent = true, desc = "Find files" })
map("n", "<leader>fb", ":Pick buffers<CR>", { silent = true, desc = "Find buffers" })
map("n", "<leader>fg", ":Pick grep_live<CR>", { silent = true, desc = "Live grep" })

-- Buffers (IDE-style open/close/cycle)
map("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { silent = true, desc = "Close buffer" })

-- Tabs
map("n", "<leader>tn", ":tabnew<CR>", { silent = true, desc = "New tab" })
map("n", "<leader>tc", ":tabclose<CR>", { silent = true, desc = "Close tab" })
-- gt / gT already cycle tabs by default in Neovim — no remap needed.

-- Terminal (built-in :terminal, toggled bottom split)
local term_buf, term_win = nil, nil

local function toggle_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, false)
    term_win = nil
    return
  end
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd("botright 15split")
    term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    vim.cmd("botright 15split term://" .. vim.o.shell)
    term_win = vim.api.nvim_get_current_win()
    term_buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd("startinsert")
end

map("n", "<leader>tt", toggle_terminal, { desc = "Toggle terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- toggle transparency
map("n", "<leader>ub", ":ToggleTransparency<CR>", { desc = "Toggle background transparency" })

-- Go — basic commands
map("n", "<leader>gr", ":w<CR>:split | terminal go run %<CR>", { silent = true, desc = "Go run current file" })
map("n", "<leader>gb", ":w<CR>:split | terminal go build ./...<CR>", { silent = true, desc = "Go build" })
map("n", "<leader>gt", ":w<CR>:split | terminal go test ./...<CR>", { silent = true, desc = "Go test" })

-- Docker — basic build command
map("n", "<leader>db", ":split | terminal docker build -t $(basename $(pwd)) .<CR>",
  { silent = true, desc = "Docker build" })

-- focus between the editor and the explorer
map("n", "<leader>o", function()
  local view = require("nvim-tree.view")
  if view.is_visible() then
    if vim.bo.filetype == "NvimTree" then
      vim.cmd("wincmd p")
  else
    vim.cmd("NvimTreeFocus")
    end
  end
end,
  { desc = "Toggle focus between explorer and editor" }
)
