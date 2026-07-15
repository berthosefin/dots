local gh = function(x) return 'https://github.com/' .. x end

-- Plugin definitions via vim.pack (built-in)
vim.pack.add({
  -- Treesitter
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },

  -- Fuzzy finder
  { src = gh('nvim-telescope/telescope.nvim'), version = '0.1.x' },
  { src = gh('nvim-lua/plenary.nvim'), version = 'master' },

  -- File explorer
  { src = gh('echasnovski/mini.files'), version = 'main' },

  -- Completion
  { src = gh('saghen/blink.cmp'), version = 'main' },
  { src = gh('saghen/blink.lib'), version = 'main' },

  -- Matugen theme (no base16 dependency)
  { src = gh('daedlock/matugen.nvim'), version = 'main' },

  -- Formatting
  { src = gh('stevearc/conform.nvim'), version = 'master' },

  -- Linting
  { src = gh('mfussenegger/nvim-lint'), version = 'master' },

  -- Lazygit
  { src = gh('kdheepak/lazygit.nvim'), version = 'main' },
})

-- Load plugin configurations
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.matugen')

-- Telescope
local telescope = require('telescope')
telescope.setup({
  defaults = {
    file_ignore_patterns = { 'node_modules', '.git/' },
    hidden = true,
    no_ignore = true,
    preview = {
      treesitter = false,
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = true,
      find_command = { 'fd', '--type', 'f', '--hidden', '--no-ignore', '--exclude', '.git' },
    },
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })

-- Mini.files
local mini_files = require('mini.files')
mini_files.setup()
vim.keymap.set('n', '<leader>e', function() mini_files.open() end, { desc = 'File explorer' })

-- Lazygit
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Lazygit' })

-- Conform (formatting)
require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    json = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    lua = { 'stylua' },
    prisma = { 'prettier' },
  },
})

vim.keymap.set('n', '<leader>gf', function() require('conform').format({ async = true }) end, { desc = 'Format' })

-- Nvim-lint
require('lint').linters_by_ft = {
  javascript = { 'eslint' },
  typescript = { 'eslint' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function() require('lint').try_lint() end,
})
