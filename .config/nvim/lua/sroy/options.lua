-- Local scope = applies only to current buffer/window when set
local o = vim.opt

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Line numbers
o.number = true
o.relativenumber = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = false

-- Appearance
o.signcolumn = "yes"
o.cursorline = false
o.scrolloff = 8
o.sidescrolloff = 8

-- Behavior
o.undofile = true            -- persistent undo
o.splitright = true
o.splitbelow = true
o.updatetime = 250
o.timeoutlen = 300
o.clipboard = "unnamedplus"  -- system clipboard
o.swapfile = false
o.backup = false

-- Netrw disable (we'll use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Default background transparent
vim.g.transparent_background = 1

-- Filetype detection
vim.filetype.add({
  filename = {
    ["Makefile"] = "make",
    ["Dockerfile"] = "dockerfile",
    ["go.work"] = "gowork",
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
  },
})
