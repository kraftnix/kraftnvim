local h = KraftnixHelper

-- vim.keymap.set({"n", "v", "x"}, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })
vim.keymap.set({'n', 'v', 'x'}, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })
vim.keymap.set('i', '<C-p>', '<C-r><C-p>+', { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
vim.keymap.set("x", "<leader>P", '"_dP', { noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' })

if nixCats('oscyank') then
  return {

    { 'ojroques/nvim-osc52',
      -- stylua: ignore
      keycommands_meta = {
        group_name = 'OSCYank',
        icon = '📋',
        description = 'Key bindings for OSC52 copying',
      },
      -- ISSUE: cannot get commands working in keycommands wrapper
      keycommands = {
        -- { '<leader>y', h.lr('osc52', 'copy_operator'), "[y]ank (copy) visual selection via OSC52", mode = 'n', opts = { expr = true }  },
        -- { '<leader>yy', '<leader>y_', "[yy]ank (copy) current line via OSC52", mode = 'n', is_nvim_command = true, opts = { remap = true } },
        -- { '<leader>y', h.lr('osc52', 'copy_visual'), "[y]ank (copy) visual selection via OSC52", mode = 'v' },
      },
      config = function ()
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

    -- INFO: legacy vim native implementation
    -- -- { 'ojroques/vim-oscyank',
    -- --   -- stylua: ignore
    -- --   keycommands_meta = {
    -- --     group_name = 'OSCYank',
    -- --     icon = '📋',
    -- --     description = 'Key bindings for OSC52 copying',
    -- --     default_opts = { noremap = true }
    -- --   },
    -- --   keycommands = {
    -- --     -- yank
    -- --     { '<leader>y', 'v$:OSCYankVisual<cr>', "[Y]ank (copy) visual selection via OSC52", mode = 'n', is_nvim_command = true },
    -- --     { '<leader>yy', 'V:OSCYankVisual<cr>', "[yy]ank (copy) current line via OSC52", mode = 'n', is_nvim_command = true },
    -- --     { '<leader>y', ':OSCYankVisual<cr>', "[y]ank (copy) visual selection via OSC52", mode = 'x', is_nvim_command = true },
    -- --   },
    -- --   config = function ()
    -- --   end
    -- -- },

  }
else
  -- You should instead use these keybindings so that they are still easy to use, but dont conflict
  vim.keymap.set("n", '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
  vim.keymap.set({"v", "x"}, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
  vim.keymap.set({"n", "v", "x"}, '<leader>yy', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
  vim.keymap.set({"n", "v", "x"}, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
  return { }
end
