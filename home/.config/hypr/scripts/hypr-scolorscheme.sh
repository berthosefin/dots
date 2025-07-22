#!/bin/sh

# ----------------------------------------------
# Description : ColorScheme Switcher
# Author : Berthose Fin (Thos)
# Update : 2025-07-20
# ----------------------------------------------

# === Directories ===
theme_dir="$HOME/.config/hypr/scripts/colorschemes"

# === Fonctions ===
# Function to change GTK settings
change_gtk_settings() {
  default_gtk_theme="Adwaita-dark"
  default_icon_theme="Papirus-Dark"
  default_cursor_theme="capitaine-cursors"

  gsettings set org.gnome.desktop.interface gtk-theme "${1:-$default_gtk_theme}"
  gsettings set org.gnome.desktop.interface icon-theme "${2:-$default_icon_theme}"
  gsettings set org.gnome.desktop.interface cursor-theme "${3:-$default_cursor_theme}"
}

# Function to change wallpaper directory
change_randomwall_image_dir() {
  local image_dir="$1"
  wallpaper=$(find "$image_dir" -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -z -n 1 | tr -d '\0')

  if [ -n "$wallpaper" ]; then
    sed -i "s|^preload =.*|preload = ${wallpaper}|" ~/.config/hypr/hyprpaper.conf
    sed -i "s|^wallpaper =.*|wallpaper = ,${wallpaper}|" ~/.config/hypr/hyprpaper.conf
    sed -i "s|^WALLPAPER_DIR=.*|WALLPAPER_DIR=\"${image_dir}\"|" ~/.config/hypr/scripts/hyprpaper-reload.sh
    nohup sh ~/.config/hypr/scripts/hyprpaper-reload.sh >/dev/null 2>&1 &
  fi
}

# === List of available colorschemes ===
theme_files=$(find "$theme_dir" -name '*.conf' | sort)
theme_names=$(basename -a $theme_files | sed 's/\.conf$//')

# === Menu ===
choice=$(echo "$theme_names" | rofi -dmenu -i -p "Choose a colorscheme")
[ -z "$choice" ] && exit 0

theme_file="$theme_dir/${choice}.conf"
[ ! -f "$theme_file" ] && {
  echo "Fichier introuvable : $theme_file"
  exit 1
}

# === Load the config ===
eval $(grep -v '^#' "$theme_file" | sed 's/^/export /')

# === Apply the theme ===
if [ "$is_light" = "true" ]; then
  wal -l --theme "$theme"
else
  wal --theme "$theme"
fi
change_gtk_settings "$gtk_theme" "$icon_theme" "$cursor_theme"
change_randomwall_image_dir "$image_dir" &
papirus-folders -C "$papirus_color" &
kvantummanager --set "$kvantum" &

ln -sf ~/.cache/wal/colors-tmux.conf ~/.tmux.conf
ln -sf ~/.cache/wal/colors-wlogout.css ~/.config/wlogout/style.css

ln -sf ~/.cache/wal/colors-dunst ~/.config/dunst/dunstrc
pkill -f dunst

wait
hyprctl reload
dunst &

# === Notify user ===
notify-send -u normal "ColorScheme Changed" "The color scheme has been changed to ${choice}."
