-- Hyprland Lua config file

-- MyColors
local myColors = dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")

------------------
---- MONITORS ----
------------------

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = "1",
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "preferred",
  position = "auto",
  scale = "1",
})

-- Configuring workspaces per monitor
for i = 1, 4 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end

for i = 5, 8 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "thunar"
local browser = "firefox"
local menu = "rofi -show drun"
local scripts = os.getenv("HOME") .. "/.config/hypr/scripts"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("dunst")
  hl.exec_cmd("waybar")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd(scripts .. "/hypr-timer.sh")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

hl.on("monitor.added", function()
  hl.exec_cmd('awww img "$(awww query | awk -F"image: " "/eDP-1/{print $2}")"')
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("TERMINAL", "kitty")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in = 2.5,
    gaps_out = 5,

    border_size = 2,

    col = {
      active_border = { colors = { myColors.primary, myColors.secondary }, angle = 45 },
      inactive_border = myColors.outline,
    },

    resize_on_border = true,

    allow_tearing = false,

    layout = "dwindle",
  },

  group = {
    col = {
      border_active = { colors = { myColors.secondary, myColors.tertiary }, angle = 45 },
      border_inactive = myColors.outline,
    },

    groupbar = {
      enabled = true,
      indicator_height = 4,
      rounding = 2,
      render_titles = false,
      col = {
        active = myColors.secondary,
        inactive = myColors.outline,
      },
    },
  },

  decoration = {
    rounding = 5,
    rounding_power = 2,

    active_opacity = 0.8,
    inactive_opacity = 0.8,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = myColors.shadow,
    },

    blur = {
      enabled = true,
      size = 1,
      passes = 6,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },
})

-- Curves and animations
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Layout
hl.config({
  dwindle = {
    preserve_split = true,
  },
})

hl.config({
  master = {
    new_status = "master",
  },
})

hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
  },
})

----------------
----  MISC  ----
----------------

hl.config({
  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = true,
  },
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "fr",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    numlock_by_default = true,

    follow_mouse = 1,

    sensitivity = 0,

    touchpad = {
      natural_scroll = false,
      drag_lock = false,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local secondMod = "ALT"

-- System
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("xfce4-terminal"))
hl.bind(secondMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Basic
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(
  mainMod .. " + V",
  hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 -p 'Clipboard' -l 10 | cliphist decode | wl-copy")
)
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(scripts .. "/hypr-powermenu.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("networkmanager_dmenu"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())

hl.bind(secondMod .. " + left", hl.dsp.group.prev())
hl.bind(secondMod .. " + right", hl.dsp.group.next())

-- Screenshots
hl.bind(
  "PRINT",
  hl.dsp.exec_cmd(
    'grim - | satty -f - --output-filename "$(xdg-user-dir PICTURES)/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"'
  )
)

-- Navigation
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Window movement
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Vim-like navigation
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Vim-like window movement
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))

-- Workspaces (uses keycodes for FR keyboard)
local workspace_keys = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }

for i = 1, 10 do
  local keycode = workspace_keys[i]
  hl.bind(mainMod .. " + code:" .. keycode, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + code:" .. keycode, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll workspaces
hl.bind(mainMod .. " + mouse:274", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse:275", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize window
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl --min-value=75 set 5%-"),
  { locked = true, repeating = true }
)

-- Playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Zoom
hl.bind(
  mainMod .. " + KP_ADD",
  hl.dsp.exec_cmd(
    "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
  ),
  { repeating = true }
)
hl.bind(
  mainMod .. " + KP_SUBTRACT",
  hl.dsp.exec_cmd(
    "hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
  ),
  { repeating = true }
)
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

-- Layer rules also return a handle
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Enable blur and ignore_alpha for rofi
hl.layer_rule({
  match = { namespace = "rofi" },
  blur = true,
  ignore_alpha = 0.5,
})

-- Hyprland-run windowrule
hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move = "20 monitor_h-120",
  float = true,
})

-- Workspace assignments
hl.window_rule({
  name = "firefox-workspace",
  match = { class = "^(?i).*(firefox|brave).*" },
  workspace = 2,
})

hl.window_rule({
  name = "code-office-workspace",
  match = { class = "^(?i).*(code|zed|office).*" },
  workspace = 3,
})

hl.window_rule({
  name = "creative-apps-workspace",
  match = { class = "^(?i).*(gimp|inkscape|kdenlive|audacity|mixxx|rhythmbox|strawberry).*" },
  workspace = 4,
})

-- Floating windows
hl.window_rule({
  name = "media-viewers-float",
  match = { class = "^(?i).*(viewnior|mpv|zathura|xarchiver).*" },
  float = true,
})

hl.window_rule({
  name = "xfce-terminal-float",
  match = { class = "^(xfce4-terminal)$" },
  float = true,
})

hl.window_rule({
  name = "xdman-float",
  match = { class = "^(?i).*(xdman).*" },
  float = true,
})

hl.window_rule({
  name = "dialog-float",
  match = { title = "^(?i).*(ration|confirm|ren).*" },
  float = true,
})

-- Size constraints
hl.window_rule({
  name = "viewnior-minsize",
  match = { class = "^(viewnior)$" },
  min_size = { 720, 460 },
})

-- Rofi stay focused
hl.window_rule({
  name = "rofi-stayfocused",
  match = { class = "^(Rofi)$" },
  stay_focused = true,
})
