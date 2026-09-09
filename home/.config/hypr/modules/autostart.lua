-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user start hyprland-session.target")
  hl.exec_cmd("awww-daemon")
end)

hl.on("monitor.added", function()
  hl.exec_cmd('awww img "$(awww query | awk -F"image: " "/eDP-1/{print $2}")"')
end)

hl.on("hyprland.shutdown", function()
  os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)
