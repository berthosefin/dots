#!/bin/bash

# Hyprpaper
while true; do
  sleep 600
  sh ~/.config/hypr/scripts/hyprpaper-reload.sh
done &

# Battery
while true; do
  sleep 60
  sh ~/.config/hypr/scripts/hypr-battery-check.sh
done &
