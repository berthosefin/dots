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
