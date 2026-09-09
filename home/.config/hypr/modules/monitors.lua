------------------
---- MONITORS ----
------------------

hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "preferred",
  position = "auto",
  scale = "auto",
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
