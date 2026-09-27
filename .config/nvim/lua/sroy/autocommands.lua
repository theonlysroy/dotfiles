local api = vim.api
local augroup = function(name)
  return api.nvim_create_augroup("user_" .. name, { clear = true })
end

--  highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

--  resize splits on resize window
api.nvim_create_autocmd("VimResized", {
  group = augroup("win_resize"),
  callback = function() vim.cmd.wincmd("=") end,
})

--  go to last reopened pane
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

-- strip trailing whitespace on save
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("strip_whitespace"),
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- auto create dir on save
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- dockerfile filetype detection
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("dockerfile_ft"),
  pattern = { "Dockerfile*", "*.dockerfile" },
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})
