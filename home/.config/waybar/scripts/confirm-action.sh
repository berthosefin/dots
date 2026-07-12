#!/bin/bash

action=$1
message=""
command=""

case "$action" in
    poweroff)
        message="Shut down?"
        command="systemctl poweroff"
        ;;
    reboot)
        message="Reboot?"
        command="systemctl reboot"
        ;;
    quit)
        message="Quit Hyprland?"
        command="hyprctl dispatch 'hl.dsp.exit()'"
        ;;
    *)
        notify-send "Unsupported action" "$action"
        exit 1
        ;;
esac

confirm=$(echo -e "No\nYes" | rofi -dmenu -p "$message" -l 2 -i -fuzzy)

if [[ "$confirm" == "Yes" ]]; then
    $command
fi
