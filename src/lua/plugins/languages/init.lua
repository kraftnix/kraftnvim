return {
  { import = 'plugins.languages.nix' },
  { import = 'plugins.languages.lua' },
  { import = 'plugins.languages.java' },
  { import = 'plugins.languages.conform' },
  { import = 'plugins.languages.lspconfig' },
  { import = 'plugins.languages.treesitter' },
  { import = 'plugins.languages.treesitter-textobjects' },
  { "inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      { '<leader>rN<space>', ':IncRename<cr>', 'Incremntal Rename' }
    }
  },
  { "trouble.nvim",
    enable = false,
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)", },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)", },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)", },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    }
  },

  -- custom highlights for comments
  { "todo-comments.nvim",
    cmd = {
      "TodoQuickFix",
      "TodoLocList",
    },
    keys = {
      { '<leader>lfc', ':TodoQuickFix<CR>', desc = '[lfc]: Add all todo items to quickfix list' },
      { '<leader>lfl', ':TodoLocList<CR>', desc = '[lfl]: Add all todo items to location list' },
      { '<leader>lfT', ':Trouble todo<CR>', desc = '[lf]ist all project todos in [T]rouble' },
      { "<leader>lft", function() Snacks.picker.todo_comments() end, desc = "Todo Picker" },
      { "<leader>lfT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
      { ']T', function () require('todo-comments').jump_next() end, desc = 'TODO Comment next' },
      { '[T', function () require('todo-comments').jump_prev() end, desc = 'TODO Comment prev' },
    },
    after = function ()
      require('todo-comments').setup({
        keywords = {
          WORKAROUND = { icon = "🛠️", color = "error" }
        },
        -- pattern = [[\b(KEYWORDS)\(\):]],
        highlight = {
          -- vimgrep regex, supporting the pattern TODO(name):
          pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
        },
        search = {
          -- ripgrep regex, supporting the pattern TODO(name):
          pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
        },
      })
    end
  },

}
