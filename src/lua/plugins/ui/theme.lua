return {
  -- :lua nixInfo.lze.debug.display(nixInfo.plugins)
  { "onedarkpro.nvim",
    auto_enable = true, -- <- auto enable is useful here
    colorscheme = { "onedark", "onedark_dark", "onedark_vivid", "onelight" },
  },

  { "vim-moonfly-colors",
    auto_enable = true,
    colorscheme = "moonfly",
  },

  { "nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { },
  },

  { 'rainbow-delimiters.nvim',
    after = function()
      local rainbow_delimiters = require 'rainbow-delimiters'
      require'rainbow-delimiters.setup'.setup {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterGreen',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterCyan',
          'RainbowDelimiterViolet',
        },
      }
    end
  },

  { "tokyonight.nvim",
    priority = 9000,
    after = function ()
      require('tokyonight').setup({
        style = 'night',
        terminal_colors = true,
        lualine_bold = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
        on_colors = function(colors)
          colors.hint = colors.orange
          colors.error = "#ff0000"
          colors.comment = colors.green2
          vim.g.all_colors = colors
        end,
        on_highlights = function(hl, c)
          local util = require("tokyonight.util")

          local fieldColour = c.red
          local keyword = c.green
          local stringColour = c.magenta

          -- local fieldColour = c.magenta
          -- local keyword = c.green
          -- local stringColour = c.orange

          -- local fieldColour = c.orange
          -- local keyword = c.magenta
          -- local stringColour = c.green

          local purple = "#f97cd8"
          local bold = function (opts) vim.tbl_extend('force', { style = { bold = true } }, opts) end
          local parameter = { fg = util.lighten (c.yellow, 0.5) }
          hl["@string"] = { fg = stringColour, }
          --- field/property
          hl["@field"] = { fg = fieldColour, }
          hl["@property"] = { fg = fieldColour, }
          --- parameter
          hl["@parameter"] = parameter
          hl["@variable"] = parameter
          --- keyword
          hl.Keyword = bold { fg = purple, bg = keyword }
          hl['@keyword'] = bold { fg = purple, bg = keyword }
          ---core
          hl['@keyword'] = bold { fg = purple, bg = keyword }
          hl["@boolean"] = { fg = c.cyan, }
          hl["@number"] = { fg = c.red, }
          --- Telescope
          hl.TelescopePromptBorder = { fg = c.orange, }
          hl.TelescopePromptTitle = { fg = c.orange, }
          hl.TelescopeResultsBorder = { fg = c.green, }
          hl.TelescopeResultsTitle = { fg = c.green, }
          hl.TelescopeResultsTitle = { fg = c.green, }
          --- LSP
          hl.DiagnosticUnnecessary = { fg = c.comment }
          -- Flash
          hl.FlashBackdrop = { fg = c.purple }
        end
      })
      vim.g.tokyonight_colors = require 'tokyonight.colors'
    end
  },

  -- scrolling changes, may feel a little lagy, not sure
  -- too laggy
  { "neoscroll.nvim",
    enabled = false,
    after = function ()
      require('neoscroll').setup({
        easing_function = "quadratic"
      })
      local t = {}
      local scrollspeed = 100
      -- local easingfunction = [['sine']]
      local easingfunction = [['circular']]
      -- Syntax: t[keys] = {function, {function arguments}}
      t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', tostring(scrollspeed), easingfunction}}
      t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', tostring(scrollspeed), easingfunction}}
      t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '450'}}
      t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '450'}}
      t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
      t['<C-e>'] = {'scroll', { '0.10', 'false', '100'}}
      t['zt']    = {'zt', {'250'}}
      t['zz']    = {'zz', {'250'}}
      t['zb']    = {'zb', {'250'}}

      require('neoscroll.config').set_mappings(t)
    end
  },
}
