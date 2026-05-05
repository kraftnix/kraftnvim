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
    { '<leader>.', ":lua Snacks.scratch.select()", mode = { "n" }, desc = "Toggle Scratch Buffer" },
    { '<leader>S', ":lua Snacks.scratch.select()", mode = { "n" }, desc = "Select Scratch Buffer" },
    -- picker
    { '<leader>sf', ":lua Snacks.picker.file()", mode = { "n" }, desc = "Snack picker all" },
    { '<leader>Ff', ":lua Snacks.picker.smart()", mode = { "n" }, desc = "[F]ind [f]iles (smart picker)" },
    { '<leader>F<space>', ":lua Snacks.picker()", mode = { "n" }, desc = "[F<space>]: Open picker for all commands" },
    { "<leader>,", function() Snacks.picker.buffers() end, mode = { "n" }, desc = "Buffers" },
    { "<leader>Fg", function() Snacks.picker.grep() end, mode = { "n" }, desc = "Grep" },
    { "<leader>F:", function() Snacks.picker.command_history() end, mode = { "n" }, desc = "Command History" },
    { "<leader>Fn", function() Snacks.picker.notifications() end, mode = { "n" }, desc = "Notification History" },
    { "<leader>Fe", function() Snacks.explorer() end, mode = { "n" }, desc = "File Explorer" },
    -- find
    { "<leader>Fb", function() Snacks.picker.buffers() end, mode = { "n" }, desc = "Buffers" },
    { "<leader>Fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, mode = { "n" }, desc = "Find Config File" },
    -- { "<leader>Ff", function() Snacks.picker.files() end, "Find Files" },
    { "<leader>Fg", function() Snacks.picker.git_files() end, mode = { "n" }, desc = "Find Git Files" },
    { "<leader>Fp", function() Snacks.picker.projects() end, mode = { "n" }, desc = "Projects"  },
    { "<leader>Fr", function() Snacks.picker.recent() end, mode = { "n" }, desc = "Recent"  },
    -- git
    { "<leader>FGb", function() Snacks.picker.git_branches() end, mode = { "n" }, desc = "Git Branches" },
    { "<leader>FGl", function() Snacks.picker.git_log() end, mode = { "n" }, desc = "Git Log" },
    { "<leader>FGL", function() Snacks.picker.git_log_line() end, mode = { "n" }, desc = "Git Log Line" },
    { "<leader>FGs", function() Snacks.picker.git_status() end, mode = { "n" }, desc = "Git Status" },
    { "<leader>FGS", function() Snacks.picker.git_stash() end, mode = { "n" }, desc = "Git Stash" },
    { "<leader>FGd", function() Snacks.picker.git_diff() end, mode = { "n" }, desc = "Git Diff (Hunks)" },
    { "<leader>FGf", function() Snacks.picker.git_log_file() end, mode = { "n" }, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, mode = { "n" }, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, mode = { "n" }, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, mode = { "n" }, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Visual selection or word" },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, mode = { "n" }, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, mode = { "n" }, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, mode = { "n" }, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, mode = { "n" }, decs = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, mode = { "n" }, decs = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, mode = { "n" }, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, mode = { "n" }, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, mode = { "n" }, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, mode = { "n" }, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, mode = { "n" }, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, mode = { "n" }, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, mode = { "n" }, desc = "Jumps" },
    { "<leader>sK", function() Snacks.picker.keymaps() end, mode = { "n" }, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, mode = { "n" }, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, mode = { "n" }, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, mode = { "n" }, desc = "Man Pages" },
    { "<leader>s_", function() Snacks.picker.lazygit() end, mode = { "n" }, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, mode = { "n" }, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, mode = { "n" }, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, mode = { "n" }, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, mode = { "n" }, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, mode = { "n" }, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, mode = { "n" }, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, mode = { "n" }, desc = "References", nowait = true, },
    { "gI", function() Snacks.picker.lsp_implementations() end, mode = { "n" }, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, mode = { "n" }, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, mode = { "n" }, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, mode = { "n" }, desc = "LSP Workspace Symbols" },
  },
  after = function(plugin)
    -- I also like this color
    vim.api.nvim_set_hl(0, "MySnacksIndent", { fg = "#32a88f" })
    require('snacks').setup({
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
        enabled = true,
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
    })
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
