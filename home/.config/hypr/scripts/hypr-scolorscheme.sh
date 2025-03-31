#!/bin/sh

# ----------------------------------------------
# Description : ColorScheme Switcher
# Author : Berthose Fin (Thos)
# Date : 2025-03-22
# ----------------------------------------------

# Default themes
default_icon_theme="Papirus-Dark"
default_cursor_theme="capitaine-cursors"

# Function to change GTK settings
change_gtk_settings() {
  local theme_name="$1"
  local icon_theme="${2:-$default_icon_theme}"
  local cursor_theme="${3:-$default_cursor_theme}"

  gsettings set org.gnome.desktop.interface gtk-theme "${theme_name}" &
  gsettings set org.gnome.desktop.interface icon-theme "${icon_theme}" &
  gsettings set org.gnome.desktop.interface cursor-theme "${cursor_theme}" &
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
  sleep 0.5
  . "${HOME}/.cache/wal/colors.sh"

  xfconf-query -c xfce4-terminal -p /color-cursor -s "${foreground}" &
  xfconf-query -c xfce4-terminal -p /color-foreground -s "${foreground}" &
  xfconf-query -c xfce4-terminal -p /color-background -s "${background}" &
  xfconf-query -c xfce4-terminal -p /tab-activity-color -s "${color6}" &
  xfconf-query -c xfce4-terminal -p /color-palette -s "${color0};${color1};${color2};${color3};${color4};${color5};${color6};${color7};${color8};${color9};${color10};${color11};${color12};${color13};${color14};${color15}" &
}

# ----------------------------------------------
# Menu
# ----------------------------------------------

# Options
catppuccin_frappe="Catppuccin Frappe"
catppuccin_latte="Catppuccin Latte"
catppuccin_macchiato="Catppuccin Macchiato"
catppuccin_mocha="Catppuccin Mocha"
dracula="Dracula"
gruvbox="Gruvbox"
nord="Nord"
quit="Quit"

# Variable passed to menu tool (rofi for i3, wofi for Hyprland)
options="$catppuccin_frappe\n$catppuccin_latte\n$catppuccin_macchiato\n$catppuccin_mocha\n$dracula\n$gruvbox\n$nord\n\n$quit"

choice=$(echo -e "${options}" | rofi -dmenu -i -l 9 -p 'ColorScheme')

if ! [ "${choice}" ] || [ "${choice}" = $quit ]; then
  printf 'No theme chosen\n' >&2
  exit 1
fi

# Change parameters based on choice
case "${choice}" in
$catppuccin_frappe)
  wal --theme catppuccin-frappe &&
  change_gtk_settings "Catppuccin-Frappe-Standard-Blue-Dark" &
  change_randomwall_image_dir "$HOME/Images/Catppuccin" &
  papirus-folders -C cat-frappe-blue &
  kvantummanager --set Catppuccin-Frappe-Blue &
  ;;
$catppuccin_latte)
  wal --theme catppuccin-latte -l &&
  change_gtk_settings "Catppuccin-Latte-Standard-Blue-Light" "Papirus-Light" "capitaine-cursors-light" &
  change_randomwall_image_dir "$HOME/Images/Catppuccin-Latte" &
  papirus-folders -C cat-latte-blue &
  kvantummanager --set Catppuccin-Latte-Blue &
  ;;
$catppuccin_macchiato)
  wal --theme catppuccin-macchiato &&
  change_gtk_settings "Catppuccin-Macchiato-Standard-Blue-Dark" &
  change_randomwall_image_dir "$HOME/Images/Catppuccin" &
  papirus-folders -C cat-macchiato-blue &
  kvantummanager --set Catppuccin-Macchiato-Blue &
  ;;
$catppuccin_mocha)
  wal --theme catppuccin-mocha &&
  change_gtk_settings "Catppuccin-Mocha-Standard-Blue-Dark" &
  change_randomwall_image_dir "$HOME/Images/Catppuccin" &
  papirus-folders -C cat-mocha-blue &
  kvantummanager --set Catppuccin-Mocha-Blue &
  ;;
$dracula)
  wal --theme dracula &&
  change_gtk_settings "Dracula" &
  change_randomwall_image_dir "$HOME/Images/Dracula" &
  papirus-folders -C dracula-default &
  kvantummanager --set Dracula &
  ;;
$gruvbox)
  wal --theme gruvbox &&
  change_gtk_settings "Gruvbox-Dark-BL-MOD" &
  change_randomwall_image_dir "$HOME/Images/Gruvbox" &
  papirus-folders -C gruvbox-material-yellow &
  kvantummanager --set gruvbox-kvantum &
  ;;
$nord)
  wal --theme nord &&
  change_gtk_settings "Nordic-darker" &
  change_randomwall_image_dir "$HOME/Images/Nord" &
  papirus-folders -C polarnight4 &
  kvantummanager --set Nordic-Darker &
  ;;
esac

# Apply other settings (mousepad, xfce4-terminal)
change_mousepad_colors &
change_xfce4_terminal_colors &

wait

# Notify user
notify-send -u normal "ColorScheme Changed" "The color scheme has been changed to ${choice}."
