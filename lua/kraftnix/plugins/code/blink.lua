local components = {
  item_idx = {
    text = function(ctx) return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx) end,
    highlight = 'BlinkCmpItemIdx' -- optional, only if you want to change its color
  },
  extra_info = {
    width = { max = 30 },
    text = function(ctx)
      -- vim.print(ctx)
      return ctx.item.detail
    end,
    highlight = 'BlinkCmpLabelDetail' -- optional, only if you want to change its color
  }
}

-- add colorful-menu label config if enabled
if nixCats('colorful-menu') then
  components.label = {
    text = function(ctx)
      return require("colorful-menu").blink_components_text(ctx)
    end,
    highlight = function(ctx)
      return require("colorful-menu").blink_components_highlight(ctx)
    end,
  }
end

if nixCats('blink') then
  return {
    'Saghen/blink.cmp',
    event = "InsertEnter",
    dependencies = {
      -- cmp
      'saghen/blink.compat',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',

      -- misc
      'onsails/lspkind.nvim', -- icons

      -- providers
      'disrupted/blink-cmp-conventional-commits',
      "mikavilpas/blink-ripgrep.nvim",

      -- snippets
      'l3mon4d3/luasnip',             -- write custom snippets
      'rafamadriz/friendly-snippets', -- snippets collection
    },
    keycommands = {
      -- didnt work
      -- { '<C-P', h.lr('cmp', 'complete'), 'Cmp Complete', 'CmpComplete', modes = {'n'} }
    },
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      snippets = {
        -- preset = 'luasnip'
      },
      -- cmdline = {
      --   enabled = true,
      --   completion = {
      --     ghost_text = {
      --       enabled = true,
      --     },
      --     menu = {
      --       auto_show = true,
      --     },
      --   },
      -- },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'omni', 'buffer', 'ripgrep', },
        per_filetype = {
          cmdline = { 'cmdline', 'cmdline_cmp', 'cmdline_history', 'path' },
          gitcommit = { 'snippets', 'conventional_commits', 'omni', 'buffer', 'ripgrep' },
        },
        providers = {
          lsp = {
            fallbacks = { 'ripgrep', 'buffer', 'omni', 'path', },
            override = {
              get_trigger_characters = function(self)
                local trigger_characters = self:get_trigger_characters()
                -- add space, tab and enter to default trigger characters
                -- vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
                return trigger_characters
              end
            },
            -- timeout_ms = 5000,
            score_offset = 20
          },
          snippets = {
            opts = {
              search_paths = { vim.fn.expand("$HOME/.config/nvim/lua/kraftnix/snippets") },
            },
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
          },
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            score_offset = 100,
          },
          cmdline_cmp = {
            name = "cmdline",
            module = "blink.compat.source",
            score_offset = -3,
          },
          conventional_commits = {
            name = 'Conventional Commits',
            module = 'blink-cmp-conventional-commits',
            enabled = function()
              return vim.bo.filetype == 'gitcommit'
            end,
            ---@module 'blink-cmp-conventional-commits'
            ---@type blink-cmp-conventional-commits.Options
            opts = {},         -- none so far
          },
        },
      },
      signature = {
        enabled = true,
      },
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<A-y>'] = {
          function(cmp)
            cmp.show { providers = { 'minuet' } }
          end,
          'fallback'
        },
        ['<C-space>'] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_and_accept()
            else
              return cmp.show()
            end
          end,
          'fallback'
        },
        ['<C-s>'] = { function(cmp) cmp.show({ providers = { 'lsp' } }) end },
        ['<C-f>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-l>'] = { 'show_documentation', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
        ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
        ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
        ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
        ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
        ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
        ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
        ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
        ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
        ['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
      },
      -- information = {
      --   -- snippets = { preset = 'default' },
      --   -- signature = { enabled = true },
      -- },
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
          -- 'exact',
          --defaults
          'score',
          'sort_text',
        }
      },
      -- accept = { auto_brackets = { enabled = true }, },
      completion = {
        trigger = {
          show_on_keyword = true,
          show_in_snippet = true,
          show_on_trigger_character = true,
          -- show_on_accept_on_trigger_character = true,
          show_on_accept_on_trigger_character = false,
          show_on_insert_on_trigger_character = true,
          -- LSPs can indicate when to show the completion window via trigger characters
          -- however, some LSPs (i.e. tsserver) return characters that would essentially
          -- always show the window. We block these by default.
          show_on_blocked_trigger_characters = function()
            -- NOTE: don't show in cmdline mode
            if vim.api.nvim_get_mode().mode == 'c' then return {} end
            return {}
            -- you can also block per filetype, for example:
            -- if vim.bo.filetype == 'markdown' then
            --   return { ' ', '\n', '\t', '.', '/', '(', '[' }
            -- end

            -- return { ' ', '\n', '\t' }
          end,
        },
        keyword = {
          range = 'full'
        },
        ghost_text = {
          enabled = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'single'
          }
        },
        menu = {
          border = 'single',
          -- nvim-cmp style menu
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { "item_idx" },
              { "kind_icon" },
              { "label",      "label_description", gap = 1 },
              { "kind" },
              { "source_name" },
              { "extra_info" },
            },
            components = components
          }
        },
      },
    },
    opts_extend = { "sources.default" },
  }
else
  return {}
end
