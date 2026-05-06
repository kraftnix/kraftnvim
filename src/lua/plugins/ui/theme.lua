return {
  {
    -- :lua nixInfo.lze.debug.display(nixInfo.plugins)
    "onedarkpro.nvim",
    auto_enable = true, -- <- auto enable is useful here
    colorscheme = { "onedark", "onedark_dark", "onedark_vivid", "onelight" },
  },
  {
    "vim-moonfly-colors",
    auto_enable = true,
    colorscheme = "moonfly",
  },
  { "nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { },
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
}
