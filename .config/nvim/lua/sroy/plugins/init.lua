require("lazy").setup({
    spec = {
        { import = "sroy.plugins.colorscheme" },
        { import = "sroy.plugins.explorer" },
        { import = "sroy.plugins.fuzzy" }
    },
  install = { colorscheme = { "default" } },
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
