local h = require('utils.helper')
return {
  -- buffer manager
  { 'harpoon',
    cmd = 'Harpoon',
    keys = {
      { '<leader>hf', ':Telescope harpoon marks<CR>', desc = '[h]arpoon [f]ind marks' },
      { '<leader>hm', h.lr('harpoon.ui', 'toggle_quick_menu'), desc = '[h]arpoon toggle quick [m]enu' },
      { '<leader>hh', h.lr('harpoon.mark', 'add_file'), desc = '[hh]arpoon add mark' },
      { '<leader>hn', h.lr('harpoon.ui', 'nav_next'), desc = '[h]arpoon go to [n]ext mark' },
      { '<leader>hp', h.lr('harpoon.ui', 'nav_prev'), desc = '[h]arpoon go to [p]rev mark' },
      { '<leader>ht', h.lr('harpoon.cmd-ui', 'toggle_quick_menu'), desc = '[h]arpoon toggle [t]erminal quick menu' },
    },
    after = function ()
      require("harpoon").setup({
        -- don't change tabline
        tabline = false,
        global_settings = {
          tabline = false,
        },
      })
      require("telescope").load_extension('harpoon')
    end
  },

  { "portal.nvim",
    cmd = 'Portal',
    keys = {
      { '<leader>i', ':Portal jumplist forward<CR>', desc = 'Portal jumplist forward' },
      { '<leader>o', ':Portal jumplist backward<CR>', desc = 'Portal jumplist backward' },
      { '<leader>]c', ':Portal changelist forward<CR>', desc = 'Portal changelist forward' },
      { '<leader>[c', ':Portal changelist backward<CR>', desc = 'Portal changelist backward' },
      { '<leader>]h', ':Portal harpoon forward<CR>', desc = 'Portal harpoon forward' },
      { '<leader>[h', ':Portal harpoon backward<CR>', desc = 'Portal harpoon backward' },
      { '<leader>]q', ':Portal quickfix forward<CR>', desc = 'Portal quickfix forward' },
      { '<leader>[q', ':Portal quickfix backward<CR>', desc = 'Portal quickfix backward' },
      { '<leader>]g', ':Portal grapple forward<CR>', desc = 'Portal grapple forward' },
      { '<leader>[g', ':Portal grapple backward<CR>', desc = 'Portal grapple backward' },
    },
    after = function ()
      require('portal').setup({})
    end
  }
}
