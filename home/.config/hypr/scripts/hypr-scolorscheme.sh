#!/bin/sh

# ----------------------------------------------
# Description : ColorScheme Switcher
# Author : Berthose Fin (Thos)
# Update : 2025-05-27
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

# Function to change Mousepad colors
change_mousepad_colors() {
  ln -sf ~/.cache/wal/colors-mousepad.xml ~/.local/share/gtksourceview-4/styles/pywal.xml
}

# Function to change xfce4-terminal colors
change_xfce4_terminal_colors() {
  sleep 0.3
  . "${HOME}/.cache/wal/colors.sh"

  xfconf-query -c xfce4-terminal -p /color-cursor -s "${foreground}"
  xfconf-query -c xfce4-terminal -p /color-foreground -s "${foreground}"
  xfconf-query -c xfce4-terminal -p /color-background -s "${background}"
  xfconf-query -c xfce4-terminal -p /tab-activity-color -s "${color6}"
  xfconf-query -c xfce4-terminal -p /color-palette -s "${color0};${color1};${color2};${color3};${color4};${color5};${color6};${color7};${color8};${color9};${color10};${color11};${color12};${color13};${color14};${color15}"
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
change_mousepad_colors
change_xfce4_terminal_colors

wait
hyprctl reload

# === Notify user ===
notify-send -u normal "ColorScheme Changed" "The color scheme has been changed to ${choice}."
