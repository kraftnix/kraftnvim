return {

  { 'ojroques/vim-oscyank',
    -- stylua: ignore
    keycommands_meta = {
      group_name = 'OSCYank',
      icon = '📋',
      description = 'Key bindings for OSC52 copying',
      default_opts = { noremap = true }
    },
    keycommands = {
      -- yank
      { '<leader>y', 'v$:OSCYankVisual<cr>', "[Y]ank (copy) visual selection via OSC52", mode = 'n', is_nvim_command = true },
      { '<leader>yy', 'V:OSCYankVisual<cr>', "[yy]ank (copy) current line via OSC52", mode = 'n', is_nvim_command = true },
      { '<leader>y', ':OSCYankVisual<cr>', "[y]ank (copy) visual selection via OSC52", mode = 'x', is_nvim_command = true },
    },
    config = function ()
    end
  },

}
