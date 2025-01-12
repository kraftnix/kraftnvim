local h = KraftnixHelper

-- autopairing of (){}[] etc
local autopairs = {
  "windwp/nvim-autopairs",
  dependencies = { 'hrsh7th/nvim-cmp' },
  opts = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)

    -- setup cmp for autopairs
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}


-- enable cmp cmdline capabilities
local nvim_cmp_cmdline = {
  'hrsh7th/cmp-cmdline',
  event = "CmdlineEnter",
  dependencies = {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-rg',
    'dmitmel/cmp-cmdline-history',
  },
  config = function()
    local cmp = require 'cmp'
    local cmdline_mapping = cmp.mapping.preset.cmdline({
      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }, { 'i', 'c' }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }, { 'i', 'c' }),
    })
    vim.api.nvim_set_keymap("c", "<c-p>", [[ wildmenumode() ? "c-p>" : "<up>" ]], { noremap = true, expr = true }) -- expr mapping

    cmp.setup.cmdline(":", {
      -- native looks way better but breaks in cmdline view
      -- check: https://github.com/hrsh7th/nvim-cmp/issues/1142
      view = { entries = { name = "custom", selection_order = "near_cursor" } },
      -- view = { entries = "native" },
      mapping = cmdline_mapping,
      sources = cmp.config.sources({
        -- { name = "cmdline", option = { ignore_cmds = { "lua" } } },
        { name = "cmdline",         priority = 3 },
        { name = "cmdline_history", priority = 5, keyword_length = 4 },
        { name = "path",            priority = 15 },
        -- {
        --   name = "buffer",
        --   keyword_length = 4,
        --   option = { keyword_pattern = anyWord },
        -- },
      }),
      sorting = {
        priority_weight = 1.0,
        comparators = {
          -- compare.locality,
          -- compare.recently_used,
          -- compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
          -- compare.offset,
          -- compare.order,

          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.offset,
          cmp.config.compare.order,
        },
      },
    })
    cmp.setup.cmdline("/", {
      -- native looks way better but breaks in cmdline view
      -- check: https://github.com/hrsh7th/nvim-cmp/issues/1142
      view = { entries = { name = "custom", selection_order = "near_cursor" } },
      mapping = cmdline_mapping,
      sources = cmp.config.sources({
        { name = "cmdline_history", keyword_length = 3 },
        { name = "rg",              keyword_length = 3 },
        {
          name = "buffer",
          -- keyword_length = 4,
          -- option = { keyword_pattern = anyWord },
        },
      }),
    })
  end,

}

