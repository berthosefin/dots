#!/usr/bin/env bash

WALLPAPER_DIR="/home/thos/Images/Misc"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# Récupère wallpaper actuel proprement
CURRENT_WALL=$(hyprctl hyprpaper listloaded 2>/dev/null | grep -oP '(?<=: )[^[:space:]]+$' | head -1)

# Choisit un nouveau wallpaper
if [[ -n "$CURRENT_WALL" ]]; then
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -path "*$(basename "$CURRENT_WALL")" | shuf -n 1)
else
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
fi

# MODIFIE LA CONFIG (votre idée !)
sed -i "s|path = .*|path = $WALLPAPER|" "$CONFIG_FILE"

# Recharge hyprpaper
hyprctl reload
# notify-send "Nouveau wallpaper" "$(basename "$WALLPAPER")" 2>/dev/null || true

