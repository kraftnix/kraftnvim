local h = require('utils.helper')
return {
  -- documentation generation
  { "neogen",
    keys = {
      { '<leader>dgd', h.lr('neogen', 'generate'), desc = '[d]ocumentation [g]eneration ([d]efault)', grou = 'Documentation' }
    },
    after = function ()
      require('neogen').setup({})
    end
  },

  -- documentation lookup
  { 'nvim-devdocs',
    cmd = { 'DevdocsOpen', 'DevdocsInstall', 'DevdocsUpdate', 'DevdocsOpenCurrentFloat' },
    keys = {
      { '<leader>lfd', 'DevdocsOpenCurrentFloat', desc = 'lookup devdocs for current filetype', group = 'Documentation' },
      { '<leader>fdd', 'DevdocsOpen', desc = '[d]evdocs documentation lookup', group = 'Documentation' },
      { '<leader>fdi', 'DevdocsInstall', desc = '[d]evdocs [i]nstall', group = 'Documentation' },
      { '<leader>fdu', 'DevdocsUpdate', desc = '[d]evdocs [u]pdate', group = 'Documentation' },
    },
    after = function ()
      require('devdocs').setup({
        mappings = { -- keymaps for the doc buffer
          open_in_browser = "<C-F><C-F>"
        },
        ensure_installed = {
          'lua',
          'nix',
          'nushell',
          'rust',
          'css',
          'html',
          'http',
          'javascript',
          'git',
          'i3',
          'jq',
          'postgresql',
          'python'
        }, -- get automatically installed
      })
    end
  },



}