local nvim_cmp = {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  dependencies = {
    -- misc
    'onsails/lspkind.nvim', -- icons

    -- sources
    'saadparwaiz1/cmp_luasnip', -- luasnip
    'hrsh7th/cmp-nvim-lsp',     -- lsp
    'hrsh7th/cmp-buffer',       -- open buffera
    'hrsh7th/cmp-path',         -- complete paths
    'hrsh7th/cmp-rg',           -- rg in local files
    -- {'tzachar/cmp-fuzzy-buffer',
    --   nix_disable = true,
    --   dependencies = {
    --     'tzachar/fuzzy.nvim'
    --   }
    -- },
    -- h.NixPlugin('hrsh7th/cmp-nixpkgs'),    -- nixpkgs (legacy)

    'ray-x/cmp-treesitter',
    'FelipeLema/cmp-async-path',
    -- snippets
    'l3mon4d3/luasnip',             -- write custom snippets
    'rafamadriz/friendly-snippets', -- snippets collection

    -- comparators
    'lukas-reineke/cmp-under-comparator', -- sorts __ lower than others in fields
  },
  keycommands = {
    -- didnt work
    -- { '<C-P', h.lr('cmp', 'complete'), 'Cmp Complete', 'CmpComplete', modes = {'n'} }
  },

  -- [[ Configure nvim-cmp ]]
  -- See `:help cmp`
  config = function()
    local cmp = require 'cmp'
    local lspkind = require 'lspkind'
    lspkind.init({
      mode = "symbol-text",
      preset = "default",
    })
    local luasnip = require 'luasnip'
    local icons = require("lspkind").presets.default


    -- cmp setup
    ---@diagnostic disable-next-line: redundant-parameter
    cmp.setup {
      experimental = {
        ghost_text = true,
      },

      performance = {
        -- debounce = 0,
        -- throttle = 0,
        -- fetching_timeout = 500,
        -- confirm_resolve_timeout = 80,
        -- async_budget = 1,
        -- max_view_entries = 400,
      },

      completion = {
        autocomplete = {
          cmp.TriggerEvent.TextChanged,
          cmp.TriggerEvent.InsertEnter,
        },
        completeopt = "menuone,noinsert,noselect",
        keyword_length = 2,
      },

      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        -- { name = 'nixpkgs' },
        -- { name = 'nixos' },
        { name = "nvim_lua" },
        --{ name = 'orgmode' },
        { name = "luasnip" },
        -- { name = 'vsnip' },
        -- { name = 'fuzzy_buffer' },
        -- { name = 'fuzzy_buffer' ,
        --   option = {
        --     get_bufnrs = function()
        --       local bufs = {}
        --       for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        --         local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
        --         if buftype ~= 'nofile' and buftype ~= 'prompt' then
        --           bufs[#bufs + 1] = buf
        --         end
        --       end
        --       return bufs
        --     end
        --   },
        -- },
      }, {
        { name = "treesitter" },
      }, {
        -- { name = 'path' },
        { name = 'async_path' },
      }, {
        -- { name = "rg", max_item_count = 10 }, -- causing massive slowdowns
        { name = 'buffer', keyword_length = 3 },
        -- { name = 'buffer', options = {
        --   get_bufnrs = function()
        --     return vim.api.nvim_list_bufs()
        --   end
        -- } },
      }),

      view = {
        -- entries = "native",
        -- entries = { name = "custom", selection_order = "near_cursor" }.
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        --['<C-e>'] = cmp.mapping.close(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        -- ['<C-z>'] = cmp.complete(),

        -- ['<C-s>'] = cmp.mapping.confirm({ select = true }),
        -- ['<CR>'] = cmp.mapping.confirm({ select = false }),

        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },

      formatting = {
        fields = { "kind", "abbr", "menu" },


        format = function(entry, vim_item)
          local kinds = lspkind.presets.default
          -- extras for TreeSitter source
          kinds['VariableMember'] = kinds['Variable']
          kinds['Comment'] = "#"
          kinds['None'] = "_"
          kinds['String'] = kinds['Text']
          if not (vim_item.kind == "Attr") then
            vim_item.kind = (kinds[vim_item.kind] or "[??]") .. " " .. vim_item.kind
          end
          -- local msg = string.format('CMPDEBUG:\n%s\n%s\n____', vim.inspect(entry), vim.inspect(vim_item))
          -- require('notify'). (msg, 'info')
          -- require('noice').redirect(function ()
          --   vim.print(msg)
          -- end)
          -- local js = vim.fn.json_encode(entry)
          -- vim.fn.writefile({entry[1]}, "cmp-event-json.log", 'a')
          local menu = ({
            rg = "[RG]",
            path = "[Path]",
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            nixpkgs = "[nixpkgs]",
            nixos = "[nixos]",
            luasnip = "[LuaSnip]",
            vsnip = "[VSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[Latex]",
            cmdline = "[Cmd]",
            cmdline_history = "[Hist]",
            treesitter = "[TS]",
            --orgmode = "[Org]",
          })[entry.source.name]
          if entry.source.name == 'cmdline' then
            vim_item = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            vim_item.kind = "λ"
            vim_item.menu = menu
          elseif entry.source.name == 'cmdline_history' then
            vim_item = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            vim_item.kind = "∞"
            vim_item.menu = menu
          else
            local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = (strings[1] or "") .. " "
            if entry.completion_item.detail == nil then
              kind.menu = "  (" .. (strings[2] or "") .. ") " .. (menu or "[]")
            else
              kind.menu = "  (" .. (strings[2] or "") .. ") " .. "<" .. entry.completion_item.detail .. ">"
            end
            -- kind.info = menu or "[]"
            vim_item = kind
          end

          return vim_item
        end,

        -- format = function(entry, vim_item)
        --   local kinds = lspkind.presets.default
        --   -- extras for TreeSitter source
        --   kinds['VariableMember'] = kinds['Variable']
        --   kinds['Comment'] = "#"
        --   kinds['None'] = "_"
        --   kinds['String'] = kinds['Text']
        --   if not (vim_item.kind == "Attr") then
        --     vim_item.kind = (kinds[vim_item.kind] or "[Unknown]") .. " " .. vim_item.kind
        --   end
        --   -- local msg = string.format('CMPDEBUG:\n%s\n%s\n____', vim.inspect(entry), vim.inspect(vim_item))
        --   -- require('notify'). (msg, 'info')
        --   -- require('noice').redirect(function ()
        --   --   vim.print(msg)
        --   -- end)
        --   -- local js = vim.fn.json_encode(entry)
        --   -- vim.fn.writefile({entry[1]}, "cmp-event-json.log", 'a')
        --   local menu = ({
        --     rg = "[RG]",
        --     path = "[Path]",
        --     buffer = "[Buffer]",
        --     nvim_lsp = "[LSP]",
        --     nixpkgs = "[nixpkgs]",
        --     nixos = "[nixos]",
        --     luasnip = "[LuaSnip]",
        --     vsnip = "[VSnip]",
        --     nvim_lua = "[Lua]",
        --     latex_symbols = "[Latex]",
        --     cmdline = "[Cmd]",
        --     cmdline_history = "[Hist]",
        --     treesitter = "[TS]",
        --     --orgmode = "[Org]",
        --   })[entry.source.name]
        --   if entry.source.name == 'cmdline' then
        --     vim_item = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        --     vim_item.kind = "λ"
        --     vim_item.menu = menu
        --   elseif entry.source.name == 'cmdline_history' then
        --     vim_item = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        --     vim_item.kind = "∞"
        --     vim_item.menu = menu
        --   else
        --     local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        --     local strings = vim.split(kind.kind, "%s", { trimempty = true })
        --     kind.kind = (strings[1] or "") .. " "
        --     if entry.completion_item.detail == nil then
        --       kind.menu = "  (" .. (strings[2] or "") .. ") " .. (menu or "[]")
        --     else
        --       kind.menu = "  (" .. (strings[2] or "") .. ") " .. "<" .. entry.completion_item.detail .. ">"
        --     end
        --     -- kind.info = menu or "[]"
        --     vim_item = kind
        --   end
        --
        --   return vim_item
        -- end,
      },

      sorting = {
        priority_weight = 2,
        comparators = {
          -- require('cmp_fuzzy_buffer.compare'),
          cmp.config.compare.exact,
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          cmp.config.compare.score,
          -- require("cmp-under-comparator").under,
          cmp.config.compare.kind,
          cmp.config.compare.offset,
        },
      },

      window = {
        documentation = cmp.config.window.bordered({
          winhighlight = "Normal:Normal,FloatBorder:Todo,CursorLine:Visual,Search:None",
          side_padding = 5,
        }),
        completion = cmp.config.window.bordered({
          -- regular
          -- winhighlight = "Normal:Normal,FloatBorder:Todo,CursorLine:Visual,Search:None",
          -- col_offset = 3,

          -- types on left
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          col_offset = -3,
          side_padding = 0,
        }),
      },

    }
  end,
}

