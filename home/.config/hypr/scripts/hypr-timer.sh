#!/bin/bash

# Seuils
LOW_BATTERY=20
FULL_BATTERY=95
BAT="/sys/class/power_supply/BAT1"
capacity_file="$BAT/capacity"
status_file="$BAT/status"

notified_low=0
notified_full=0

while true; do
  sleep 300
  [[ -f "$capacity_file" ]] || exit 0

  percentage=$(cat "$capacity_file")
  state=$(cat "$status_file")

  # Notification batterie faible (une seule fois, en décharge uniquement)
  if [[ "$state" == "Discharging" && "$percentage" -le "$LOW_BATTERY" ]]; then
    if [[ $notified_low -eq 0 ]]; then
      notify-send -u critical "🔋 Batterie faible" "Il reste $percentage% de batterie ! Branche ton chargeur."
      notified_low=1
    fi
  else
    notified_low=0
  fi

  # Notification batterie pleine (une seule fois)
  if [[ "$state" == "Charging" && "$percentage" -ge "$FULL_BATTERY" ]]; then
    if [[ $notified_full -eq 0 ]]; then
      notify-send -u normal "🔌 Batterie pleine" "La batterie est à $percentage%."
      notified_full=1
    fi
  else
    notified_full=0
  fi
done
