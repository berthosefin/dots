local bg = '#2E3440'
local fg = '#D8DEE9'
local bright_bg = '#4C566A'
local bright_fg = '#ECEFF4'
local black = '#3B4252'
local white = '#E5E9F0'

return {
  tab_bar = {
    background = black,
    active_tab = {
      bg_color = bg,
      fg_color = bright_fg,
      intensity = 'Bold', -- "Half" "Normal" "Bold"
      underline = 'None', -- "None" "Single" "Double"
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = black,
      fg_color = fg,
    },
    new_tab = {
      bg_color = black,
      fg_color = fg,
    },
    inactive_tab_hover = {
      bg_color = black,
      fg_color = bright_fg,
      italic = false,
    },
    new_tab_hover = {
      bg_color = bg,
      fg_color = bright_fg,
      italic = false,
    },
  },
  background = bg,
  foreground = fg,
  cursor_bg = fg,
  cursor_fg = black,
  cursor_border = fg,
  selection_fg = black,
  selection_bg = fg,
  scrollbar_thumb = fg,
  split = black,
  ansi = {
    bright_bg,
    '#BF616A',
    '#A3BE8C',
    '#EBCB8B',
    '#81A1C1',
    '#B48EAD',
    '#8FBCBB',
    bright_fg,
  },
  brights = {
    black,
    '#BF616A',
    '#A3BE8C',
    '#EBCB8B',
    '#81A1C1',
    '#B48EAD',
    '#88C0D0',
    fg,
  },
}
