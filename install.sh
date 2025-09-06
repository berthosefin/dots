#!/usr/bin/env bash

set -euo pipefail

STOW_DIR="home"
TARGET="$HOME"

BACKUP_ROOT="$HOME/.stow-backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

echo "Target directory : $TARGET"
echo "Stow directory   : $STOW_DIR"
echo "Backup directory : $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

if [[ ! -f "$HOME/.cache/wal/colors-hyprland.conf" ]]; then
  echo "[*] Generating pywal theme..."
  wal --theme base16-nord
fi

echo "[*] Dry-running stow to detect conflicts…"
STOW_OUTPUT=$(stow -n -t "$TARGET" "$STOW_DIR" 2>&1 || true)

# Extract conflicting target paths (both inline + warning block)
CONFLICTS=$(echo "$STOW_OUTPUT" |
  grep -E 'conflicts:' -A1000 |
  grep -E '^\s+\* ' |
  sed -E 's/^\s+\* cannot stow .* over existing target (.*) since.*/\1/' || true)

# Backup conflicts if any
if [[ -n "$CONFLICTS" ]]; then
  echo "$CONFLICTS" | while read -r REL_PATH; do
    [[ -z "$REL_PATH" ]] && continue
    ABS_PATH="$TARGET/$REL_PATH"
    if [[ -e "$ABS_PATH" ]]; then
      DEST_PATH="$BACKUP_DIR/$REL_PATH"
      echo "[!] Conflict: $ABS_PATH"
      echo "    -> Backing up to $DEST_PATH"
      mkdir -p "$(dirname "$DEST_PATH")"
      mv "$ABS_PATH" "$DEST_PATH"
      echo "[✔] Backup finished."
    fi
  done
else
  echo "[*] No conflicts detected."
fi

echo "[*] Running stow for real…"
stow -v -t "$TARGET" "$STOW_DIR"

echo "[✔] Done! Dotfiles are now stowed."
