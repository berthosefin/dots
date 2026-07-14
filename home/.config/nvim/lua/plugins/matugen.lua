-- Matugen theme (dynamic Material You colors)
require('matugen').setup({
  colors_path = vim.fn.stdpath('config') .. '/generated.json',
})

-- Load the generated colorscheme
vim.cmd('colorscheme matugen')
