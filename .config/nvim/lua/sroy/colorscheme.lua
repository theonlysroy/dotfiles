
vim.g.transparent_background = true

vim.o.background = "dark"
vim.cmd.colorscheme("habamax")
-- vim.cmd.colorscheme("min-theme")

local function apply_transparency()
  if not vim.g.transparent_background then
    return
  end
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

apply_transparency()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_transparency })
