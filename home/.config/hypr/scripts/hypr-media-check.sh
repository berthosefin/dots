#!/bin/bash

# Vérifier playerctl pour les lecteurs compatibles MPRIS
if playerctl status 2>/dev/null | grep -q "Playing"; then
  exit 1 # Empêcher la suspension
fi

# Vérifier les processus spécifiques
if pgrep -f "vlc\|mpv" >/dev/null; then
  exit 1
fi

# Vérifier Firefox avec audio (nécessite pulseaudio-utils)
if pgrep firefox >/dev/null && pactl list sink-inputs | grep -q "application.process.binary.*firefox"; then
  exit 1
fi

exit 0 # Autoriser la suspension
