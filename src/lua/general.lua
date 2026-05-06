-- allow .nvim.lua in current dir and parents (project config)
vim.o.exrc = false

vim.o.background = "dark"

if os.getenv('WAYLAND_DISPLAY') and vim.fn.exepath('wl-copy') ~= "" then
  vim.g.clipboard = {
      name = 'wl-clipboard',
      copy = {
          ['+'] = 'wl-copy',
          ['*'] = 'wl-copy',
      },
      paste = {
          ['+'] = 'wl-paste',
          ['*'] = 'wl-paste',
      },
      cache_enabled = 1,
  }
end

-- fold
-- vim.g.nofoldenable = true
vim.o.foldlevel = 4
vim.o.foldmethod = "indent"
vim.o.foldnestmax = 10

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '→→', trail = '●', nbsp = '○' }

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Make line numbers default
vim.wo.number = true
-- Show line numbers
vim.o.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- -- NOTE: mine
-- -- Indent
-- vim.o.smarttab = true
-- vim.opt.cpoptions:append('I')
-- --

-- tab width
vim.o.shiftwidth = 2
-- vim.o.softtabstop = 2
vim.o.tabstop = 2
-- vim.o.noexpandtab = true
vim.o.smartindent = true

-- Indent
vim.opt.cpoptions:append('I')
vim.o.expandtab = true
vim.o.showtabline = 2

-- stops line wrapping from being confusing
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.o.undolevels = 2000
vim.o.undoreload = 2000

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
-- vim.o.timeout = true
vim.o.timeoutlen = 300


-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,preview,noselect'
-- vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.autoread = true
vim.o.autoindent = true
vim.o.hidden = true

--extra
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.o.wildmode = "list:longest,list:full"
vim.o.wrap = true
vim.o.sidescrolloff = 5
vim.o.splitbelow = false
vim.o.splitright = true

vim.g.netrw_liststyle=0
vim.g.netrw_banner=0
