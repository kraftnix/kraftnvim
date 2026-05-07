local h = require('utils.helper')
return {

  -- search/replace in multiple files
  -- need to set up
  -- https://github.com/nvim-pack/nvim-spectre
  { "nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>rss", 'Spectre', desc = "Toggle Spectre (search)" },
      { "<leader>rss", h.lr('spectre', 'toggle'), desc = "Toggle Spectre (search)" },
      { "<leader>rsw", h.lr('spectre', 'open_visual', {select_work=true}), desc = "Search current word" },
      { "<leader>rsw", '<esc><cmd>lua require("spectre").open_visual()<cr>', desc = "Search current word (visual)", mode = 'v', is_nvim_command = true },
      { "<leader>rsf", h.lr('spectre', 'open_file_search', {select_work=true}), desc = "Search on current file" },
    },
    after = function ()
      require('spectre').setup({
        open_cmd = "noswapfile vnew",
        mapping = { }
      })
    end
  },


  -- markdown previewer
  { 'render-markdown.nvim',
    cmd = "RenderMarkdown",
    keys = {
      { '<leader>am', ':RenderMarkdown toggle<CR>', desc = 'Toggle render-markdown plugin' },
    },
    after = function ()
      require('render-markdown').setup({
        completions = {
          lsp = { enabled = true },
        },
      })
    end
  },


  -- fancy split/join of arrays/sets etc. using treesitter
  { "treesj",
    cmd = 'TSJToggle',
    keys = {
      { "<leader>J", ":TSJToggle<CR>", desc = "Join Toggle" },
    },
    after = function ()
      require('treesj').setup({
        use_default_keymaps = false,
        max_join_length = 250,
      })
    end
  },

  -- smarter indent
  { 'guess-indent.nvim',
    event = 'DeferredUIEnter',
    after = function ()
      require('guess-indent').setup({
        auto_cmd = true,
      })
    end
  },

  -- TODO: debug why not adding SudaWrite cmd
  -- use `!!` to use sudo to write as root
  { 'suda.vim',
    event = 'DeferredUIEnter',
    cmd = { 'SudaWrite', 'SudaRead' },
    keys = {
      { 'w!!', ':SudaWrite<CR>', desc = "Escalate privileges with sudo and write current buffer", modes = { 'n', 'c' }, silent = true },
    },
    -- after = function ()
    --   require('suda.vim').setup()
    -- end
  },

    -- "gc" to comment visual regions/lines
  { 'comment.nvim',
    -- enabled = false,
    event = 'DeferredUIEnter',
    after = function ()
      require('Comment').setup({
        padding = true,
        sticky = true,
        toggler = {
          line = 'gcc',
          block = 'gbc',
        },
      })
    end
  },

    -- increment / decrement colors/dates/etc.
  { "dial.nvim",
    keys = {
      { mode = "v", "<M-m>", '<Plug>(dial-increment)', desc = 'smart increment (dial)', noremap = true},
      { mode = "v", "<M-n>", '<Plug>(dial-decrement)', desc = 'smart decrement (dial)', noremap = true},
      { mode = "n", "<M-m>", '<Plug>(dial-increment)', desc = 'smart increment (dial)', noremap = true},
      { mode = "n", "<M-n>", '<Plug>(dial-decrement)', desc = 'smart decrement (dial)', noremap = true},
    },
    after = function()
      local augend = require("dial.augend")
      local conf = require('dial.config').augends
      conf:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.constant.new({ elements = { "let", "const" } }),
          augend.semver.alias.semver,
          augend.hexcolor.new({
            case = "lower"
          }),
        },
      })
    end,
  },

  { "ssr.nvim",
    keys = {
      { "<leader>rNs",
        h.lr("ssr", 'open'),
        desc = "Structural Replace",
        mode = { "n", "x" },
      },
    },
    after = function ()
      require('ssr').setup({
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        }
      })
    end
  },

  { "quickselect.nvim",
    keys = {
      { "<c-s><c-n>", h.lr('quickselect', 'quick_select'), desc = "Quick select", mode = { "n", "x", "o" } },
      { "<c-s><c-y>", h.lr('quickselect', 'quick_yank'), desc = "Quick yank", mode = { "n", "x", "o" } },
    },
    after = function ()
      require('quickselect').setup({
        patterns = {
        -- Hex color
        "#%x%x%x%x%x%x",
        -- Short-Hex color
        "#%x%x%x",
        -- RGB color
        "rgb(%d+,%d+,%d+)",
        -- IP Address
        "%d+%.%d+%.%d+%.%d+",
        -- Email
        "%w+@%w+%.%w+",
        -- URL
        "https?://[%w-_%.%?%.:/%+=&]+",
        -- 4+ digit number
        "%d%d%d%d+",
        -- File path
        "~/[%w-_%.%?%.:/%+=&]+",
        -- File path 2
        "[%.]+/[%w-_%.%?%.:/%+=&]+",
        -- File path 3
        "[%s]+/[%w-_%.%?%.:/%+=&]+",
        -- github flake URL
        "github:[%w-_%.%?%.:/%+=&]+",
        -- sha hash
        "sha256-[%w-_%.%?%.:/%+]+=",
      },
      select_match = true,
      use_default_patterns = true,
      labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
      -- keymap = {
      --   {
      --     mode = { 'n' },
      --     '<leader>js',
      --     function()
      --       require('quickselect').quick_select()
      --     end,
      --     desc = 'Quick select'
      --   },
      --   {
      --     mode = { 'n' },
      --     '<leader>jy',
      --     function()
      --       require('quickselect').quick_yank()
      --     end,
      --     desc = 'Quick yank'
      --   }
      -- },


      })
    end
  },

}
