vim.env.RIPGREP_CONFIG_PATH = vim.fn.expand("$HOME/.ripgreprc")

vim.g.mapleader = " "

require("sroy.options")
require("sroy.plugins")
require("sroy.lsp")
require("sroy.colorscheme")
require("sroy.keymaps")
require("sroy.autocommands")
