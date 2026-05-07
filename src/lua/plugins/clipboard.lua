if nixInfo(false, 'info', 'oscyank', 'enable') then
  return {
    { 'nvim-osc52',
      after = function ()
        require('osc52').setup {
          max_length = 0,           -- Maximum length of selection (0 for no limit)
          -- silent = false,           -- Disable message on successful copy
          trim = false,             -- Trim surrounding whitespaces before copy
          -- tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
        }
        vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true, desc = "[y]ank (copy) visual selection via OSC52" })
        vim.keymap.set('n', '<leader>yy', '<leader>y_', { remap = true, desc = "[yy]ank (copy) current line via OSC52" })
        vim.keymap.set('v', '<leader>y', require('osc52').copy_visual, { desc = "[y]ank (copy) visual selection via OSC52" } )
      end
    },
  }
else
  -- You should instead use these keybindings so that they are still easy to use, but dont conflict
  vim.keymap.set("n", '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
  vim.keymap.set({"v", "x"}, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
  vim.keymap.set({"n", "v", "x"}, '<leader>yy', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
  vim.keymap.set({"n", "v", "x"}, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
  return { }
end
