# Minimal Neovim setup - Go / Makefile / Dockerfile

## Requirements

- Neovim **0.11+** (for native LSP API)
- Git (for lazy.nvim)
- Go (for gopls)
- Node.js/npm (for docker-langserver)
- ripgrep (for Telescope live grep)

## Install LSP Servers

```bash
go install golang.org/x/tools/gopls@latest
npm install -g dockerfile-language-server-nodejs
```

## Directory Structure

```
~/.config/nvim/
├── init.lua
└── lua/
    └── user/
        ├── core/
        │   ├── options.lua      — vim options & performance
        │   ├── keymaps.lua      — global keybindings
        │   └── autocmds.lua     — autocommands
        ├── plugins/
        │   ├── init.lua         — lazy.nvim setup
        │   ├── colorscheme.lua  — tokyonight + transparent
        │   ├── explorer.lua     — nvim-tree
        │   └── fuzzy.lua        — telescope
        └── lsp/
            └── init.lua         — native LSP (gopls + dockerls)
```

---

## File: `init.lua`

```lua
-- ═══════════════════════════════════════════════════════════
--  BOOTSTRAP lazy.nvim
-- ═══════════════════════════════════════════════════════════
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ═══════════════════════════════════════════════════════════
--  LOAD MODULES
-- ═══════════════════════════════════════════════════════════
require("user.core.options")
require("user.core.keymaps")
require("user.core.autocmds")
require("user.lsp")
require("user.plugins.init")
```

---

## File: `lua/user/core/options.lua`

```lua
-- ═══════════════════════════════════════════════════════════
--  LEADER (must be set before keymaps)
-- ═══════════════════════════════════════════════════════════
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ═══════════════════════════════════════════════════════════
--  EDITOR
-- ═══════════════════════════════════════════════════════════
local opt = vim.opt

opt.number         = true       -- absolute line number on current line
opt.relativenumber = true       -- relative numbers on other lines
opt.signcolumn     = "yes"      -- always show sign column (prevents jump)
opt.cursorline     = true       -- highlight current line
opt.termguicolors  = true       -- true color support
opt.showmatch      = true       -- highlight matching bracket
opt.matchtime      = 1          -- bracket match blink duration (tenths)
opt.scrolloff      = 8          -- min lines above/below cursor
opt.sidescrolloff  = 8          -- min columns left/right of cursor
opt.wrap           = false      -- no line wrapping
opt.colorcolumn    = "120"      -- ruler at column 120
opt.splitright     = true       -- vertical split goes right
opt.splitbelow     = true       -- horizontal split goes below
opt.laststatus     = 3          -- global statusline

-- ═══════════════════════════════════════════════════════════
--  INDENTATION (2 spaces)
-- ═══════════════════════════════════════════════════════════
opt.tabstop     = 2
opt.shiftwidth  = 2
opt.softtabstop = 2
opt.expandtab   = true
opt.smartindent = true

-- ═══════════════════════════════════════════════════════════
--  SEARCH
-- ═══════════════════════════════════════════════════════════
opt.ignorecase  = true          -- case-insensitive by default
opt.smartcase   = true          -- uppercase in query = case-sensitive
opt.hlsearch    = false         -- no persistent highlight on search
opt.incsearch   = true          -- incremental search

-- ═══════════════════════════════════════════════════════════
--  PERFORMANCE
-- ═══════════════════════════════════════════════════════════
opt.updatetime    = 250         -- faster CursorHold
opt.timeoutlen    = 300         -- key sequence timeout (ms)
opt.lazyredraw    = true        -- don't redraw during macros
opt.synmaxcol     = 200         -- syntax highlighting column limit
opt.undofile      = true        -- persistent undo across sessions
opt.swapfile      = false       -- no swap files
opt.backup        = false       -- no backup files
opt.writebackup   = false       -- no write backup
opt.shortmess:append("I")      -- no intro message
opt.shortmess:append("c")      -- no completion messages

-- ═══════════════════════════════════════════════════════════
--  CLIPBOARD
-- ═══════════════════════════════════════════════════════════
opt.clipboard = "unnamedplus"   -- system clipboard as default register

-- ═══════════════════════════════════════════════════════════
--  DISABLE BUILT-IN FILE EXPLORER (we use nvim-tree)
-- ═══════════════════════════════════════════════════════════
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
```

