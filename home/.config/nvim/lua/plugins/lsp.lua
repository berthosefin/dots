-- LSP configuration (0.12 native)

-- Define server configurations
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.stylua.toml', 'stylua.toml', '.git' },
})

vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
})

vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'package.json', '.git' },
})

vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
  root_markers = { 'tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', '.git' },
})

vim.lsp.config('prismals', {
  cmd = { 'prisma-language-server', '--stdio' },
  filetypes = { 'prisma' },
  root_markers = { 'package.json', '.git' },
})

vim.lsp.config('eslint', {
  cmd = { 'eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
  root_markers = { '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json', '.git' },
})

-- Enable all servers
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('jsonls')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('prismals')
vim.lsp.enable('eslint')

-- LSP keymaps (set on LspAttach)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = function(desc) return { buffer = bufnr, desc = desc } end

    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, opts('Go to definition'))
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts('References'))
    vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, opts('Code action'))
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts('Rename'))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('Hover'))

    -- Enable LSP completion
    vim.lsp.completion.enable(true, args.data.client_id, bufnr)
  end,
})
