-- Treesitter configuration (nvim-treesitter main branch)
-- Highlight and indent are enabled by default on main branch
-- Install parsers with :TSInstall

-- Install commonly used parsers
local parsers = {
  'lua', 'javascript', 'typescript', 'tsx', 'json',
  'css', 'html', 'prisma', 'markdown', 'markdown_inline',
  'vim', 'vimdoc', 'bash',
}

-- Install missing parsers on startup
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    local installed = require('nvim-treesitter').get_installed()
    local installed_names = {}
    for _, p in ipairs(installed) do
      installed_names[p] = true
    end
    for _, parser in ipairs(parsers) do
      if not installed_names[parser] then
        vim.cmd('TSInstall ' .. parser)
      end
    end
  end,
})

-- Incremental selection: v_an (outer node) / v_in (inner node)
-- These are built-in text objects in Neovim 0.12 with treesitter
