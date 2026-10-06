#!/usr/bin/env bash

# Screenshot: fullscreen capture with grim.
# Usage: screenshot.sh [annotate]
#   (no arg)   -> quick capture to ~/Pictures/Screenshots
#   annotate   -> capture + satty annotation

SCREENSHOT_DIR="$(xdg-user-dir PICTURES)/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILE="$SCREENSHOT_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

if [ "${1:-}" = "annotate" ]; then
  exec grim - | satty -f - --output-filename "$FILE"
else
  exec grim "$FILE"
fi