---

## File: `lua/user/core/keymaps.lua`

```lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ═══════════════════════════════════════════════════════════
--  GENERAL
-- ═══════════════════════════════════════════════════════════
map("n", "<Esc>",        ":nohlsearch<CR>",                          opts)
map("n", "<leader>fs",   ":w<CR>",               { desc = "Save file" })
map("n", "<leader>fq",   ":q<CR>",               { desc = "Quit" })
map("n", "<leader>fQ",   ":qa!<CR>",             { desc = "Quit all" })

-- ═══════════════════════════════════════════════════════════
--  BETTER MOVEMENT
-- ═══════════════════════════════════════════════════════════
-- Visual line movement when line wraps
map("n", "j",  "gj", opts)
map("n", "k",  "gk", opts)
map("v", "j",  "gj", opts)
map("v", "k",  "gk", opts)

-- Center screen on jumps
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n",     "nzzzv",   opts)
map("n", "N",     "Nzzzv",   opts)

-- Stay in visual mode after indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Paste without overwriting register
map("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

-- System clipboard
map("n", "<leader>y", '"+y',  { desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y',  { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y',  { desc = "Yank line to clipboard" })

-- Delete to void register
map("n", "<leader>d", '"_d',  { desc = "Delete to void" })
map("v", "<leader>d", '"_d',  { desc = "Delete to void" })

-- ═══════════════════════════════════════════════════════════
--  WINDOW / SPLIT MANAGEMENT
-- ═══════════════════════════════════════════════════════════
map("n", "<C-h>",       "<C-w>h",                          opts)
map("n", "<C-j>",       "<C-w>j",                          opts)
map("n", "<C-k>",       "<C-w>k",                          opts)
map("n", "<C-l>",       "<C-w>l",                          opts)
map("n", "<leader>sv",  ":vsplit<CR>",   { desc = "Vertical split" })
map("n", "<leader>sh",  ":split<CR>",    { desc = "Horizontal split" })
map("n", "<leader>sx",  ":close<CR>",    { desc = "Close split" })
map("n", "<leader>so",  "<C-w>o",        { desc = "Close other splits" })
map("n", "<leader>s=",  "<C-w>=",        { desc = "Equal split sizes" })

-- Resize splits with arrows
map("n", "<C-Up>",     ":resize +2<CR>",          opts)
map("n", "<C-Down>",   ":resize -2<CR>",          opts)
map("n", "<C-Left>",   ":vertical resize +2<CR>", opts)
map("n", "<C-Right>",  ":vertical resize -2<CR>", opts)

-- ═══════════════════════════════════════════════════════════
--  BUFFER MANAGEMENT
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>bb",  ":b #<CR>",            { desc = "Switch to last buffer" })
map("n", "<leader>bn",  ":bnext<CR>",          { desc = "Next buffer" })
map("n", "<leader>bp",  ":bprev<CR>",          { desc = "Previous buffer" })
map("n", "<leader>bd",  ":bdelete<CR>",        { desc = "Delete buffer" })
map("n", "<leader>bD",  ":bdelete!<CR>",       { desc = "Force delete buffer" })
map("n", "<leader>bo",  ":%bdelete|edit #<CR>",{ desc = "Close other buffers" })

-- ═══════════════════════════════════════════════════════════
--  TAB MANAGEMENT
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>tn",  ":tabnew<CR>",     { desc = "New tab" })
map("n", "<leader>tc",  ":tabclose<CR>",   { desc = "Close tab" })
map("n", "<leader>to",  ":tabonly<CR>",    { desc = "Close other tabs" })
map("n", "<leader>tp",  ":tabprev<CR>",    { desc = "Previous tab" })
map("n", "<leader>tl",  ":tabnext<CR>",    { desc = "Next tab" })
map("n", "<leader>tf",  ":tabnew %<CR>",   { desc = "Open current file in new tab" })

-- ═══════════════════════════════════════════════════════════
--  TAB COMPLETION (for native LSP completion popup)
-- ═══════════════════════════════════════════════════════════
map("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then return "<C-n>" end
  return "<Tab>"
end, { expr = true })

map("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then return "<C-p>" end
  return "<S-Tab>"
end, { expr = true })

-- ═══════════════════════════════════════════════════════════
--  MISC
-- ═══════════════════════════════════════════════════════════
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
```

