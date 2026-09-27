
local api = vim.api

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
	group = api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Auto-resize splits on window resize
api.nvim_create_autocmd("VimResized", {
	group = api.nvim_create_augroup("WinResize", { clear = true }),
	callback = function()
		vim.cmd("wincmd =")
	end,
})

-- Remove trailing whitespace on save
api.nvim_create_autocmd("BufWritePre", {
	group = api.nvim_create_augroup("TrailingWs", { clear = true }),
	pattern = "*",
	callback = function()
		local save = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
	end,
})
