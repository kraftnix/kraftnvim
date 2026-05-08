local h = require('utils.helper')
return {
  { "nvim-dap",
    lazy = false,
    after = function()
      local dap = require("dap")
      dap.configurations.lua = {{
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
      }}

      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      vim.keymap.set('n', '<leader>db', require"dap".toggle_breakpoint, { noremap = true, desc = "dap: toggle_breakpoint" })
      vim.keymap.set('n', '<leader>dc', require"dap".continue, { noremap = true, desc = "dap: continue" })
      vim.keymap.set('n', '<leader>do', require"dap".step_over, { noremap = true, desc = "dap: step over" })
      vim.keymap.set('n', '<leader>di', require"dap".step_into, { noremap = true, desc = "dap: step into" })

      vim.keymap.set('n', '<leader>dl', function()
        require"osv".launch({port = 8086})
      end, { noremap = true, desc = "open osv" })

      vim.keymap.set('n', '<leader>dw', function()
        local widgets = require"dap.ui.widgets"
        widgets.hover()
      end, { desc = "hover dap ui widgets" })

      vim.keymap.set('n', '<leader>df', function()
        local widgets = require"dap.ui.widgets"
        widgets.centered_float(widgets.frames)
      end, { desc = "float dap ui widgets" })
    end,
  },

  { "one-small-step-for-vimkind",
    dep_of = { 'nvim-dap' },
  }
}
