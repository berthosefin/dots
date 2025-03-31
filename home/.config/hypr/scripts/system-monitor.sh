#!/bin/bash

# ----------------------------------------------
# Description : Battery and USB Monitor
# Author : Berthose Fin (Thos)
# Date : 2024-08-07
# ----------------------------------------------

# Fichier PID pour éviter les exécutions multiples
PIDFILE="/tmp/battery_usb_monitor.pid"

# Vérification si le script est déjà en cours d'exécution
if [ -e "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  echo "Le script est déjà en cours d'exécution."
  exit 1
fi

# Enregistrement du PID actuel dans le fichier PID
echo $$ >"$PIDFILE"

# Fonction de nettoyage pour supprimer le fichier PID lors de la sortie du script
cleanup() {
  rm -f "$PIDFILE"
}
trap cleanup EXIT

# Configuration de la batterie
CRITICAL_LEVEL=20  # Pourcentage critique de batterie
FULL_LEVEL=95      # Pourcentage de batterie considérée comme pleine
CHECK_INTERVAL=150 # Intervalle de vérification en secondes

# Récupération des informations sur la batterie
get_battery_info() {
  local status=$(cat /sys/class/power_supply/BAT1/status)
  local capacity=$(cat /sys/class/power_supply/BAT1/capacity)
  echo "$status $capacity"
}

# Notification
notify() {
  local urgency=$1
  local message=$2
  notify-send -u "$urgency" "System Monitor" "$message"
}

# Surveillance des niveaux de batterie critique et pleine en continu
battery_monitor() {
  while true; do
    battery_info=$(get_battery_info)
    battery_status=$(echo "$battery_info" | cut -d ' ' -f 1)
    battery_capacity=$(echo "$battery_info" | cut -d ' ' -f 2)

    # Notification pour la batterie critique
    if [ "$battery_capacity" -le "$CRITICAL_LEVEL" ] && [ "$battery_status" = "Discharging" ]; then
      notify critical "Battery critically low (${battery_capacity}%). Please plug in the charger."
    fi

    # Notification pour la batterie pleine
    if [ "$battery_capacity" -ge "$FULL_LEVEL" ] && [ "$battery_status" = "Charging" ]; then
      notify low "Battery is almost full (${battery_capacity}%). You can unplug the charger."
    fi

    sleep "$CHECK_INTERVAL"
  done
}

# Lancer le moniteur de batterie dans un sous-processus
battery_monitor &

# Surveillance en temps réel des événements udev
udevadm monitor --udev --property --subsystem-match=power_supply --subsystem-match=usb | while read -r line; do
  # Surveillance de la batterie
  if echo "$line" | grep -q "POWER_SUPPLY_STATUS="; then
    battery_info=$(get_battery_info)
    battery_status=$(echo "$battery_info" | cut -d ' ' -f 1)
    battery_capacity=$(echo "$battery_info" | cut -d ' ' -f 2)

    # Détection des changements de branchement/débranchement
    if [ "$battery_status" != "$previous_battery_status" ]; then
      if [ "$battery_status" = "Charging" ]; then
        notify normal "Charging - Battery is now plugged in."
      elif [ "$battery_status" = "Discharging" ]; then
        notify normal "Discharging - Battery is now unplugged."
      fi
      previous_battery_status=$battery_status
    fi
  fi

  # Surveillance des périphériques USB
  current_usb_devices=$(lsusb)
  if echo "$line" | grep -q "add"; then
    if [ "$current_usb_devices" != "$previous_usb_devices" ]; then
      notify normal "USB device plugged in."
      previous_usb_devices="$current_usb_devices"
    fi
  elif echo "$line" | grep -q "remove"; then
    if [ "$current_usb_devices" != "$previous_usb_devices" ]; then
      notify normal "USB device unplugged."
      previous_usb_devices="$current_usb_devices"
    fi
  fi
done
