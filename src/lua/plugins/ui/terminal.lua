local t = require 'utils.telescope.terminal'

local termManager = nixInfo('', 'info', 'terminal-manager')
return {
  { 'toggleterm.nvim',
    enabled = termManager == 'toggleterm',
    keys = {
      { "<C-Q>", ":ToggleTerm<cr>", noremap = true, mode = { "n", "x" } },
      { "<C-Q>", ":ToggleTerm<cr>", noremap = true, mode = { "t" } },
      { '<C-\\><C-\\>', '<Esc>', noremap = true, mode = "t", desc = "Terminal: enable escape" },
      { '<Esc>', '<c-\\><c-n>', noremap = true, mode = "t", desc = "Terminal: allow escape passthrough" },
    },
    after = function ()
      require('toggleterm').setup({
        open_mapping = [[<C-Q>]], -- doesn't seem to work
        direction = "tab",
        float_opts = {
          border = "double",
          winblend = 0,
        },
        auto_scroll = false,
        persist_mode = true,
        persist_size = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        winbar = {
          enabled = true
        }
      })
    end
  },

  { 'rebelot/terminal.nvim',
    enabled = termManager == 'terminal.nvim',
    keys = {
      { "<leader>ts",
        function()
          if require('legendary.toolbox').is_visual_mode() then
            local gvs = require("fzf-lua.utils").get_visual_selection
            require("terminal").send(1, gvs())
          else
            require("terminal").send(1, vim.api.nvim_get_current_line())
          end
        end,
        desc = "[t]erm: [s]end current line/selection to term",
        modes = { "v", "n" }
      },
      { '<C-Q>',
        function () require('terminal.mappings').toggle() end,
        desc = 'Toggle terminal into a tab',
        modes = { "n", "v" },
      },
      { "<leader>tr",
        function () require('terminal.mappings').run() end,
        desc = "[t]erminal, [r]un command (exits on completion)",
      },
      { "<leader>tk",
        function () require('terminal.mappings').kill() end,
        desc = "[t]erminal, [k]ill current",
      },
      { "]t",
        function () require('terminal.mappings').cycle_next() end,
        desc = "[t]erminal, cycle next",
      },
      { "[t",
        function () require('terminal.mappings').cycle_prev() end,
        desc = "[t]erminal, cycle prev",
      },
      { "<leader>fT", t.telescope_terminals, desc = 'Terminal Finder' },
      -- { "<leader>tt", tm('move', { open_cmd = "tabe" }), 'TerminalMoveToTab' }, --notworking
      -- { 'TerminalMoveToggleTab', tm('toggle', { open_cmd = "tabe" }), "<leader>tO" }, --notworking
      -- { 'TerminalRun', "<leader>tR", tma('run', nil, { layout = { open_cmd = "enew" } }), }, --notworking
      -- { "<leader>tl", tm('move', { open_cmd = "belowright vnew" }), 'TerminalMoveBelowRight' }, --notworking
      -- { "<leader>tf", tm('move', { open_cmd = "float" }), 'TerminalMoveFloat' }, --notworking

      { '<c-q>', function () require('terminal.mappings').toggle() end, noremap = true, mode = "t", desc = "Toggle terminal while in term mode" },
      { [[<c-\><c-\>]], '<Esc>', noremap = true, mode = "t", desc = "Terminal: enable escape" },
      { '<Esc>', [[<c-\><c-n>]], noremap = true, mode = "t", desc = "Terminal: allow escape passthrough" },
      { '<C-h>', [[<c-\><c-n><cmd>tabp<cr>]], noremap = true, mode = "t", desc = "Terminal: move tab left" },
      { '<C-l>', [[<c-\><c-n><cmd>tabn<cr>]], noremap = true, mode = "t", desc = "Terminal: move tab right" },
      { '<C-u>', [[<C-\><C-n><C-u>]], noremap = true, mode = "t", desc = "Terminal: Scroll up (and enter normal) in terminal." },
    },
    after = function ()
      local terminal = require("terminal")
      terminal.setup({
        -- layout = { open_cmd = "tabe name=scratchpad" },
        layout = { open_cmd = "tabe" },
        -- layout = { open_cmd = "float" },
        cmd = { vim.o.shell },
        autoclose = false,
      })
      local htop = terminal.terminal:new({
        layout = { open_cmd = "float" },
        cmd = { "btop" },
        autoclose = true,
      })

      vim.api.nvim_create_user_command("Zenith", function()
        htop:toggle(nil, true)
      end, { nargs = "?" })

      local nu = terminal.terminal:new({
        layout = { open_cmd = "float" },
        cmd = { "nu" },
        autoclose = true,
      })
      vim.api.nvim_create_user_command("Nushell", function()
        nu:toggle(nil, true)
      end, { nargs = "?" })


      -- automatically enter insert mode in terminal
      vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
        callback = function(args)
          if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
            vim.cmd("startinsert")
          end
        end,
      })
    end,
  }
}