---

## File: `lua/user/core/autocmds.lua`

```lua
local api = vim.api
local augroup = function(name)
  return api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- ═══════════════════════════════════════════════════════════
--  HIGHLIGHT ON YANK
-- ═══════════════════════════════════════════════════════════
api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ═══════════════════════════════════════════════════════════
--  RESIZE SPLITS ON WINDOW RESIZE
-- ═══════════════════════════════════════════════════════════
api.nvim_create_autocmd("VimResized", {
  group = augroup("win_resize"),
  callback = function() vim.cmd.wincmd("=") end,
})

-- ═══════════════════════════════════════════════════════════
--  GO TO LAST POSITION ON REOPEN
-- ═══════════════════════════════════════════════════════════
api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- ═══════════════════════════════════════════════════════════
--  STRIP TRAILING WHITESPACE ON SAVE
-- ═══════════════════════════════════════════════════════════
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("strip_whitespace"),
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- ═══════════════════════════════════════════════════════════
--  AUTO-CREATE DIR ON SAVE
-- ═══════════════════════════════════════════════════════════
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- ═══════════════════════════════════════════════════════════
--  DOCKERFILE FILETYPE DETECTION
-- ═══════════════════════════════════════════════════════════
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("dockerfile_ft"),
  pattern = { "Dockerfile*", "*.dockerfile" },
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})
```

---

## File: `lua/user/plugins/init.lua`

```lua
require("lazy").setup({
  spec = {
    { import = "user.plugins.colorscheme" },
    { import = "user.plugins.explorer" },
    { import = "user.plugins.fuzzy" },
  },
  install = { colorscheme = { "tokyonight" } },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
```

---

## File: `lua/user/plugins/colorscheme.lua`

```lua
-- ═══════════════════════════════════════════════════════════
--  TRANSPARENT BACKGROUND TOGGLE
--  Set to true or false, or use :ToggleTransparent at runtime
-- ═══════════════════════════════════════════════════════════
local transparent = true

local function apply_transparent()
  if not transparent then return end

  local groups = {
    "Normal",        "NormalNC",     "NormalFloat",
    "FloatBorder",   "FloatTitle",
    "SignColumn",    "LineNr",       "EndOfBuffer",
    "WinSeparator",  "VertSplit",
    "StatusLine",    "StatusLineNC",
    "TabLine",       "TabLineFill",  "TabLineSel",
    "Pmenu",         "PmenuSbar",    "PmenuThumb",
    "CursorLine",    "CursorLineNr",
    "Folded",        "FoldColumn",
    "NonText",       "SpecialKey",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end

  -- Make float windows transparent
  vim.opt.winblend = 10
  vim.opt.pumblend = 10
end

local function revert_transparent()
  transparent = false
  vim.opt.winblend = 0
  vim.opt.pumblend = 0
  -- Re-apply colorscheme to reset highlights
  vim.cmd.colorscheme("tokyonight")
end

-- User command to toggle at runtime
vim.api.nvim_create_user_command("ToggleTransparent", function()
  transparent = not transparent
  if transparent then
    apply_transparent()
  else
    revert_transparent()
  end
end, { desc = "Toggle transparent background" })

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = transparent,
      styles = {
        sidebars = transparent and "transparent" or "solid",
        floats  = transparent and "transparent" or "solid",
      },
      on_highlights = function(hl, c)
        if transparent then
          hl.TelescopeNormal    = { bg = c.none }
          hl.TelescopeBorder    = { bg = c.none }
          hl.TelescopePromptNormal = { bg = c.none }
          hl.TelescopePromptBorder = { bg = c.none }
          hl.TelescopeResultsNormal = { bg = c.none }
          hl.TelescopePreviewNormal = { bg = c.none }
          hl.NvimTreeNormal    = { bg = c.none }
          hl.NvimTreeEndOfBuffer = { bg = c.none }
          hl.NvimTreeWinSeparator = { bg = c.none, fg = c.border }
        end
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
      -- Apply after colorscheme loads
      apply_transparent()
    end,
  },
}
```

