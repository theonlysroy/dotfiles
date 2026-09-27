
local api = vim.api

-- Go: gofmt/gofumpt rewrite indentation to real tabs on every save
api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

-- Makefile: real tab characters are a hard syntax requirement for recipe
api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})
