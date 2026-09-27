return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
    cmd = "Telescope",
    keys = {
      -- find
      {"<leader>ff", function() require("telescope.builtin").find_files({hidden = true}) end, desc = "Find files"},
      {"<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files"},
      {"<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find buffers"},

      -- search
      {"<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "Live grep"},
      {"<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "Find word"},
      {"<leader>sc", function() require("telescope.builtin").commands() end, desc = "Commands"},
      {"<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Help"},
      {"<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps"},

      -- Git
      {"<leader>gc", function() require("telescope.builtin").git_commits() end, desc = "Git commits"},
      {"<leader>gs", function() require("telescope.builtin").git_status() end, desc = "Git status"},

      -- lsp
      -- {"<leader>ss", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document symbols"},
      -- {"<leader>sS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "Workspace symbols"},

      -- diagnostics
      {"<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics"},
    },
    opts = {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = "  ",
        entry_prefix = "  ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        borderchars = {
          "─", "│", "─", "│", "╭", "╮", "╯", "╰",
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = "send_to_qflist + open_qflist",
            ["<Esc>"] = "close",
          },
          n = {
            ["q"] = "close",
          },
        },
        file_ignore_patterns = {
          "node_modules", ".git/", ".cache", "%.o$", "%.a$",
        },
      },
    },
  },
}