---

## File: `lua/user/plugins/explorer.lua`

```lua
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = {
      { "<leader>e",  ":NvimTreeToggle<CR>",    desc = "Toggle explorer" },
      { "<leader>E",  ":NvimTreeFindFile<CR>",  desc = "Find current file" },
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Default keymaps first
        api.config.mappings.default_on_attach(bufnr)

        local function o(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        local map = vim.keymap.set

        -- ── Navigation ────────────────────────────
        map("n", "l",     api.node.open.edit,             o("Open"))
        map("n", "h",     api.node.navigate.parent_close,  o("Close parent"))
        map("n", "<CR>",  api.node.open.edit,             o("Open"))
        map("n", "<Tab>", api.node.open.preview,          o("Preview"))

        -- ── File ops ──────────────────────────────
        map("n", "a",     api.fs.create,                  o("Create"))
        map("n", "d",     api.fs.remove,                  o("Delete"))
        map("n", "r",     api.fs.rename,                  o("Rename"))
        map("n", "R",     api.fs.rename_sub,              o("Rename (sub)"))
        map("n", "c",     api.fs.copy.node,               o("Copy"))
        map("n", "x",     api.fs.cut,                     o("Cut"))
        map("n", "p",     api.fs.paste,                   o("Paste"))
        map("n", "y",     api.fs.copy.filename,           o("Copy name"))
        map("n", "Y",     api.fs.copy.absolute_path,      o("Copy path"))

        -- ── Tree ops ──────────────────────────────
        map("n", "q",     api.tree.close,                 o("Close"))
        map("n", "H",     api.tree.toggle_hidden_filter,  o("Hidden files"))
        map("n", "I",     api.tree.toggle_gitignore_filter, o("Gitignore"))
        map("n", "W",     api.tree.collapse_all,         o("Collapse all"))
        map("n", "S",     api.tree.search_node,          o("Search"))
        map("n", ".",     api.tree.change_root_to_node,  o("CD to node"))
        map("n", "<BS>",  api.tree.change_root_to_parent, o("CD to parent"))
      end,

      view = {
        width = 35,
        side = "left",
        number = false,
        relativenumber = false,
      },

      renderer = {
        group_empty = true,
        indent_width = 2,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open   = "",
            },
          },
        },
      },

      filters = {
        dotfiles = false,
        custom = { ".git", "node_modules", ".cache" },
      },

      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = false,
        },
      },

      git = { enable = true, ignore = false },
      diagnostics = { enable = true, show_on_dirs = false },
    },
  },
}
```

---

## File: `lua/user/plugins/fuzzy.lua`

```lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      -- ── Find ───────────────────────────────────
      { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end,                  desc = "Recent files" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,                   desc = "Find buffers" },
      -- ── Search ─────────────────────────────────
      { "<leader>sg", function() require("telescope.builtin").live_grep() end,                 desc = "Live grep" },
      { "<leader>sw", function() require("telescope.builtin").grep_string() end,               desc = "Find word" },
      { "<leader>sc", function() require("telescope.builtin").commands() end,                  desc = "Commands" },
      { "<leader>sh", function() require("telescope.builtin").help_tags() end,                 desc = "Help" },
      { "<leader>sk", function() require("telescope.builtin").keymaps() end,                   desc = "Keymaps" },
      -- ── Git ────────────────────────────────────
      { "<leader>gc", function() require("telescope.builtin").git_commits() end,               desc = "Git commits" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end,                desc = "Git status" },
      -- ── LSP (available when LSP attaches) ──────
      { "<leader>ss", function() require("telescope.builtin").lsp_document_symbols() end,      desc = "Document symbols" },
      { "<leader>sS", function() require("telescope.builtin").lsp_workspace_symbols() end,     desc = "Workspace symbols" },
      -- ── Diagnostics ────────────────────────────
      { "<leader>sd", function() require("telescope.builtin").diagnostics() end,               desc = "Diagnostics" },
    },
    opts = {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = "  ",
        entry_prefix = "  ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        borderchars = {
          "─", "│", "─", "│", "╭", "╮", "╯", "╰",
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = "send_to_qflist + open_qflist",
            ["<Esc>"] = "close",
          },
          n = {
            ["q"] = "close",
          },
        },
        file_ignore_patterns = {
          "node_modules", ".git/", ".cache", "%.o$", "%.a$",
        },
      },
    },
  },
}
```

---

## File: `lua/user/lsp/init.lua`

