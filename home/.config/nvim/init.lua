-- Leader key MUST be set before any plugin loads
vim.g.mapleader = ' '

-- Disable unused built-in plugins
vim.g.loaded_gzip = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_tohtml = false
vim.g.loaded_tutor = false
vim.g.loaded_zipPlugin = false

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.tabline')
require('plugins')
