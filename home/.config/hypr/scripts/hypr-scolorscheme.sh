#!/bin/sh

# ----------------------------------------------
# Description : ColorScheme Switcher
# Author : Berthose Fin (Thos)
# Update : 2025-09-06
# ----------------------------------------------

# === Directories ===
theme_dir="$HOME/.config/hypr/scripts/colorschemes"

# === Fonctions ===
# Function to change GTK settings
change_gtk_settings() {
  default_gtk_theme="Adwaita-dark"
  default_icon_theme="Papirus-Dark"
  default_cursor_theme="Adwaita"

  gsettings set org.gnome.desktop.interface gtk-theme "${1:-$default_gtk_theme}"
  gsettings set org.gnome.desktop.interface icon-theme "${2:-$default_icon_theme}"
  gsettings set org.gnome.desktop.interface cursor-theme "${3:-$default_cursor_theme}"
}

# Function to change wallpaper directory
change_randomwall_image_dir() {
  local image_dir="$1"

  wallpaper=$(find "$image_dir" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n 1)

  [ -z "$wallpaper" ] && return

  config="$HOME/.config/hypr/hyprpaper.conf"

  # Update path inside wallpaper block
  sed -i '/^wallpaper {/,/^}/ {
      s|^[[:space:]]*path =.*|    path = '"$wallpaper"'|
  }' "$config"

  # Update wallpaper dir for reload script
  sed -i "s|^WALLPAPER_DIR=.*|WALLPAPER_DIR=\"$image_dir\"|" \
    "$HOME/.config/hypr/scripts/hyprpaper-reload.sh"
}

# Function to change LazyVim colorscheme
change_lazyvim_colorscheme() {
  local colorscheme_name="$1"
  local flavour="$2"
  local config_file="$HOME/.config/nvim/lua/plugins/colorscheme.lua"

  sed -i "s/colorscheme = \".*\"/colorscheme = \"$colorscheme_name\"/" "$config_file"

  if grep -q 'catppuccin' "$config_file" && [ -n "$flavour" ]; then
    sed -i "s/flavour = \".*\"/flavour = \"$flavour\"/" "$config_file"
  fi
}

# Function to change zellij theme
change_zellij_theme() {
  zellij_config="$HOME/.config/zellij/config.kdl"
  sed -i "s/^theme \".*\"/theme \"$1\"/" "$zellij_config"
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
kvantummanager --set "$kvantum" &
change_lazyvim_colorscheme "$nvim_colorscheme" "$catppuccin_flavour"
change_zellij_theme "$theme"
ln -sf ~/.cache/wal/colors-dunst ~/.config/dunst/dunstrc
pkill -f dunst
hyprctl reload
dunst &

# === Notify user ===
notify-send -u normal "ColorScheme Changed" "The color scheme has been changed to ${choice}."
