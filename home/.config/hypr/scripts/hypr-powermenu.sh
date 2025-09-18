#!/usr/bin/env bash

# Get system uptime
uptime=$(uptime -p | sed -e 's/up //g')

# Define menu options
shutdown=" Poweroff"
reboot=" Reboot"
suspend=" Suspend"
lock=" Lock"
logout=" Logout"
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

# Show main menu
chosen=$(echo -e "$options" | rofi -dmenu -l 5 -p "Uptime: $uptime")

# Function for confirmation
confirm_exit() {
  echo -e "No\nYes" | rofi -dmenu -p "Are you sure?" -l 2
}

# If nothing is selected, exit
[ -z "$chosen" ] && exit 0

# Execute based on selection
case "$chosen" in
"$shutdown")
  confirm=$(confirm_exit)
  [ "$confirm" = "Yes" ] && systemctl poweroff
  ;;
"$reboot")
  confirm=$(confirm_exit)
  [ "$confirm" = "Yes" ] && systemctl reboot
  ;;
"$lock")
  hyprlock
  ;;
"$suspend")
  systemctl suspend
  ;;
"$logout")
  confirm=$(confirm_exit)
  [ "$confirm" = "Yes" ] && hyprctl dispatch exit
  ;;
esac
