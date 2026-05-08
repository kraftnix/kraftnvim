local h = require('utils.helper')
return {

  { "flash.nvim",
    enabled = nixInfo(false, 'info', 'flash', 'enable'),
    event = "DeferredUIEnter",
    after = function ()
      require('flash').setup({})
    end,
    keys = {

      { "<c-s><c-s>", h.lr('flash', 'jump'), desc = "Flash Jump", mode = { "n", "x", "o" } },
      { "<c-s><c-k>", h.lr('flash', 'treesitter'), desc = "Flash Treesitter", mode = { "n", "x", "o" } },
      { '<c-s><c-r>', h.lr('flash', 'jump', {continue=true}), desc = 'Flash: continue search' }, -- awesome

      -- awesome
      { '<c-s><c-w>',
        function ()
          require('flash').jump({
            pattern = vim.fn.expand("<cword>"),
          })
        end,
        desc = 'Flash: search under word'
      },

      { '<c-s><c-f>',
        function ()
          require('flash').jump({
            pattern = ".",
            -- pattern = "/",
            search = {
              mode = function(pattern)
                -- return word pattern and proper skip pattern
                -- return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
                return "github:[%w-_%.%?%.:/%+=&]+", "github:"
              end,
            },
            -- select the range
            jump = { pos = "range" },
          })
        end,
        desc = 'Flash: search under word'
      },

      { '<c-s><c-l>',
        h.lr('flash', 'jump', {
          search = { mode = "search", max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = "^"
        }),
        desc = 'Flash: jump to a line'
      },

      { '<c-s><c-j>',
        function()
          require("flash").jump({
            pattern = ".", -- initialize pattern with any char
            search = {
              mode = function(pattern)
                -- return word pattern and proper skip pattern
                return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
                -- return ([[\<.[\w\/\.]*\>]]), ([[\<.[\w\/\.]*\>]])
              end,
            },
            -- select the range
            jump = { pos = "range" },
          })
        end,
        desc = 'Flash: select any word'
      },

      { "<c-s><c-d>",
        function()
          require("flash").jump({
            action = function(match, state)
              vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, match.pos)
                vim.diagnostic.open_float()
              end)
              state:restore()
            end,
          })
        end,
        desc = 'Flash: search diagnostics'
      },

      -- More advanced example that also highlights diagnostics:
      { "<c-s><c-h>",
        function()
          require("flash").jump({
            matcher = function(win)
              ---@param diag Diagnostic
              return vim.tbl_map(function(diag)
                return {
                  pos = { diag.lnum + 1, diag.col },
                  end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                }
              end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
            end,
            action = function(match, state)
              vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, match.pos)
                vim.diagnostic.open_float()
              end)
              state:restore()
            end,
          })
        end,
        desc = 'Flash: search diagnostics'
      },

      { "r", mode = "o", h.lr('flash', 'remote'), desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, h.lr('flash', 'treesitter_search'), desc = "Treesitter Search" },
      { '<c-s>', mode = { "c" }, h.lr('flash', 'toggle'), desc = "Toggle Flash Search" },
    },
  },

}
