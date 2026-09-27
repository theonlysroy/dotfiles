local lsp = vim.lsp

lsp.enable({ "gopls", "dockerls" })
vim.diagnostic.config({ virtual_text = true })

-- native completion + LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = lsp.get_client_by_id(ev.data.client_id)

    if client ~= nil and client:supports_method("textDocument/completion") then
      lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    local bufmap = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf })
    end
    bufmap("n", "gd", lsp.buf.definition)
    bufmap("n", "gr", lsp.buf.references)
    bufmap("n", "K", lsp.buf.hover)
    bufmap("n", "<leader>rn", lsp.buf.rename)
    bufmap("n", "<leader>ca", lsp.buf.code_action)
    bufmap("n", "<leader>d", vim.diagnostic.open_float)
  end,
})

vim.cmd("set completeopt+=noselect")

-- Go: format + organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          lsp.util.apply_workspace_edit(r.edit, "utf-8")
        end
      end
    end
    lsp.buf.format({ async = false })
  end,
})
