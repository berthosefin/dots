#!/bin/bash

# Seuils
LOW_BATTERY=20
FULL_BATTERY=95

# Obtenir les infos de batterie
battery_info=$(upower -i $(upower -e | grep BAT))
percentage=$(echo "$battery_info" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
state=$(echo "$battery_info" | grep -E "state" | awk '{print $2}')

# Notification batterie faible
if [[ "$state" == "discharging" && "$percentage" -le "$LOW_BATTERY" ]]; then
  notify-send -u critical "🔋 Batterie faible" "Il reste $percentage% de batterie ! Branche ton chargeur."
fi

# Notification batterie pleine
if [[ "$state" == "charging" && "$percentage" -ge "$FULL_BATTERY" ]]; then
  notify-send -u normal "🔌 Batterie pleine" "La batterie est à $percentage%."
fi
