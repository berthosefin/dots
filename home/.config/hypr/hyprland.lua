-- Hyprland Lua config file (entry point)

local moduleDir = os.getenv("HOME") .. "/.config/hypr/modules"

dofile(moduleDir .. "/monitors.lua") -- monitors + workspace assignment
dofile(moduleDir .. "/autostart.lua") -- start/shutdown hooks
dofile(moduleDir .. "/base.lua") -- env vars + permissions + misc
dofile(moduleDir .. "/look.lua") -- general/group/decoration/animations/dwindle
dofile(moduleDir .. "/input.lua") -- keyboard, touchpad, gestures
dofile(moduleDir .. "/binds.lua") -- all key- and mousebindings
dofile(moduleDir .. "/rules.lua") -- window and layer rules
