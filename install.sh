#!/usr/bin/env bash
set -euo pipefail

# Configuration
STOW_DIR="home"
TARGET="$HOME"
BACKUP_ROOT="$HOME/.stow-backups"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

# Utility functions

print_info() {
  echo "[INFO] $1"
}

print_success() {
  echo "[OK] $1"
}

print_warning() {
  echo "[WARN] $1"
}

print_error() {
  echo "[ERROR] $1" >&2
}

ask_confirmation() {
  local prompt="$1"
  local response

  while true; do
    echo -n "$prompt [y/N] "
    read -r response
    case "$response" in
      [yY]|[yY][eE][sS])
        return 0
        ;;
      [nN]|[nN][oO]|"")
        return 1
        ;;
      *)
        print_error "Invalid response. Please answer 'y' (yes) or 'n' (no)."
        ;;
    esac
  done
}

# Main script

echo "=== Dotfiles Installation with Stow ==="
echo ""
print_info "Target directory  : $TARGET"
print_info "Stow directory    : $STOW_DIR"
print_info "Backup directory  : $BACKUP_DIR"
echo ""

# Check that the stow directory exists
if [[ ! -d "$STOW_DIR" ]]; then
    print_error "Directory '$STOW_DIR' does not exist."
    exit 1
fi

# Phase 1: Conflict detection

print_info "Scanning for conflicts (dry-run)..."
STOW_OUTPUT=$(stow -n -t "$TARGET" "$STOW_DIR" 2>&1 || true)

# Extract conflicting paths
CONFLICTS=$(echo "$STOW_OUTPUT" | \
    grep -E 'conflicts:' -A1000 | \
    grep -E '^\s+\* ' | \
    sed -E 's/^\s+\* cannot stow .* over existing target (.*) since.*/\1/' || true)

# Count conflicts
CONFLICT_COUNT=0
if [[ -n "$CONFLICTS" ]]; then
    CONFLICT_COUNT=$(echo "$CONFLICTS" | grep -c . || true)
fi

# Phase 2: Conflict handling

if [[ $CONFLICT_COUNT -eq 0 ]]; then
    print_success "No conflicts detected."
else
    echo ""
    print_warning "$CONFLICT_COUNT conflicting file(s)/folder(s) found:"
    echo ""
    echo "$CONFLICTS" | while read -r REL_PATH; do
        [[ -z "$REL_PATH" ]] && continue
        echo "  - $TARGET/$REL_PATH"
    done
    echo ""

    if ask_confirmation "Back up these files before installing?"; then
        print_info "Creating backup directory..."
        mkdir -p "$BACKUP_DIR"

        BACKUP_SUCCESS=0
        BACKUP_FAILED=0

        echo "$CONFLICTS" | while read -r REL_PATH; do
            [[ -z "$REL_PATH" ]] && continue

            ABS_PATH="$TARGET/$REL_PATH"
            if [[ -e "$ABS_PATH" ]]; then
                DEST_PATH="$BACKUP_DIR/$REL_PATH"

                print_info "Backing up: $REL_PATH"
                mkdir -p "$(dirname "$DEST_PATH")"

                if mv "$ABS_PATH" "$DEST_PATH" 2>/dev/null; then
                    ((BACKUP_SUCCESS++)) || true
                else
                    print_error "Failed to back up: $REL_PATH"
                    ((BACKUP_FAILED++)) || true
                fi
            fi
        done

        echo ""
        print_success "Backup complete: $BACKUP_SUCCESS file(s) saved."
        [[ $BACKUP_FAILED -gt 0 ]] && print_warning "$BACKUP_FAILED failure(s)."
        print_info "Backups stored in: $BACKUP_DIR"
    else
        print_warning "Installation cancelled by user."
        echo ""
        print_info "To force installation without a backup, remove the conflicting files manually."
        exit 0
    fi
fi

# Phase 3: Installation with stow

echo ""
print_info "Installing dotfiles with stow..."
if stow -v -t "$TARGET" "$STOW_DIR" 2>&1; then
    echo ""
    print_success "Installation complete."
    echo ""
    echo "=== Summary ==="
    [[ $CONFLICT_COUNT -gt 0 ]] && echo "Files backed up : $CONFLICT_COUNT"
    [[ $CONFLICT_COUNT -gt 0 ]] && echo "Backup location : $BACKUP_DIR"
    echo "Dotfiles installed successfully."

    if [[ $CONFLICT_COUNT -gt 0 ]]; then
        echo ""
        print_info "To restore previous files:"
        echo "  cp -r $BACKUP_DIR/* $TARGET/"
    fi
else
    echo ""
    print_error "Installation failed."
    echo ""
    print_info "Check the errors above and try again."
    exit 1
fi
