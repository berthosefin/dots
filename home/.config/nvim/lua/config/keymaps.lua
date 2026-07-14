local map = vim.keymap.set

-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Buffer navigation
map('n', '<S-h>', '<cmd>bprevious<cr>')
map('n', '<S-l>', '<cmd>bnext<cr>')
map('n', '<leader>bd', '<cmd>bdelete<cr>')
map('n', '<leader>bn', '<cmd>enew<cr>')

-- Clear search
map('n', '<Esc>', '<cmd>nohlsearch<cr>')

-- Save / Quit
map('n', '<leader>w', '<cmd>w<cr>')
map('n', '<leader>q', '<cmd>q<cr>')
