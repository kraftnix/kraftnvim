local popupmenu_backend = 'nui'
if vim.g.enable_cmp_cmdline then
  popupmenu_backend = 'cmp'
end
return {

  { "nvim-notify",
    enabled = nixInfo(false, "settings", "noice", "enable"),
    keys = {
      { "<leader>nu",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    after = function ()
      require('nvim-notify').setup({
        timeout = 5000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      })
    end
  },

  { 'nui.nvim',
    auto_enable = nixInfo(false, "settings", "noice", "enable"),
    on_plugin = { "noice.nvim" },
    load = nixInfo.lze.loaders.with_after,
  },

  { "noice.nvim",
    enabled = nixInfo(false, "settings", "noice", "enable"),
    dep_of = { "lualine.nvim" },
    keys = {
      -- { '<leader>nn', 'Noice', 'ope[n] [n]oice', cmd_gen_skip = true },
      { '<leader>nh', ':Noice history<CR>', desc = '[n]oice [h]istory'},
      { '<leader>ns', ':Noice stats<CR>', desc = '[n]oice view [s]tats'},
      { '<leader>nR', ':Noice routes<CR>', desc = '[n]oice [r]outes'},
      { '<leader>na', ':Noice all<CR>', desc = '[n]oice [a]ll'},
      { '<leader>nf', ':Noice telescope<CR>', desc = '[n]oice find all [t]elescope'},
      { '<leader>nll', ':Noice last<CR>', desc = '[n]oice get [l]ast [l]og'},
      { '<leader>nlL', ':Noice log<CR>', desc = '[n]oice open [lL]og file'},
      { '<leader>nlc', ':Noice config<CR>', desc = '[n]oice [l]ist [c]onfig'},
    },
    -- event = "VeryLazy",
    event = "UIEnter",
    after = function ()
      require('noice').setup({
        -- debug = true,
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          -- view = "cmdline",
          opts = {},
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            -- ["cmp.entry.get_documentation"] = false,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          -- bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },

        routes = {
          { -- reroute long notifications to splits
            view = 'split',
            filter = {
              event = "notify",
              min_height = 15
            },
          },
          { -- filter out treesitter errors
            view = 'split',
            filter = {
              event = { "msg_show", "msg_showmode" },
              find = "treesitter/highlighter",
            },
          },
          { -- route shortmess messages to mini view
            view = "mini",
            filter = {
              event = { "msg_show", "msg_showmode" },
              ["not"] = {
                kind = { "confirm", "confirm_sub" },
              },
            },
          },
          --- ??
          -- {
          --   filter = {
          --     event = "cmdline",
          --     find = "^%s*[/?]",
          --   },
          --   view = "cmdline",
          -- },

          -- No
          -- {
          --   filter = {
          --     event = "notify",
          --     find = "No information available",
          --   },
          --   opts = { skip = true },
          -- }
        },

        -- show together
        views = {
          cmdline_popup = {
            -- position = {
            --   row = 5,
            --   col = "50%",
            -- },
            -- size = {
            --   width = 60,
            --   height = "auto",
            -- },
            border = {
              style = "none",
              padding = { 2, 3 },
            },
            filter_options = {},
            win_options = {
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            },
          },
          popupmenu = {
            backend = popupmenu_backend,
            relative = "editor",
            position = {
              row = 8,
              col = "50%",
            },
            size = {
              width = 80,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
          },
        },
        commands = {
          all = {
            -- options for the message history that you get with `:Noice`
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {},
          },
        },
        status = { lsp_progress = { event = "lsp", kind = "progress" } },
      })

      -- Adding the following keymap, will redirect the active cmdline when pressing
      -- `<Alt-Enter>`. The cmdline stays open, so you can change the command and execute
      -- it again. When exiting the cmdline, the popup window will be focused.
      local redirect = function()
        require('noice').redirect(vim.fn.getcmdline())
      end
      vim.keymap.set('c', '<m-cr>', redirect, { desc = 'Redirect Cmdline' })

      -- LSP HOVER DOC SCROLLING
      vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end, { silent = true, expr = true })

      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })
    end
  },

}