```lua
-- ═══════════════════════════════════════════════════════════
--  Native LSP — Neovim 0.11+ (zero plugins)
-- ═══════════════════════════════════════════════════════════
local lsp = vim.lsp

-- ═══════════════════════════════════════════════════════════
--  1. SERVER CONFIGURATION
-- ═══════════════════════════════════════════════════════════

lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.sum", ".git" },
  settings = {
    gopls = {
      -- Formatting
      gofumpt = true,
      -- Analyses
      analyses = {
        unusedparams   = true,
        shadow         = true,
        fieldalignment = false,
        nilness        = true,
        unusedwrite    = true,
        useany         = true,
      },
      -- Diagnostics
      staticcheck = true,
      diagnosticsDelay = "500ms",
      -- Completion
      usePlaceholders    = true,
      completeUnimported = true,
      completionDocumentation = true,
      deepCompletion         = true,
      fuzzyMatching          = true,
      -- Build
      buildFlags = {},
      env = {},
      -- Links
      linksInHover = true,
      -- codelenses (enable test/code lenses)
      codelenses = {
        gc_details_types = true,
        generate         = true,
        regenerate_cgo   = true,
        run_govulncheck  = true,
        test             = true,
        tidy             = true,
        upgrade_dependency = true,
        vendor           = true,
      },
    },
  },
})

lsp.config("dockerls", {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile", "Dockerfile*", ".git" },
  single_file_support = true,
  settings = {
    docker = {
      languageserver = {
        diagnostics = {
          deprecatedMaintainer = "warning",
        },
      },
    },
  },
})

-- ═══════════════════════════════════════════════════════════
--  2. ENABLE SERVERS
-- ═══════════════════════════════════════════════════════════

lsp.enable("gopls")
lsp.enable("dockerls")

-- ═══════════════════════════════════════════════════════════
--  3. KEYMAPS ON LSP ATTACH
-- ═══════════════════════════════════════════════════════════

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local buf    = event.buf
    local client = lsp.get_client_by_id(event.data.client_id)

    -- Buffer-local keymaps (only active when LSP is attached)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, {
        buffer   = buf,
        desc     = "LSP: " .. desc,
        noremap  = true,
        silent   = true,
      })
    end

    -- Navigation
    map("gd",         lsp.buf.definition,        "Definition")
    map("gD",         lsp.buf.declaration,       "Declaration")
    map("gr",         lsp.buf.references,        "References")
    map("gi",         lsp.buf.implementation,    "Implementation")
    map("gt",         lsp.buf.type_definition,   "Type definition")
    map("gO",         lsp.buf.document_symbol,   "Document symbols")

    -- Hover & signature
    map("K",          lsp.buf.hover,             "Hover docs")
    map("<C-k>",      lsp.buf.signature_help,    "Signature help")

    -- Refactoring
    map("<leader>rn", lsp.buf.rename,            "Rename")
    map("<leader>ca", lsp.buf.code_action,       "Code action")

    -- Format
    map("<leader>lf", function()
      lsp.buf.format({ bufnr = buf, async = true })
    end, "Format buffer")

    -- Diagnostics
    map("[d",         lsp.diagnostic.goto_prev,  "Prev diagnostic")
    map("]d",         lsp.diagnostic.goto_next,  "Next diagnostic")
    map("<leader>ld", lsp.diagnostic.open_float, "Float diagnostics")
    map("<leader>lq", lsp.diagnostic.setqflist,  "Diagnostics to qf")

    -- ── Format on save (Go only) ──────────────────
    if client and client.name == "gopls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("GoFmt" .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          lsp.buf.format({ bufnr = buf, async = false })
        end,
      })

      -- Organize imports on save for Go
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("GoImports" .. buf, { clear = true }),
        buffer = buf,
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          local result = client:request_sync("textDocument/codeAction", params, 1000, buf)
          if result and result.result then
            for _, action in ipairs(result.result) do
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
              end
            end
          end
        end,
      })
    end

    -- ── Native autocompletion ─────────────────────
    if client and client:supports_method("textDocument/completion") then
      lsp.completion.enable(true, client, buf, {
        autotrigger = true,
      })
    end

    -- ── Inlay hints (Go supports this) ────────────
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
  end,
})

-- ═══════════════════════════════════════════════════════════
--  4. LSP DETACH CLEANUP
-- ═══════════════════════════════════════════════════════════

vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true }),
  callback = function(event)
    vim.api.nvim_buf_clear_namespace(event.buf, -1, 0, -1)
  end,
})

-- ═══════════════════════════════════════════════════════════
--  5. DIAGNOSTIC CONFIGURATION
-- ═══════════════════════════════════════════════════════════

lsp.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
    severity = { min = vim.diagnostic.severity.WARN },
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
    },
  },
  underline       = true,
  update_in_insert = false,
  severity_sort   = true,
  float = {
    border   = "rounded",
    source   = "always",
    header   = { " Diagnostics ", "DiagnosticHeader" },
    prefix   = function(diag)
      local severity = {
        [vim.diagnostic.severity.ERROR] = "E ",
        [vim.diagnostic.severity.WARN]  = "W ",
        [vim.diagnostic.severity.INFO]  = "I ",
        [vim.diagnostic.severity.HINT]  = "H ",
      }
      return severity[diag.severity] or "  "
    end,
  },
})

-- ═══════════════════════════════════════════════════════════
--  6. GO USER COMMANDS
-- ═══════════════════════════════════════════════════════════

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("GoCommands", { clear = true }),
  pattern = "go",
  callback = function()
    local buf_cmd = function(name, cmd, desc)
      vim.api.nvim_buf_create_user_command(0, name, cmd, { desc = desc })
    end

    -- Run current package tests
    buf_cmd("GoTest", function()
      vim.cmd("write")
      vim.cmd("term go test -v ./...")
    end, "Run go test")

    -- Run current file
    buf_cmd("GoRun", function()
      vim.cmd("write")
      vim.cmd("term go run .")
    end, "Run go run")

    -- Build current package
    buf_cmd("GoBuild", function()
      vim.cmd("write")
      vim.cmd("term go build ./...")
    end, "Run go build")

    -- Run go vet
    buf_cmd("GoVet", function()
      vim.cmd("term go vet ./...")
    end, "Run go vet")

    -- Run go mod tidy
    buf_cmd("GoModTidy", function()
      vim.cmd("term go mod tidy")
    end, "Run go mod tidy")

    -- Run golangci-lint
    buf_cmd("GoLint", function()
      vim.cmd("term golangci-lint run ./...")
    end, "Run golangci-lint")

    -- Keymaps for Go commands
    vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>",    { buffer = true, desc = "Go test" })
    vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<cr>",     { buffer = true, desc = "Go run" })
    vim.keymap.set("n", "<leader>gb", "<cmd>GoBuild<cr>",   { buffer = true, desc = "Go build" })
    vim.keymap.set("n", "<leader>gv", "<cmd>GoVet<cr>",     { buffer = true, desc = "Go vet" })
    vim.keymap.set("n", "<leader>gl", "<cmd>GoLint<cr>",    { buffer = true, desc = "Go lint" })
  end,
})

-- ═══════════════════════════════════════════════════════════
--  7. DOCKER USER COMMANDS
-- ═══════════════════════════════════════════════════════════

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("DockerCommands", { clear = true }),
  pattern = "dockerfile",
  callback = function()
    local buf_cmd = function(name, cmd, desc)
      vim.api.nvim_buf_create_user_command(0, name, cmd, { desc = desc })
    end

    -- Docker build
    buf_cmd("DockerBuild", function()
      vim.cmd("term docker build -t $(basename %:p:h) .")
    end, "Docker build")

    -- Hadolint
    buf_cmd("DockerLint", function()
      vim.cmd("term hadolint %")
    end, "Run hadolint")

    -- Keymaps
    vim.keymap.set("n", "<leader>db", "<cmd>DockerBuild<cr>", { buffer = true, desc = "Docker build" })
    vim.keymap.set("n", "<leader>dl", "<cmd>DockerLint<cr>",  { buffer = true, desc = "Docker lint" })
  end,
})

-- ═══════════════════════════════════════════════════════════
--  8. GO FORMATTING RULES (override for tab width)
-- ═══════════════════════════════════════════════════════════

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("GoFormat", { clear = true }),
  pattern = "go",
  callback = function()
    -- gofmt uses tabs, so respect Go's convention
    vim.bo.tabstop     = 4
    vim.bo.shiftwidth  = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab   = false   -- Go uses hard tabs
    vim.bo.formatprg   = "gofmt"
  end,
})

-- ═══════════════════════════════════════════════════════════
--  9. DOCKER FORMATTING RULES
-- ═══════════════════════════════════════════════════════════

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("DockerFormat", { clear = true }),
  pattern = "dockerfile",
  callback = function()
    vim.bo.tabstop     = 2
    vim.bo.shiftwidth  = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab   = true
    vim.bo.commentstring = "# %s"
  end,
})
```

