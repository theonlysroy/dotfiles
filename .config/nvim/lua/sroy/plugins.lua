-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugin specs
require("lazy").setup({
  { "neovim/nvim-lspconfig" },

  -- highlight, indent
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

  -- File explorer sidebar (netrw replacement)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- must disable netrw before nvim-tree loads
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        git = { enable = true },
      })
    end,
  },

  -- Fuzzy finder — single file, zero dependencies, needs ripgrep on PATH
  {
    "echasnovski/mini.pick",
    version = false,
    config = function()
      require("mini.pick").setup()
    end,
  },

  -- Colorscheme
  {
    "datsfilipe/min-theme.nvim",
    lazy = false,
    priority = 1000, -- load before other plugins so colors are set immediately
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("min-theme")
    end,
  },
})
