return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gosum", "gowork" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      analyses = { unusedparams = true },
      semanticTokens = true,
    },
  },
}
