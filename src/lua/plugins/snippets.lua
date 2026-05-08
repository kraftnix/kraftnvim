local h = require('utils.helper')
local localPaths = nixInfo('', 'settings', 'snippets', 'localPath')
local keys = {
  { '<leader>Slf', 'Telescope luasnip', desc = "Luasnip [S]nippets." },
  { '<leader>Sle', h.lr("luasnip.loaders", 'edit_snippet_files'), desc = "Edit LuaSnip Snippets." },
  { '<leader>Sls', h.lr("luasnip", 'log.open'), desc = "Open LuaSnip log" },
  { '<leader>Slp', h.lr("luasnip", 'log.ping'), desc = "Ping LuaSnip log to check it is working." },
}
if not (localPaths == '') then
  table.insert(keys, {
    '<leader>Slr',
    h.lr("luasnip.loaders.from_lua", 'load', {paths = localPaths}),
    desc = "Reload local lua snippets",
  })
end

return {
  { 'friendly-snippets',
    enabled = nixInfo(false, 'settings', 'snippets', 'enable'),
    dep_of = 'luasnip',
  },
  { 'luasnip',
    enabled = nixInfo(false, 'settings', 'snippets', 'enable'),
    keys = {
    },
    after = function (_, opts)
      require('luasnip').setup(opts)
      require('luasnip.loaders.from_vscode').lazy_load()
      if not (localPaths == '') then
        require('luasnip.loaders.from_lua').lazy_load({ paths = localPaths })
      end
      -- allow loading from current dir
      -- require("luasnip.loaders.from_lua").load({paths = {vim.fn.getcwd() .. "/.luasnippets/"}})

      require('telescope').load_extension "luasnip"
    end
  },

  { 'nvim-scissors',
    keys = {
      { "<leader>Se", function() require("scissors").editSnippet() end, desc = "Snippet: Edit" },
      { "<leader>Sa", function() require("scissors").addNewSnippet() end,
        mode = { "n", "x" }, -- when used in visual mode, prefills the selection as snippet body
        desc = "Snippet: Add"
      }
    },
    after = function()
      require('scissors').setup({
        editSnippetPopup = {
          keymaps = {
            -- duplicateSnippet = "<C-w><C-c>",
            deleteSnippet = "<C-X>",
            -- openInFile = "<C-w><C-o>",
          },
        },
        -- this really doesn't work nicely with nix
        snippetDir = vim.fn.expand("$HOME/.config/nvim/" + localPaths),
        snippetSelection = {
          picker = "auto", ---@type "auto"|"telescope"|"snacks"|"vim.ui.select"

          telescope = {
            -- By default, the query only searches snippet prefixes. Set this to
            -- `true` to also search the body of the snippets.
            alsoSearchSnippetBody = true,

            -- accepts the common telescope picker config
            opts = {
              layout_strategy = "vertical",
              layout_config = {
                horizontal = { width = 0.9 },
                preview_width = 0.6,
              },
            },
          },

          -- `snacks` picker configurable via snacks config, 
          -- see https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
        }
      })
    end
  },

  { 'sniprun',
    cmd = {
      'SnipRun',
      'SnipInfo',
      'SnipClose',
      'SnipReset',
      'SnipReplMemoryClean'
    },
    keys = {
      { '<leader>rrs', function() require('sniprun').run('v') end, mode = {'n', 'v'}, desc = 'Run Snippets' },
      { '<leader>rro', '<Plug>SnipRunOperator', mode = {'n', 'v'}, desc = 'Run Snippets Operator' },
    },
    opts = {
      selected_interpreters = {
        "Generic",
        "Bash_original",
        "Rust_original",
        "Python3_fifo",
        "Lua_nvim",
      },
      repl_enable = {
        "Bash_original",
        "Lua_nvim",
        "Python3_fifo",
        "Rust_original",
      },               --# enable REPL-like behavior for the given interpreters
      repl_disable = {},              --# disable REPL-like behavior for the given interpreters

      interpreter_options = {         --# interpreter-specific options, see docs / :SnipInfo <name>

        Generic = {
            NushellBasic = {                    -- any key name is ok
                supported_filetypes = {"nu"}, -- mandatory
                extension = ".nu",                 -- recommended, but not mandatory. Sniprun use this to create temporary files

                interpreter = "nu",           -- interpreter or compiler (+ options if any)
                compiler = "",                     -- one of those MUST be non-empty
            },
        },


        --# use the interpreter name as key
        GFM_original = {
          use_on_filetypes = {"markdown.pandoc"}    --# the 'use_on_filetypes' configuration key is
                                                    --# available for every interpreter
        },
        Python3_original = {
            error_truncate = "auto"         --# Truncate runtime errors 'long', 'short' or 'auto'
                                            --# the hint is available for every interpreter
                                            --# but may not be always respected
        },
      },

      --# you can combo different display modes as desired and with the 'Ok' or 'Err' suffix
      --# to filter only sucessful runs (or errored-out runs respectively)
      display = {
        -- "Classic",                    --# display results in the command-line  area
        "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)

        -- "VirtualText",             --# display results as virtual text
        -- "TempFloatingWindow",      --# display results in a floating window
        -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText[Ok/Err]
        "Terminal",                --# display results in a vertical split
        "TerminalWithCode",        --# display results and code history in a vertical split
        "NvimNotify",              --# display with the nvim-notify plugin
        "Api"                      --# return output to a programming interface
      },

      live_display = { "VirtualTextOk" }, --# display mode used in live_mode

      display_options = {
        terminal_scrollback = vim.o.scrollback, -- change terminal display scrollback lines
        terminal_line_number = false, -- whether show line number in terminal window
        terminal_signcolumn = false, -- whether show signcolumn in terminal window
        terminal_width = 45,       --# change the terminal display option width
        notification_timeout = 5   --# timeout for nvim_notify output
      },

      --# You can use the same keys to customize whether a sniprun producing
      --# no output should display nothing or '(no output)'
      show_no_output = {
        "Classic",
        "TempFloatingWindow",      --# implies LongTempFloatingWindow, which has no effect on its own
      },

      --# customize highlight groups (setting this overrides colorscheme)
      snipruncolors = {
        SniprunVirtualTextOk   =  {bg="#66eeff",fg="#000000",ctermbg="Cyan",ctermfg="Black"},
        SniprunFloatingWinOk   =  {fg="#66eeff",ctermfg="Cyan"},
        SniprunVirtualTextErr  =  {bg="#881515",fg="#000000",ctermbg="DarkRed",ctermfg="Black"},
        SniprunFloatingWinErr  =  {fg="#881515",ctermfg="DarkRed"},
      },

      live_mode_toggle='off',     --# live mode toggle, either 'off' or 'enable'

      --# miscellaneous compatibility/adjustement settings
      inline_messages = false,    --# boolean toggle for a one-line way to display messages
                                  --# to workaround sniprun not being able to display anything

      borders = 'single',         --# display borders around floating windows
                                  --# possible values are 'none', 'single', 'double', or 'shadow'
    }
  }

}
