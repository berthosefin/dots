#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lang.sh"

uptime=$(uptime -p | sed -e 's/up //g')

options="$T_LOCK\n$T_SUSPEND\n$T_LOGOUT\n$T_REBOOT\n$T_POWEROFF"

chosen=$(echo -e "$options" | rofi -dmenu -i -fuzzy -l 5 -p "$T_UPTIME: $uptime")

confirm_exit() {
  echo -e "$T_NO\n$T_YES" | rofi -dmenu -p "$T_ARE_YOU_SURE" -i -fuzzy -l 2
}

[ -z "$chosen" ] && exit 0

case "$chosen" in
"$T_POWEROFF")
  confirm=$(confirm_exit)
  [ "$confirm" = "$T_YES" ] && systemctl poweroff
  ;;
"$T_REBOOT")
  confirm=$(confirm_exit)
  [ "$confirm" = "$T_YES" ] && systemctl reboot
  ;;
"$T_LOCK")
  hyprlock
  ;;
"$T_SUSPEND")
  systemctl suspend
  ;;
"$T_LOGOUT")
  confirm=$(confirm_exit)
  [ "$confirm" = "$T_YES" ] && hyprctl dispatch 'hl.dsp.exit()'
  ;;
esac
