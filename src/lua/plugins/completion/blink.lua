return {
  -- cmp
  {
    "cmp-cmdline",
    for_cat = 'blink',
    auto_enable = true,
    on_plugin = { "blink.cmp" },
    load = nixInfo.lze.loaders.with_after,
  },
  {
    "cmp-cmdline-history",
    for_cat = 'blink',
    auto_enable = true,
    on_plugin = { "blink.cmp" },
    load = nixInfo.lze.loaders.with_after,
  },
  {
    "blink-cmp-conventional-commits",
    for_cat = 'blink',
    auto_enable = true,
    dep_of = { "blink.cmp" },
  },
  {
    "blink-ripgrep.nvim",
    for_cat = 'blink',
    auto_enable = true,
    dep_of = { "blink.cmp" },
  },
  {
    "blink.compat",
    for_cat = 'blink',
    auto_enable = true,
    dep_of = { "cmp-cmdline", "blink.cmp" },
  },
  {
    "colorful-menu.nvim",
    for_cat = 'blink',
    auto_enable = true,
    on_plugin = { "blink.cmp" },
  },

  -- icons
  {
    "lspkind.nvim",
    for_cat = 'blink',
    auto_enable = true,
    on_plugin = { "blink.cmp" },
  },
  {
    "nvim-web-devicons",
    for_cat = 'blink',
    auto_enable = true,
    on_plugin = { "blink.cmp" },
  },

  { 'blink.cmp',
    enabled = nixInfo("", "settings", "completion", "default") == "blink",
    for_cat = 'blink',
    event = "InsertEnter",
    after = function (_)
      local snippetsConf = vim.empty_dict()
      if nixInfo(false, 'settings', 'snippets', 'enable') then
        snippetsConf = { preset = 'luasnip' }
      end
      require("blink.cmp").setup({
        -- See :h blink-cmp-config-keymap for configuring keymaps
        keymap =  {
          preset = 'default',
          ['<CR>'] = { 'select_and_accept', 'fallback' },
          -- ['<A-y>'] = {
          --   function(cmp)
          --     cmp.show { providers = { 'minuet' } }
          --   end,
          --   'fallback'
          -- },
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
        snippets = snippetsConf,
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },
        fuzzy = {
          implementation = 'prefer_rust_with_warning',
          sorts = {
            -- 'exact',
            --defaults
            'score',
            'sort_text',
          }
        },
        cmdline = {
          enabled = nixInfo(false, "settings", "completion", "commandline", "enable"),
          completion = {
            ghost_text = {
              enabled = true,
            },
            menu = {
              auto_show = true,
            },
          },
          sources = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == '/' or type == '?' then return { 'buffer' } end
            -- Commands
            if type == ':' or type == '@' then return { 'cmdline', 'cmp_cmdline' } end
            return {}
          end,
        },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
          },
        },
        -- information = {
        --   -- snippets = { preset = 'default' },
        --   -- signature = { enabled = true },
        -- },
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
              components = {
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
                },
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
                kind_icon = {
                  text = function(ctx)
                    local icon = ctx.kind_icon
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                        icon = dev_icon
                      end
                    else
                      icon = require("lspkind").symbol_map[ctx.kind] or ""
                    end

                    return icon .. ctx.icon_gap
                  end,

                  -- Optionally, use the highlight groups from nvim-web-devicons
                  -- You can also add the same function for `kind.highlight` if you want to
                  -- keep the highlight groups in sync with the icons.
                  highlight = function(ctx)
                    local hl = ctx.kind_hl
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                        hl = dev_hl
                      end
                    end
                    return hl
                  end,
                }
              },
            }
          },
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'omni', 'buffer', 'ripgrep', },
          per_filetype = {
            cmdline = { 'cmdline', 'cmdline_cmp', 'cmdline_history', 'path' },
            gitcommit = { 'snippets', 'conventional_commits', 'omni', 'buffer', 'ripgrep' },
          },
          providers = {
            path = {
              score_offset = 50,
            },
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
            snippets = snippets,
            ripgrep = {
              module = "blink-ripgrep",
              name = "Ripgrep",
            },
            -- minuet = {
            --   name = 'minuet',
            --   module = 'minuet.blink',
            --   score_offset = 100,
            -- },
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
      })
    end,
  }
}
