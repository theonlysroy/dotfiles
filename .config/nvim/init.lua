-- ============================================================
-- OPTIONS — sane, fast defaults
-- ============================================================
local o = vim.opt

o.number = true
o.relativenumber = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.scrolloff = 8
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.inccommand = "split"
o.cursorline = true
o.autochdir = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================
-- COLORSCHEME + TRANSPARENCY
-- ============================================================
vim.cmd.colorscheme("habamax") -- any built-in scheme works; habamax is clean and modern

local function transparent_bg()
  local groups = {
    "Normal", "NormalNC", "NormalFloat", "FloatBorder",
    "SignColumn", "LineNr", "CursorLineNr", "EndOfBuffer",
    "VertSplit", "WinSeparator", "StatusLine", "StatusLineNC",
    "Pmenu", "TabLine", "TabLineFill",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

transparent_bg()
vim.api.nvim_create_autocmd("ColorScheme", { callback = transparent_bg })

-- Go uses tabs, not spaces, by convention
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

-- ============================================================
-- PLUGIN MANAGER — lazy.nvim bootstrap
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.belloff = "all"

-- ============================================================
-- PLUGINS
-- ============================================================
require("lazy").setup({

  -- Treesitter — pinned to 'master' branch (legacy, stable API).
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "go", "gomod", "gosum", "gowork",
          "make", "dockerfile",
          "lua", "vimdoc",
        },
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Native LSP config (Neovim 0.11+ API)
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true },
          },
        },
      })

      vim.lsp.config("dockerls", {})

      vim.lsp.enable({ "gopls", "dockerls" })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
              end
            end
          end
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },

  -- Fast, minimal completion
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      completion = { documentation = { auto_show = true } },
    },
  },

})

-- ============================================================
-- LSP KEYMAPS
-- ============================================================
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufmap = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf })
    end
    bufmap("n", "gd", vim.lsp.buf.definition)
    bufmap("n", "gr", vim.lsp.buf.references)
    bufmap("n", "K", vim.lsp.buf.hover)
    bufmap("n", "<leader>rn", vim.lsp.buf.rename)
    bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
    bufmap("n", "<leader>d", vim.diagnostic.open_float)
  end,
})

-- ============================================================
-- FILETYPE DETECTION
-- ============================================================
vim.filetype.add({
  filename = {
    ["Makefile"] = "make",
    ["Dockerfile"] = "dockerfile",
    ["go.work"] = "gowork"
  },
  pattern = {
    ["Dockerfile.*"] = "dockerfile",
    [".*%.tmpl"] = "gotmpl",
    [".*%.gotmpl"] = "gotmpl",
  },
})

-- ============================================================
-- FILE EXPLORER (netrw, built-in — no plugin)
-- ============================================================
vim.g.netrw_banner = 0        -- no help banner
vim.g.netrw_liststyle = 3     -- tree view
vim.g.netrw_winsize = 25      -- 25% width sidebar
vim.g.netrw_browse_split = 0  -- open files in same window

vim.keymap.set("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Toggle file explorer" })

-- ============================================================
-- TERMINAL TOGGLE (built-in :terminal — no plugin)
-- ============================================================
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

vim.keymap.set("n", "<leader>t", toggle_terminal, { desc = "Toggle terminal" })
vim.keymap.set("t", "<leader>t", "<C-\\><C-n>", { desc = "Exit terminal mode then close on next <leader>t" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
