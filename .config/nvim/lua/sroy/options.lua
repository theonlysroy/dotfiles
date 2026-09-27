-- set leader before keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- EDITOR configs
local o = vim.opt

o.number         = true       -- absolute line number on current line
o.relativenumber = true       -- relative numbers on other lines
o.signcolumn     = "yes"      -- always show sign column (prevents jump)
o.cursorline     = false       -- highlight current line
o.termguicolors  = true       -- true color support
o.showmatch      = true       -- highlight matching bracket
o.matchtime      = 1          -- bracket match blink duration (tenths)
o.scrolloff      = 8          -- min lines above/below cursor
o.sidescrolloff  = 8          -- min columns left/right of cursor
o.wrap           = false      -- no line wrapping
o.colorcolumn    = "120"      -- ruler at column 120
o.splitright     = true       -- vertical split goes right
o.splitbelow     = true       -- horizontal split goes below
o.laststatus     = 3          -- global statusline

--  Indentation (2 spaces)
o.tabstop     = 2
o.shiftwidth  = 2
o.softtabstop = 2
o.expandtab   = true
o.smartindent = true

--  search
o.ignorecase  = true          -- case-insensitive by default
o.smartcase   = true          -- uppercase in query = case-sensitive
o.hlsearch    = false         -- no persistent highlight on search
o.incsearch   = true          -- incremental search

--  performance
o.updatetime    = 250         -- faster CursorHold
o.timeoutlen    = 300         -- key sequence timeout (ms)
o.lazyredraw    = true        -- don't redraw during macros
o.synmaxcol     = 200         -- syntax highlighting column limit
o.undofile      = true        -- persistent undo across sessions
o.swapfile      = false       -- no swap files
o.backup        = false       -- no backup files
o.writebackup   = false       -- no write backup
o.shortmess:append("I")      -- no intro message
o.shortmess:append("c")      -- no completion messages

--  clipboard
o.clipboard = "unnamedplus"   -- system clipboard as default register

--  disable built-in file explorer
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
