return {
  "snacks.nvim",
  auto_enable = true,
  -- snacks makes a global, and then lazily loads itself
  lazy = false,
  -- priority only affects startup plugins
  -- unless otherwise specified by a particular handler
  priority = 1000,
  keys = {
    -- scratch
    { '<leader>SS.', function() Snacks.scratch.toggle() end, desc = "Toggle Scratch Buffer" },
    { '<leader>SSS', function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- picker
    { '<leader>sf', function() Snacks.picker.files() end, desc = "Snack picker all" },
    { '<leader>sF', function() Snacks.picker.smart() end, desc = "[F]ind [f]iles (smart picker)" },
    { '<leader>s<space>', function() Snacks.picker() end, desc = "[s<space>]: Open snacks picker for all commands" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>Fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>F:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>Fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>Fe", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    { "<leader>Fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>Fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    -- { "<leader>Ff", function() Snacks.picker.files() end, "Find Files" },
    { "<leader>Fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>Fp", function() Snacks.picker.projects() end, desc = "Projects"  },
    { "<leader>Fr", function() Snacks.picker.recent() end, desc = "Recent"  },
    -- git
    { "<leader>FGb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>FGl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>FGL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>FGs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>FGS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>FGd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>FGf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Visual selection or word" },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sK", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>s_", function() Snacks.picker.lazygit() end, desc = "Lazygit" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "References", nowait = true, },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  },
  after = function(plugin)
    -- I also like this color
    vim.api.nvim_set_hl(0, "MySnacksIndent", { fg = "#32a88f" })
    local opts = {
      bigfile = { enabled = true, },
      explorer = { replace_netrw = true, },
      picker = {
        sources = {
          explorer = {
            auto_close = true,
          },
        },
      },
      git = {},
      terminal = {},
      scope = {},
      notifier = {
        -- enabled = true,
        enabled = false, -- causes issues with lze + early errors in keys
        timeout = 3000,
      },
      image = { enabled = true, },
      input = { enabled = true, },
      words = { enabled = true, },
      indent = {
        scope = {
          hl = 'MySnacksIndent',
        },
        chunk = {
          -- enabled = true,
          hl = 'MySnacksIndent',
        }
      },
      statuscolumn = {
        left = { "mark", "git" }, -- priority of signs on the left (high to low)
        right = { "sign", "fold" }, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      -- make sure lazygit always reopens the correct program
      -- hopefully this can be removed one day
      lazygit = {
        config = {
          os = {
            editPreset = "nvim-remote",
            edit = vim.v.progpath .. [=[ --server "$NVIM" --remote-send '<cmd>lua nixInfo.lazygit_fix({{filename}})<CR>']=],
            editAtLine = vim.v.progpath .. [=[ --server "$NVIM" --remote-send '<cmd>lua nixInfo.lazygit_fix({{filename}}, {{line}})<CR>']=],
            openDirInEditor = vim.v.progpath .. [=[ --server "$NVIM" --remote-send '<cmd>lua nixInfo.lazygit_fix({{dir}})<CR>']=],
            -- this one isnt a remote command, make sure it gets our config regardless of if we name it nvim or not
            editAtLineAndWait = nixInfo(vim.v.progpath, "progpath") .. " +{{line}} {{filename}}",
          },
        },
      },
    }

    -- settings.snacks.dashboard
    if nixInfo(false, "settings", "snacks", "startpage") then
      opts.dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "",  key = "w", desc = "Open flake.nix", action = ":e flake.nix" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          }
        },
        formats = {
          key = function(item)
            return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
          end,
        },
        sections = {
          -- { section = "header" },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, cwd = true },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 2,
          },
          {
            title = "Last run commands",
            width = 100,
            icon = " ",
            section = "terminal",
            cmd = "nu -c 'if (which atuin) != [] { atuin search --limit 5 -c . --format `{time} -\t{duration}\t: {command}` } else { history | last 5 | get command | str join (char newline) }'",
            -- cmd = 'atuin search --limit 5 -c . --human --format "{time} -\t[{duration}]\t- {command}"',
            -- cmd = 'nu -c \'atuin search --limit 5 -c . --human --format "{time}\t[{duration}]\t{command}" | lines | each {parse "{date}\t[{time}]\t{cmd}"} | flatten\'',
            height = 7,
            padding = 1,
            indent = 1,
          },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          -- { section = "startup" }, -- breaks: https://github.com/folke/snacks.nvim/issues/1778
        },
      }
    end

    -- settings.snacks.terminal
    if nixInfo(false, "settings", "snacks", "terminal") then
      vim.api.nvim_set_keymap('n', ':lua Snacks.terminal.toggle()', [[<C-q>]], { noremap = true, desc = 'Toggle snacks terminal' })
      vim.api.nvim_set_keymap('n', ':lua Snacks.terminal.list()', '<leader>sT', { desc = 'List snacks terminals' })
      opts.terminal = {
        win = {
          keys = {
            q = "hide",
            term_toggle = {
              '<c-q>',
              -- h.lr('snacks', 'terminal', 'toggle'),
              function (self)
                -- Snacks.terminal.toggle()
                self:hide()
                -- return "<c-\\><c-n><c-q>"
              end,
              mode = 't',
              expr = true,
              -- noremap = true,
              desc = "Toggle terminal"
            },
            gf = function(self)
              local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
              if f == "" then
                Snacks.notify.warn("No file under cursor")
              else
                self:hide()
                vim.schedule(function()
                  vim.cmd("e " .. f)
                end)
              end
            end,
            term_normal = {
              "<esc>",
              function(self)
                self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                if self.esc_timer:is_active() then
                  self.esc_timer:stop()
                  vim.cmd("stopinsert")
                else
                  self.esc_timer:start(500, 0, function() end)
                  return "<esc>"
                end
              end,
              mode = "t",
              expr = true,
              desc = "Double escape to normal mode",
            },
          }
        }
      }
    end


    if nixInfo(false, 'info', 'flash', 'enable') then
        opts.picker = vim.tbl_deep_extend("force", opts.picker or {}, {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        })
    end

    require('snacks').setup(opts)

    -- Handle the backend of those remote commands.
    -- hopefully this can be removed one day
    nixInfo.lazygit_fix = function(path, line)
      local prev = vim.fn.bufnr("#")
      local prev_win = vim.fn.bufwinid(prev)
      vim.api.nvim_feedkeys("q", "n", false)
      if line then
        vim.api.nvim_buf_call(prev, function()
          vim.cmd.edit(path)
          local buf = vim.api.nvim_get_current_buf()
          vim.schedule(function()
            if buf then
              vim.api.nvim_win_set_buf(prev_win, buf)
              vim.api.nvim_win_set_cursor(0, { line or 0, 0})
            end
          end)
        end)
      else
        vim.api.nvim_buf_call(prev, function()
          vim.cmd.edit(path)
          local buf = vim.api.nvim_get_current_buf()
          vim.schedule(function()
            if buf then
              vim.api.nvim_win_set_buf(prev_win, buf)
            end
          end)
        end)
      end
    end
  end

}
