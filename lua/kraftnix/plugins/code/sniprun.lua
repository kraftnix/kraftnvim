local h = KraftnixHelper
return {
  'michaelb/sniprun',
  keycommands = {
    h.mapSilent { '<leader>rrs', '<Plug>SnipRun', mode = {'n', 'v'}, group = 'Run Snippets' },
    h.mapSilent { '<leader>rro', '<Plug>SnipRunOperator', mode = {'n', 'v'}, group = 'Run Snippets' },
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
