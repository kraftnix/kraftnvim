local h = KraftnixHelper
return {
  {
    "3rd/diagram.nvim",
    dependencies = {
      { "3rd/image.nvim", opts = {} }, -- you'd probably want to configure image.nvim manually instead of doing this
      { "ravsii/tree-sitter-d2" },
      { "terrastruct/d2-vim", ft = "d2" },
    },
    keycommands = {
      -- didnt work
      { '<leader>ldd', h.lr('diagram', 'show_diagram_hover'), "Toggle diagrams visibility in buffer", 'DiagramsToggle', mode = "n", opts = {
        -- ft = { "markdown", "norg" }, -- Only in these filetypes
      } },
      -- { '<C-P', h.lr('cmp', 'complete'), 'Cmp Complete', 'CmpComplete', modes = {'n'} }
    },
    opts = { -- you can just pass {}, defaults below
      -- NOTE: having issues with toggling diagram
      -- Disable automatic rendering for manual-only workflow
      -- events = {
      --   render_buffer = { },
      --   clear_buffer = { "BufLeave" },
      -- },
      events = {
        render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
        clear_buffer = { "BufLeave" },
      },
      renderer_options = {
        mermaid = {
          background = "transparent", -- nil | "transparent" | "white" | "#hex"
          theme = "dark",             -- nil | "default" | "dark" | "forest" | "neutral"
          scale = 1,                  -- nil | 1 (default) | 2  | 3 | ...
          width = nil,                -- nil | 800 | 400 | ...
          height = nil,               -- nil | 600 | 300 | ...
          cli_args = nil,             -- nil | { "--no-sandbox" } | { "-p", "/path/to/puppeteer" } | ...
        },
        plantuml = {
          charset = nil,
          cli_args = nil, -- nil | { "-Djava.awt.headless=true" } | ...
        },
        d2 = {
          theme_id = 200,
          dark_theme_id = 201,
          scale = nil,
          layout = nil,
          sketch = nil,
          -- cli_args = nil, -- nil | { "--pad", "0" } | ...
          cli_args = { "--stdout-format", "svg" }
        },
        gnuplot = {
          size = nil,     -- nil | "800,600" | ...
          font = nil,     -- nil | "Arial,12" | ...
          theme = nil,    -- nil | "light" | "dark" | custom theme string
          cli_args = nil, -- nil | { "-p" } | { "-c", "config.plt" } | ...
        },
      }
    },
  },
}
