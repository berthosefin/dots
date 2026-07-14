-- Reload matugen on SIGUSR1
vim.api.nvim_create_autocmd('Signal', {
  pattern = 'SIGUSR1',
  callback = function()
    require('matugen').reload()
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
})

-- Auto-resize splits on window resize
vim.api.nvim_create_autocmd('VimResized', {
  callback = function() vim.cmd('wincmd =') end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local save = vim.fn.winsaveview()
    vim.fn.gsub([[\s\+$]], '', '')
    vim.fn.winrestview(save)
  end,
})
