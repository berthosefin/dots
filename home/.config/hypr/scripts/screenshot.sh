#!/usr/bin/env bash

# Screenshot: capture fullscreen to satty for annotation,
# saved to ~/Pictures/Screenshots with a timestamped filename.

SCREENSHOT_DIR="$(xdg-user-dir PICTURES)/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

exec grim - | satty -f - --output-filename "$SCREENSHOT_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
