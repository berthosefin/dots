local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.termguicolors = true
o.signcolumn = 'yes'
o.winborder = 'bold'

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true

-- Splits
o.splitright = true
o.splitbelow = true

-- Misc
o.undofile = true
o.scrolloff = 8
o.updatetime = 250
o.timeoutlen = 300
o.ttimeoutlen = 10
o.clipboard = 'unnamedplus'
o.completeopt = 'menuone,noselect'

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
