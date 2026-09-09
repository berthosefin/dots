-- Shared program paths: single source of truth.
-- Consumed by binds.lua (launch bindings) and base.lua (TERMINAL env).
-- Change a program here once, everything follows.

return {
  terminal = "kitty",
  fileManager = "thunar",
  menu = "rofi -show drun",
  browser = "firefox",
  scripts = os.getenv("HOME") .. "/.config/hypr/scripts",
}
