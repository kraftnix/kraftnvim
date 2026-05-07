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
      { '<leader>lfd', 'DevdocsOpenCurrentFloat', desc = 'lookup devdocs for current filetype' },
      { '<leader>fdd', 'DevdocsOpen', desc = '[d]evdocs documentation lookup' },
      { '<leader>fdi', 'DevdocsInstall', desc = '[d]evdocs [i]nstall' },
      { '<leader>fdu', 'DevdocsUpdate', desc = '[d]evdocs [u]pdate' },
    },
    after = function ()
      require('nvim-devdocs').setup({
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
