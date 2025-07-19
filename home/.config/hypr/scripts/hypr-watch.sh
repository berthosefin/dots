#!/bin/bash

WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
CACHE_DIR="$HOME/.cache/wal"

watch_waybar() {
  trap "killall waybar" EXIT
  while true; do
    waybar &
    inotifywait -e create,modify,move "$WAYBAR_CONFIG_DIR" "$CACHE_DIR/colors-waybar.css"
    killall waybar
  done
}

watch_waybar &

wait
