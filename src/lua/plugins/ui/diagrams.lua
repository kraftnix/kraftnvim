return {
  { "image.nvim",
    enabled = nixInfo(false, "settings", "diagrams", "enable"),
    ft = { "markdown" }, -- complains a lot otherwise
    dep_of = { 'diagrams.nvim' },
    after = function ()
      require('image').setup({
        backend = "kitty",
        processor = "magick_cli",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            only_render_image_at_cursor_mode = "popup", -- or "inline"
            floating_windows = false, -- if true, images will be rendered in floating markdown windows
            filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
            resolve_image_path = function(document_path, image_path, fallback)
              -- document_path is the path to the file that contains the image
              -- image_path is the potentially relative path to the image. for
              -- markdown it's `![](this text)`

              -- you can call the fallback function to get the default behavior
              return fallback(document_path, image_path)
            end,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        scale_factor = 1.0,
        window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
        editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      })
    end
  },

  { 'd2-vim',
    enabled = nixInfo(false, "settings", "diagrams", "enable") and nixInfo(false, "settings", "diagrams", "d2"),
    ft = 'd2',
  },

  { 'tree-sitter-d2',
    enabled = nixInfo(false, "settings", "diagrams", "enable") and nixInfo(false, "settings", "diagrams", "d2"),
  },

  { "diagram.nvim",
    enabled = nixInfo(false, "settings", "diagrams", "enable"),
    -- TODO: fixup
    ft = { "markdown" }, -- causes complaints due to image.nvim / tmux passthrough on some machines, so enforce only for markdown for now
    keys = {
      -- didnt work
      { '<leader>ldd',
        function ()
          require('diagram').show_diagram_hover()
        end,
        desc = "Toggle diagrams visibility in buffer",
        -- ft = { "markdown", "norg" }, -- Only in these filetypes
      },
      -- { '<C-P', h.lr('cmp', 'complete'), 'Cmp Complete', 'CmpComplete', modes = {'n'} }
    },
    after = function ()
      require('diagram').setup({
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
      })
    end,
  },
}

