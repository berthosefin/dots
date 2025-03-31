#!/bin/bash

SWAYNC_CONFIG_DIR="$HOME/.config/swaync"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
CACHE_DIR="$HOME/.cache/wal"

watch_swaync() {
    while true; do
        inotifywait -e create,modify,move "$SWAYNC_CONFIG_DIR" "$CACHE_DIR/colors-swaync.css"
        swaync-client -rs
    done
}

watch_waybar() {
    trap "killall waybar" EXIT
    while true; do
        waybar &
        inotifywait -e create,modify,move "$WAYBAR_CONFIG_DIR" "$CACHE_DIR/colors-waybar.css"
        killall waybar
    done
}

watch_swaync & 
watch_waybar &

wait
