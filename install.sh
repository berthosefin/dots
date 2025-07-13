#!/usr/bin/env bash

set -euo pipefail

STOW_DIR="home"           # directory in your repo containing symlinks
TARGET="$HOME"            # destination where links will be created

BACKUP_ROOT="$HOME/.stow-backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

echo "Target directory : $TARGET"
echo "Stow directory   : $STOW_DIR"
echo "Backup directory : $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

echo "🎨  Generating pywal theme..."
wal --theme nord

echo "📝  Dry‑running stow to detect conflicts…"
STOW_OUTPUT=$(stow -n -t "$TARGET" "$STOW_DIR" 2>&1 || true)

# Extract conflicting target paths
echo "$STOW_OUTPUT" | grep -Eo 'existing target [^ ]+' | cut -d' ' -f3 | while read -r REL_PATH; do
  ABS_PATH="$TARGET/$REL_PATH"
  if [[ -e "$ABS_PATH" ]]; then
    DEST_PATH="$BACKUP_DIR/$REL_PATH"
    echo "⚠️   Conflict: $ABS_PATH"
    echo "    → Backing up to $DEST_PATH"
    mkdir -p "$(dirname "$DEST_PATH")"
    mv "$ABS_PATH" "$DEST_PATH"
  fi
done

echo "✅  Backup finished."

echo "🔄  Running stow for real…"
stow -v -t "$TARGET" "$STOW_DIR"

echo "🎉  Done! Your dotfiles are now stowed, and originals are in $BACKUP_DIR"
