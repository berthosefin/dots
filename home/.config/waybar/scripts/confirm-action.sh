#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../hypr/scripts/lang.sh"

action=$1
message=""
command=""

case "$action" in
    poweroff)
        message="$T_SHUT_DOWN"
        command="systemctl poweroff"
        ;;
    reboot)
        message="$T_REBOOT_Q"
        command="systemctl reboot"
        ;;
    quit)
        message="$T_QUIT_HYPRLAND"
        command="hyprctl dispatch 'hl.dsp.exit()'"
        ;;
    *)
        notify-send "$T_UNSUPPORTED" "$action"
        exit 1
        ;;
esac

confirm=$(echo -e "$T_NO\n$T_YES" | rofi -dmenu -p "$message" -l 2 -i -fuzzy)

if [[ "$confirm" == "$T_YES" ]]; then
    $command
fi
