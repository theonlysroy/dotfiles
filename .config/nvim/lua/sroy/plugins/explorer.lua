return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    keys = {
      { "<leader>e",":NvimTreeToggle<CR>",desc = "Toggle explorer" },
      { "<leader>E",":NvimTreeFindFile<CR>",desc = "Find current file" },
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Default keymaps first
        api.config.mappings.default_on_attach(bufnr)

        local function o(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        local map = vim.keymap.set

        -- ── Navigation ────────────────────────────
        map("n", "l",     api.node.open.edit,             o("Open"))
        map("n", "h",     api.node.navigate.parent_close,  o("Close parent"))
        map("n", "<CR>",  api.node.open.edit,             o("Open"))
        map("n", "<Tab>", api.node.open.preview,          o("Preview"))

        -- ── File ops ──────────────────────────────
        map("n", "a",     api.fs.create,                  o("Create"))
        map("n", "d",     api.fs.remove,                  o("Delete"))
        map("n", "r",     api.fs.rename,                  o("Rename"))
        map("n", "R",     api.fs.rename_sub,              o("Rename (sub)"))
        map("n", "c",     api.fs.copy.node,               o("Copy"))
        map("n", "x",     api.fs.cut,                     o("Cut"))
        map("n", "p",     api.fs.paste,                   o("Paste"))
        map("n", "y",     api.fs.copy.filename,           o("Copy name"))
        map("n", "Y",     api.fs.copy.absolute_path,      o("Copy path"))

        -- ── Tree ops ──────────────────────────────
        map("n", "q",     api.tree.close,                 o("Close"))
        map("n", "H",     api.tree.toggle_hidden_filter,  o("Hidden files"))
        map("n", "I",     api.tree.toggle_gitignore_filter, o("Gitignore"))
        map("n", "W",     api.tree.collapse_all,         o("Collapse all"))
        map("n", "S",     api.tree.search_node,          o("Search"))
        map("n", ".",     api.tree.change_root_to_node,  o("CD to node"))
        map("n", "<BS>",  api.tree.change_root_to_parent, o("CD to parent"))
      end,

      view = {
        width = 35,
        side = "left",
        number = false,
        relativenumber = false,
      },

      renderer = {
        group_empty = true,
        indent_width = 2,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open   = "",
            },
          },
        },
      },

      filters = {
        dotfiles = false,
        custom = { ".git", "node_modules", ".cache" },
      },

      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = false,
        },
      },

      git = { enable = true, ignore = false },
      diagnostics = { enable = true, show_on_dirs = false },
    },
  },
}
