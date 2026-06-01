return {
  { "fzf",
    dep_of = { 'nvim-bqf' },
  },
  { "nvim-bqf",
    -- ft = "qf",
    event = 'DeferredUIEnter', -- ft = "qf" doesn't allow autoload for some reason
    keys = {
      { '<leader>lq', ':ToggleQuickfix<CR>', desc = 'Toggle quickfix list' },
      { '<leader>lQ', ':BqfToggle<CR>', desc = 'Enable/Disable auto quickfix toggle' }
    },
    after = function ()
      require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true,
        filter = {
          fzf = {
            action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' }
          }
        }
      })
    end
  },
}