---

## Keybind Quick Reference

```
╔════════════════════════════════════════════════════════════╗
║  LEADER = Space                                            ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  FILE OPS                                                  ║
║  ─────────                                                 ║
║  <leader>fs    Save file                                   ║
║  <leader>fq    Quit                                        ║
║  <leader>fQ    Quit all                                    ║
║                                                            ║
║  FUZZY FIND (Telescope)                                    ║
║  ──────────────────                                        ║
║  <leader>ff    Find files                                  ║
║  <leader>fr    Recent files                                ║
║  <leader>fb    Find buffers                                ║
║  <leader>sg    Live grep                                   ║
║  <leader>sw    Find word under cursor                      ║
║  <leader>ss    Document symbols                            ║
║  <leader>sd    Diagnostics                                 ║
║  <leader>sk    Keymaps                                     ║
║  <leader>sh    Help tags                                   ║
║  <leader>gc    Git commits                                 ║
║  <leader>gs    Git status                                  ║
║                                                            ║
║  FILE EXPLORER                                             ║
║  ─────────────                                             ║
║  <leader>e     Toggle nvim-tree                            ║
║  <leader>E     Find current file in tree                   ║
║    a           Create file/folder                           ║
║    d           Delete                                       ║
║    r           Rename                                       ║
║    c/x/p       Copy/Cut/Paste                              ║
║    h/l         Close parent / Open                         ║
║    H           Toggle hidden files                          ║
║    q           Close explorer                              ║
║                                                            ║
║  BUFFERS                                                   ║
║  ───────                                                   ║
║  <leader>bn    Next buffer                                 ║
║  <leader>bp    Prev buffer                                 ║
║  <leader>bd    Delete buffer                               ║
║  <leader>bb    Switch to last buffer                       ║
║  <leader>bo    Close other buffers                         ║
║                                                            ║
║  TABS                                                      ║
║  ────                                                      ║
║  <leader>tn    New tab                                     ║
║  <leader>tc    Close tab                                   ║
║  <leader>to    Close other tabs                            ║
║  <leader>tp    Prev tab                                    ║
║  <leader>tl    Next tab                                    ║
║  <leader>tf    Current file in new tab                     ║
║                                                            ║
║  SPLITS                                                    ║
║  ──────                                                    ║
║  Ctrl+h/j/k/l  Navigate splits                            ║
║  <leader>sv    Vertical split                              ║
║  <leader>sh    Horizontal split                            ║
║  <leader>sx    Close split                                 ║
║  <leader>so    Close other splits                          ║
║  Ctrl+Arrows   Resize splits                               ║
║                                                            ║
║  LSP (active when LSP attached)                            ║
║  ────────────────────────────                              ║
║  gd            Go to definition                            ║
║  gD            Go to declaration                           ║
║  gr            References                                  ║
║  gi            Implementation                              ║
║  gt            Type definition                             ║
║  K             Hover docs                                  ║
║  <leader>rn    Rename symbol                               ║
║  <leader>ca    Code action                                 ║
║  <leader>lf    Format buffer                               ║
║  [d / ]d       Prev/Next diagnostic                       ║
║  <leader>ld    Float diagnostics                           ║
║                                                            ║
║  GO (in .go files)                                         ║
║  ──────────────                                            ║
║  <leader>gt    Go test                                     ║
║  <leader>gr    Go run                                      ║
║  <leader>gb    Go build                                    ║
║  <leader>gv    Go vet                                      ║
║  <leader>gl    Go lint (golangci-lint)                     ║
║  :GoTest/:GoRun/:GoBuild/:GoVet/:GoLint/:GoModTidy        ║
║                                                            ║
║  DOCKER (in Dockerfiles)                                   ║
║  ──────────────────────                                    ║
║  <leader>db    Docker build                                ║
║  <leader>dl    Hadolint                                    ║
║  :DockerBuild/:DockerLint                                  ║
║                                                            ║
║  THEME                                                     ║
║  ─────                                                     ║
║  :ToggleTransparent   Toggle transparent bg                ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

## First Run

```bash
# 1. Install LSP servers
go install golang.org/x/tools/gopls@latest
npm install -g dockerfile-language-server-nodejs

# 2. Install ripgrep (for telescope grep)
# macOS
brew install ripgrep
# Ubuntu
sudo apt install ripgrep
# Arch
sudo pacman -S ripgrep

# 3. Launch Neovim — lazy.nvim auto-installs plugins
nvim

# 4. Verify inside Neovim
:Lazy                    -- should show 4 plugins loaded
:checkhealth             -- verify dependencies

# 5. Open a Go file
nvim main.go
:LspInfo                 -- should show gopls attached

# 6. Open a Dockerfile
nvim Dockerfile
:LspInfo                 -- should show dockerls attached
```

---

## Plugin Count

```
Total: 4 plugins (5 with plenary as dependency)

  1. tokyonight.nvim      — colorscheme
  2. nvim-tree.lua        — file explorer
  3. nvim-web-devicons    — file icons (dependency)
  4. telescope.nvim       — fuzzy finder
  5. plenary.nvim         — utility lib (dependency)

LSP: 0 plugins (native Neovim 0.11 API)
Completion: 0 plugins (native Neovim 0.11 API)
```

Startup target: **under 30ms**
```
:Lazy profile
```
