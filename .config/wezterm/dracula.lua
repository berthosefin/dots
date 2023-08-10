local bg = '#282A36'
local fg = '#F8F8F2'
local bright_bg = '#6272A4'
local bright_fg = '#FFFFFF'
local black = '#21222C'
local white = '#F8F8F2'

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
    '#FF5555',
    '#50FA7B',
    '#F1FA8C',
    '#BD93F9',
    '#FF79C6',
    '#8BE9FD',
    bright_fg,
  },
  brights = {
    black,
    '#FF6E6E',
    '#69FF94',
    '#FFFFA5',
    '#D6ACFF',
    '#FF92DF',
    '#A4FFFF',
    fg,
  },
}
