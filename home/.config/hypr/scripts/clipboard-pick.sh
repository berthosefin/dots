#!/usr/bin/env bash

# Clipboard picker: select a cliphist entry via rofi
# and copy it back to the clipboard.

exec cliphist list | rofi -dmenu -display-columns 2 -p 'Clipboard' -l 10 | cliphist decode | wl-copy
