#!/bin/bash

action=$1
message=""
command=""

case "$action" in
    poweroff)
        message="Éteindre l'ordinateur ?"
        command="systemctl poweroff"
        ;;
    reboot)
        message="Redémarrer l'ordinateur ?"
        command="systemctl reboot"
        ;;
    quit)
        message="Quitter Hyprland ?"
        command="hyprctl dispatch exit"
        ;;
    *)
        notify-send "Action non supportée" "$action"
        exit 1
        ;;
esac

confirm=$(echo -e "Non\nOui" | rofi -dmenu -p "$message")

if [[ "$confirm" == "Oui" ]]; then
    $command
fi
