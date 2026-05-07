-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Moves Line Down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Moves Line Up' })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = 'Scroll Down' })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = 'Scroll Up' })
vim.keymap.set("n", "n", "nzzzv", { desc = 'Next Search Result' })
vim.keymap.set("n", "N", "Nzzzv", { desc = 'Previous Search Result' })

vim.keymap.set("n", "<leader><leader>[", "<cmd>bprev<CR>", { desc = 'Previous buffer' })
vim.keymap.set("n", "<leader><leader>]", "<cmd>bnext<CR>", { desc = 'Next buffer' })
vim.keymap.set("n", "<leader><leader>l", "<cmd>b#<CR>", { desc = 'Last buffer' })
vim.keymap.set("n", "<leader><leader>d", "<cmd>bdelete<CR>", { desc = 'delete buffer' })

-- clipbaord
-- vim.keymap.set({"n", "v", "x"}, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })
vim.keymap.set({'n', 'v', 'x'}, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })
vim.keymap.set('i', '<C-p>', '<C-r><C-p>+', { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
vim.keymap.set("x", "<leader>P", '"_dP', { noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--- TODO: move to lsp
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- -- You should instead use these keybindings so that they are still easy to use, but dont conflict
-- vim.keymap.set({"v", "x", "n"}, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
-- vim.keymap.set({"n", "v", "x"}, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
-- vim.keymap.set({'n', 'v', 'x'}, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })
-- vim.keymap.set('i', '<C-p>', '<C-r><C-p>+', { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
-- vim.keymap.set("x", "<leader>P", '"_dP', { noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' })

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- ctrl-d in terminal moves to escape and scrolls up
-- vim.api.nvim_set_keymap('t', '<C-u>', [[<C-\><C-n><C-u>]], { noremap = true, desc = 'Scroll up (and enter normal) in terminal.' })
-- vim.api.nvim_set_keymap('t', '<C-h>', [[<c-\><c-n><cmd>tabp<cr>]], { noremap = true, desc = "Terminal: move tab left" })

-- Movement
vim.keymap.set('n', 'H', ':tabp<cr>', { desc = 'Go to previous tab', silent = true })
vim.keymap.set('n', 'L', ':tabn<cr>', { desc = 'Go to next tab', silent = true })
vim.keymap.set('n', '<leader>wJ', ':bprev<cr>', { desc = '[J]: Previous buffer', silent = true })
vim.keymap.set('n', '<leader>wK', ':bnext<cr>', { desc = '[K]: Next buffer', silent = true })
vim.keymap.set('n', '<leader>wh', ':wincmd h<cr>', { desc = 'Move cursor to buffer left', silent = true })
vim.keymap.set('n', '<leader>wj', ':wincmd j<cr>', { desc = 'Move cursor to buffer below', silent = true })
vim.keymap.set('n', '<leader>wk', ':wincmd k<cr>', { desc = 'Move cursor to buffer above', silent = true })
vim.keymap.set('n', '<leader>wl', ':wincmd l<cr>', { desc = 'Move cursor to buffer right', silent = true })
vim.keymap.set('n', '<leader>wH', ':tabm -1<cr>', { desc = 'Move tab one to left', silent = true })
vim.keymap.set('n', '<leader>wl', ':tabm +1<cr>', { desc = 'Move tab one to right', silent = true })
-- NOTE: doesn't work as expected
vim.keymap.set('n', '<leader>w.', function ()
  local input = tonumber(vim.fn.input('New index: ')) - 1
  vim.cmd(':tabm ' + tostring(input) + '<CR>')
end, { desc = 'Move tab to specified index', silent = true })

-- Buffer Management
vim.keymap.set('n', '<leader>wD', ':Bclose!<cr>', { desc = '[D]elete buffer aggressively' })
vim.keymap.set('n', '<leader>wd', ':bd<cr>', { desc = '[d]elete buffer' })
vim.keymap.set('n', '<leader>wq', ':close<cr>', { desc = '[q]: Close buffer' })
vim.keymap.set('n', '<leader>wQ', ':q!<cr>', { desc = '[Q]: Hard Close nvim' })
vim.keymap.set('n', '<leader>wt', ':tabedit<cr>', { desc = '[t]ab edit' })
vim.keymap.set('n', '<leader>wv', ':vs<cr>', { desc = 'Split window [v]ertically' })
vim.keymap.set('n', '<leader>ws', ':w<cr>', { desc = '[s]: save file (:w)' })
vim.keymap.set('n', '<leader>ww', ':Telescope buffers<cr>', { desc = '[w]: Get buffer list' })
vim.keymap.set('n', '<leader>wx', ':sp<cr>', { desc = '[x]: Split window horizontally' })
vim.keymap.set('n', '<leader>re', ':e!<cr>', { desc = '[r][e]load (forced) current buffer' })

-- SSH
---Updates internal neovim SSH_AUTH_SOCK variable
local h = require('utils.helper')
vim.keymap.set('n', '<leader>skk', h.update_ssh_auth_sock, { desc = 'Reload SSH key' })
vim.keymap.set('n', '<leader>skl', function()
  vim.notify('SSH_AUTH_SOCK: '..vim.env.SSH_AUTH_SOCK, 'info')
  -- require('noice').redirect('echo $SSH_AUTH_SOCK')
end, { desc = 'Show current `SSH_AUTH_SOCK` value' })

-- Neovim Helpers
local th = require('utils.telescope')
th.set_telescope_command(
  'fvf',
  th.tb_wrap('find_files', '~/.config/nvim', { search_dirs = { '~/.config/nvim/nix-plugins', '~/.config/nvim/lazy-plugins' } }),
  'Find in installed current neovim plugins'
)
th.set_telescope_command(
  'fvg',
  th.tb_wrap('live_grep', '~/.config/nvim', { search_dirs = { '~/.config/nvim/nix-plugins', '~/.config/nvim/lazy-plugins' } }),
  'Fuzzy search in installed current neovim plugins'
)

-- Nix Commands
th.set_telescope_command(
  'fnfl',
  function ()
    require('utils.flake').flake.flake_picker()
  end,
  'Telesope picker for Nix Flake Inputs, update/view inputs'
)
th.set_telescope_command(
  'fnpf',
  th.tb_wrap('find_files', '~/repos/NixOS/nixpkgs'),
  'Find files in Nix Packages'
)
th.set_telescope_command(
  'fnpg',
  th.tb_wrap('live_grep', '~/repos/NixOS/nixpkgs'),
  'Fuzzy search in Nix Packages'
)
th.set_telescope_command(
  'fnpdf',
  th.tb_wrap('find_files', '~/repos/NixOS/nixpkgs', { find_command = { 'fd', '-e', 'md', '-e', 'txt' }}),
  'Find files in Nix Packages'
)
th.set_telescope_command(
  'fnpdg',
  th.tb_wrap('live_grep', '~/repos/NixOS/nixpkgs', {type_filter='markdown'}),
  'Fuzzy search in Nix Packages'
)
vim.keymap.set('n', '<leader>fnpt', function()
  print('hello world!')
end,
{ desc = 'Say hello as a command' })
-- (make_telescope_command({ 'fnpf', function ()
--   require('telescope.builtin').find_files({ search_dirs = { "%:p" } })
-- end, '[fJ] Fuzzy search in current directory' })),

