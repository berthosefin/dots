--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local suppressMaximizeRule = hl.window_rule({
  -- Apps cannot maximize themselves (fullscreen is managed via keyboard)
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

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

-- Enable blur and ignore_alpha for rofi
hl.layer_rule({
  match = { namespace = "rofi" },
  blur = true,
  ignore_alpha = 0.5,
})

-- Enable blur and ignore_alpha for waybar
hl.layer_rule({
  match = { namespace = "waybar" },
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
  name = "browser-workspace",
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
  match = { class = "^(?i).*(gimp|inkscape|kdenlive|audacity|mixxx|rhythmbox|strawberry|obs).*" },
  workspace = 4,
})

-- Floating windows
hl.window_rule({
  name = "media-viewers-float",
  match = { class = "^(?i).*(viewnior|mpv|zathura|xarchiver).*" },
  float = true,
})

hl.window_rule({
  name = "kitty-float-term",
  match = { class = "^(float-term)$" },
  float = true,
  center = true,
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
