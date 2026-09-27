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
  vim.cmd.colorscheme("default")
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

-- apply on startup
vim.cmd.colorscheme("default")
apply_transparent()

-- Re-apply transparent when a colorscheme is loaded
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TransparentBg", { clear = true }),
  callback = function()
    apply_transparent()
  end,
})

return {}
