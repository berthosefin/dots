local wezterm = require 'wezterm'
require('events')

return {
  colors = require('theme'),
  window_frame = {
    active_titlebar_bg = '#333333',
    inactive_titlebar_bg = '#333333',
  },
  use_fancy_tab_bar = true,
  font = wezterm.font 'Iosevka Nerd Font',
  font_size = 8,
  default_cursor_style = 'BlinkingBar',

  default_prog = { 'zsh' },
  window_close_confirmation = 'NeverPrompt',
  hide_tab_bar_if_only_one_tab = true,

  enable_scroll_bar = false;
  window_padding = {
    top    = '0cell',
    right  = '2cell',
    bottom = '0cell',
    left   = '2cell',
  },

  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },

  window_background_opacity = 1.0,
  text_background_opacity = 1.0,

  keys = require('keys')
}
