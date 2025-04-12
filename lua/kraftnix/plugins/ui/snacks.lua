local h = KraftnixHelper

local keycommands = {
  -- scratch
  { '<leader>.', h.lr('snacks', 'scratch'), "Toggle Scratch Buffer", 'SnackScratchToggle' },
  { '<leader>S', ":lua Snacks.scratch.select()", "Select Scratch Buffer", 'SnackScratchSelect' },
  -- picker
  { '<leader>sf', h.lr('snacks', 'picker', 'files'), "Snack picker all", 'SnacksPicker' },
  { '<leader>Ff', h.lr('snacks', 'picker', 'smart'), "[F]ind [f]iles (smart picker)", 'SnacksPickerSmart' },
  { '<leader>F<space>', h.lr('snacks', 'picker'), "[F<space>]: Open picker for all commands", 'SnacksPickerAll' },
  { "<leader>,", function() Snacks.picker.buffers() end, "Buffers", 'SnacksPickerBuffers' },
  { "<leader>Fg", function() Snacks.picker.grep() end, "Grep", 'SnacksPickerGrep' },
  { "<leader>F:", function() Snacks.picker.command_history() end, "Command History", 'SnacksPickerCommandHistory' },
  { "<leader>Fn", function() Snacks.picker.notifications() end, "Notification History", 'SnacksPickerNotificationHistory'  },
  { "<leader>Fe", function() Snacks.explorer() end, "File Explorer", 'SnacksPickerFileExplorer' },
  -- find
  { "<leader>Fb", function() Snacks.picker.buffers() end, "Buffers" },
  { "<leader>Fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, "Find Config File", 'SnacksPickerFindConfig' },
  -- { "<leader>Ff", function() Snacks.picker.files() end, "Find Files" },
  { "<leader>Fg", function() Snacks.picker.git_files() end, "Find Git Files", 'SnacksPickerGitFiles' },
  { "<leader>Fp", function() Snacks.picker.projects() end, "Projects" , 'SnacksPickerProjects' },
  { "<leader>Fr", function() Snacks.picker.recent() end, "Recent" , 'SnacksPickerRecent' },
  -- git
  { "<leader>FGb", function() Snacks.picker.git_branches() end, "Git Branches", 'SnacksPickerGitBranches' },
  { "<leader>FGl", function() Snacks.picker.git_log() end, "Git Log", 'SnacksPickerGitLog' },
  { "<leader>FGL", function() Snacks.picker.git_log_line() end, "Git Log Line", 'SnacksPickerGitLogLine' },
  { "<leader>FGs", function() Snacks.picker.git_status() end, "Git Status", 'SnacksPickerGitStatus' },
  { "<leader>FGS", function() Snacks.picker.git_stash() end, "Git Stash", 'SnacksPickerGitStash' },
  { "<leader>FGd", function() Snacks.picker.git_diff() end, "Git Diff (Hunks)", 'SnacksPickerGitDiff' },
  { "<leader>FGf", function() Snacks.picker.git_log_file() end, "Git Log File", 'SnacksPickerGitLogFile' },
  -- Grep
  { "<leader>sb", function() Snacks.picker.lines() end, "Buffer Lines", 'SnacksPickerLines' },
  { "<leader>sB", function() Snacks.picker.grep_buffers() end, "Grep Open Buffers", 'SnacksPickerLines' },
  { "<leader>sg", function() Snacks.picker.grep() end, "Grep", 'SnacksPickerGrep' },
  { "<leader>sw", function() Snacks.picker.grep_word() end, "Visual selection or word", 'SnacksPickerGrepWord', mode = { "n", "x" } },
  -- search
  { '<leader>s"', function() Snacks.picker.registers() end, "Registers", 'SnacksPickerRegisters' },
  { '<leader>s/', function() Snacks.picker.search_history() end, "Search History", 'SnacksPickerSearchHistory' },
  { "<leader>sA", function() Snacks.picker.autocmds() end, "Autocmds", 'SnacksPickerAutocmds' },
  { "<leader>sb", function() Snacks.picker.lines() end, "Buffer Lines" },
  { "<leader>sc", function() Snacks.picker.command_history() end, "Command History" },
  { "<leader>sC", function() Snacks.picker.commands() end, "Commands", 'SnacksPickerCommands' },
  { "<leader>sd", function() Snacks.picker.diagnostics() end, "Diagnostics", 'SnacksPickerDiagnostics' },
  { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, "Buffer Diagnostics", 'SnacksPickerDiagnosticsBuffer' },
  { "<leader>sh", function() Snacks.picker.help() end, "Help Pages", 'SnacksPickerHelp' },
  { "<leader>sH", function() Snacks.picker.highlights() end, "Highlights", 'SnacksPickerHighlights' },
  { "<leader>si", function() Snacks.picker.icons() end, "Icons", 'SnacksPickerIcons' },
  { "<leader>sj", function() Snacks.picker.jumps() end, "Jumps", 'SnacksPickerJumps' },
  { "<leader>sK", function() Snacks.picker.keymaps() end, "Keymaps", 'SnacksPickerKeymaps' },
  { "<leader>sL", function() Snacks.picker.loclist() end, "Location List", 'SnacksPickerLoclist' },
  { "<leader>sm", function() Snacks.picker.marks() end, "Marks", 'SnacksPickerMarks' },
  { "<leader>sM", function() Snacks.picker.man() end, "Man Pages", 'SnacksPickerMan' },
  { "<leader>sp", function() Snacks.picker.lazy() end, "Search for Plugin Spec", 'SnacksPickerLazy' },
  { "<leader>sq", function() Snacks.picker.qflist() end, "Quickfix List", 'SnacksPickerQuickfixList' },
  { "<leader>sR", function() Snacks.picker.resume() end, "Resume", 'SnacksPickerResume' },
  { "<leader>su", function() Snacks.picker.undo() end, "Undo History", 'SnacksPickerUndo' },
  { "<leader>uC", function() Snacks.picker.colorschemes() end, "Colorschemes", 'SnacksPickerColourschemes' },
  -- LSP
  { "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition", 'SnacksPickerLspDefinitions' },
  { "gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration", 'SnacksPickerLspDeclarations' },
  { "gr", function() Snacks.picker.lsp_references() end, "References", 'SnacksPickerLspReferences', nowait = true, },
  { "gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation", 'SnacksPickerLspImplementations' },
  { "gy", function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition", 'SnacksPickerLspTypeDefinitions' },
  { "<leader>ss", function() Snacks.picker.lsp_symbols() end, "LSP Symbols", 'SnacksPickerLspSymbols' },
  { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols", 'SnacksPickerLspWorkspaceSymbols' },
}

local opts = {
  lazygit = {
    configure = true,
    config = {
      os = { editPreset = "nvim-remote" },
    },
  },
  bigfile = { enabled = true, },
  scope = { enabled = true, },
  input = { enabled = true, },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  image = { enabled = true, },
  words = { enabled = true, },
  picker = {
    layout = {
      -- preset = "ivy_split"
    }
  },
  explorer = { enabled = true, },
  indent = { enabled = true, },
  -- WARN: janky animations: https://github.com/folke/snacks.nvim/issues/1620
  -- scroll = {
  --   animate = {
  --     duration = { step = 15, total = 250 },
  --     easing = "linear",
  --   },
  --   -- faster animation when repeating scroll after delay
  --   animate_repeat = {
  --     delay = 100, -- delay in ms before using the repeat animation
  --     duration = { step = 5, total = 50 },
  --     easing = "linear",
  --   },
  --   -- what buffers to animate
  --   filter = function(buf)
  --     return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
  --   end,
  -- },
}

if nixCats('snacks_dashboard') then
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
        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
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
        cmd = 'atuin search --limit 5 -c . --format "{command}"',
        -- cmd = 'atuin search --limit 5 -c . --human --format "{time} -\t[{duration}]\t- {command}"',
        -- cmd = 'nu -c \'atuin search --limit 5 -c . --human --format "{time}\t[{duration}]\t{command}" | lines | each {parse "{date}\t[{time}]\t{cmd}"} | flatten\'',
        height = 7,
        padding = 1,
        indent = 1,
      },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      { section = "startup" },
    },
  }
end

if nixCats('snacks_terminal') then
  table.insert(keycommands,
    { '<C-q>', function ()
      Snacks.terminal.toggle()
    end, "Toggle terminal", 'SnacksTerminal', mode = { 'v', 'n' } }
  )
  table.insert(keycommands,
    { '<leader>Ft', function ()
      require('snacks').terminal.list()
    end, "toggle", 'SnacksTerminalList' }
  )
  -- { '<leader>FT', h.lr('snacks', 'terminal', 'toggle'), "toggle", 'SnacksTerminalToggle' },--gd
  -- { '<leader>FT', h.lr('snacks', 'terminal'), "toggle", 'SnacksTerminal' },--gd
  -- { '<leader>Ft', h.lr('snacks', 'terminal', 'list'), "toggle", 'SnacksTerminalList' },--gd

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

return {
  { 'folke/snacks.nvim',
    keycommands = keycommands,
    opts = opts
  },
}