local blink = {
  'Saghen/blink.cmp',
  event = "InsertEnter",
  dependencies = {
    -- cmp
    'saghen/blink.compat',
    'hrsh7th/cmp-cmdline',
    'dmitmel/cmp-cmdline-history',

    -- misc
    'onsails/lspkind.nvim', -- icons

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
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        cmdline = { 'cmdline', 'cmdline_cmp', 'cmdline_history', 'path' },
      },
      providers = {
        lsp = {
          override = {
            get_trigger_characters = function(self)
              local trigger_characters = self:get_trigger_characters()
              vim.list_extend(trigger_characters, { '\n', '\t', ' ' })
              return trigger_characters
            end
          }
        },
        snippets = {
          opts = {
            search_paths = {vim.fn.expand("$HOME/.config/nvim/lua/kraftnix/snippets")},
          },
        },
        cmdline_cmp = {
          name = "cmdline",
          module = "blink.compat.source",
          score_offset = -3,
        }
      },
    },
    signature = {
      enabled = true,
    },
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'select_and_accept', 'fallback' },
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
      ['<C-g>'] = { function(cmp) cmp.show({ providers = {'lsp','snippets'} }) end },
      ['<C-e>'] = { 'cancel', 'fallback'},
      ['<C-j>'] = { 'select_next', 'fallback'},
      ['<C-k>'] = { 'select_prev', 'fallback'},
      ['<C-l>'] = { 'show_documentation', 'fallback'},
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback'},
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback'},
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
    completion = {
      trigger = {
        show_on_keyword = true,
        show_in_snippet = true,
        show_on_trigger_character = true,
        show_on_accept_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
        -- LSPs can indicate when to show the completion window via trigger characters
        -- however, some LSPs (i.e. tsserver) return characters that would essentially
        -- always show the window. We block these by default.
        show_on_blocked_trigger_characters = function()
          if vim.api.nvim_get_mode().mode == 'c' then return {} end

          -- you can also block per filetype, for example:
          -- if vim.bo.filetype == 'markdown' then
          --   return { ' ', '\n', '\t', '.', '/', '(', '[' }
          -- end

          -- return { ' ', '\n', '\t' }
          return { }
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
        auto_show_delay_ms = 500,
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
            { "label", "label_description", gap = 1 },
            { "kind" },
            -- { "source_name" },
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
            }
          }
        }
      },
    },
  },
  opts_extend = { "sources.default" },
}

local final = {}

if nixCats('cmp') then
  table.insert(final, nvim_cmp)
  table.insert(final, autopairs)
end
if nixCats('cmpCmdline') then
  table.insert(final, nvim_cmp_cmdline)
end
if nixCats('blink') then
  table.insert(final, blink)
end

return final
