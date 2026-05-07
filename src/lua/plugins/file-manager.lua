-- native file-manager with support for remotes
return {
  -- Oil
  { 'oil-git.nvim' },
  { 'oil-lsp-diagnostics.nvim' },
  { 'oil.nvim',
    enabled = nixInfo(false, 'info', 'oil', 'enable'),
    lazy = false,
    keys = {
      { "<leader>-", ":Oil<CR>", desc = "Open (Oil) parent directory." },
      { "<leader>~", ":Oil ~<CR>", desc = "Open (Oil) in home directory." },
    },
    after = function ()
      require('oil').setup({
        default_file_explorer = true,
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime"
        },
        buf_options = {
          buflisted = true
        },
        skip_confirm_for_simple_edits = true,
        view_options = {
        },
        -- keymaps = {
        --   ["C-j"] = "actions.select",
        --   ["C-k"] = "actions.parent",
        -- },
      })
    end
  },

  -- NeoTree
  { "neo-tree.nvim",
    lazy = false, -- lazy-loads itself
    keys = {
      { "<leader>aa", ":Neotree toggle<CR>", desc = "NeoTree toggle side panel", },
    },
    after = function ()
      require('neo-tree').setup({})
    end
  },

  -- Yazi
  { "yazi.nvim",
    enabled = nixInfo(false, 'info', 'yazi', 'enable'),
    keys = {
      { '<leader>ay', function()
        require'yazi'.yazi(nil, vim.fn.getcwd())
      end, desc = 'Yazi open in current dir' },
      { '<leader>aY', function()
        require'yazi'.yazi(nil, '~')
      end, desc = 'Yazi open in home dir' },
    },
    after = function ()
      require('yazi').setup({
        open_for_directories = true,
      })
    end
  },
}
