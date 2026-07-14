-- Native buffer tabline (no plugin needed)

function _G.tabline()
  local tabs = {}
  local bufs = vim.fn.getbufinfo({ buflisted = true })

  for _, buf in ipairs(bufs) do
    local name = vim.fn.fnamemodify(buf.name, ':t')
    if name == '' then name = '[No Name]' end

    local mod = buf.changed == 1 and '+' or ''
    local flag = buf.bufnr == vim.fn.bufnr('%') and '%' or ''
    local hl = buf.bufnr == vim.fn.bufnr('%') and '%#TabLineSel#' or '%#TabLine#'

    table.insert(tabs, '%' .. buf.bufnr .. 'T' .. hl .. ' ' .. name .. mod .. ' ')
  end

  return '%#TabLineFill#' .. table.concat(tabs, '') .. '%#TabLineFill#%='
end

vim.opt.tabline = '%!v:lua.tabline()'
vim.opt.showtabline = 2
