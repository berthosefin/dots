local bg = '#282828'
local fg = '#ebdbb2'
local bright_bg = '#928374'
local bright_fg = '#ebdbb2'
local black = '#282828'
local white = '#a89984'

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
    '#cc241d',
    '#98971a',
    '#d79921',
    '#458588',
    '#b16286',
    '#689d6a',
    bright_fg,
  },
  brights = {
    black,
    '#fb4934',
    '#b8bb26',
    '#fabd2f',
    '#83a598',
    '#d3869b',
    '#8ec07c',
    fg,
  },
}
