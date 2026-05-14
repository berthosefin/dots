#!/usr/bin/env bash
set -euo pipefail

# Configuration
BACKUP_ROOT="$HOME/.stow-backups"
TARGET="$HOME"

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
            [yY]|[yY][eE][sS]) return 0 ;;
            [nN]|[nN][oO]|"") return 1 ;;
            *) print_error "Invalid response." ;;
        esac
    done
}

# Main functions

list_backups() {
    if [[ ! -d "$BACKUP_ROOT" ]]; then
        print_warning "No backups found."
        return
    fi

    local backups=($(ls -1t "$BACKUP_ROOT" 2>/dev/null || true))

    if [[ ${#backups[@]} -eq 0 ]]; then
        print_warning "No backups found."
        return
    fi

    echo ""
    echo "Available backups:"
    echo ""

    local idx=1
    for backup in "${backups[@]}"; do
        local backup_path="$BACKUP_ROOT/$backup"
        local size=$(du -sh "$backup_path" 2>/dev/null | cut -f1)
        local file_count=$(find "$backup_path" -type f 2>/dev/null | wc -l)

        echo "  [$idx] $backup"
        echo "       Size: $size | Files: $file_count"
        echo ""
        ((idx++))
    done
}

restore_backup() {
    local backup_name="$1"
    local backup_path="$BACKUP_ROOT/$backup_name"

    if [[ ! -d "$backup_path" ]]; then
        print_error "Backup '$backup_name' does not exist."
        return 1
    fi

    print_warning "This will restore files from the backup."
    print_warning "Existing files will be overwritten."
    echo ""

    if ! ask_confirmation "Are you sure you want to restore this backup?"; then
        print_info "Restoration cancelled."
        return 0
    fi

    print_info "Restoring..."

    local total_files=$(find "$backup_path" -type f | wc -l)
    local restored=0
    local failed=0

    while IFS= read -r -d '' file; do
        local rel_path="${file#$backup_path/}"
        local dest_path="$TARGET/$rel_path"

        mkdir -p "$(dirname "$dest_path")"

        if cp -a "$file" "$dest_path" 2>/dev/null; then
            ((restored++))
        else
            ((failed++))
            print_error "Failed: $rel_path"
        fi
    done < <(find "$backup_path" -type f -print0)

    echo ""
    print_success "Restoration complete: $restored/$total_files file(s)."
    [[ $failed -gt 0 ]] && print_warning "$failed failure(s)."
}

delete_backup() {
    local backup_name="$1"
    local backup_path="$BACKUP_ROOT/$backup_name"

    if [[ ! -d "$backup_path" ]]; then
        print_error "Backup '$backup_name' does not exist."
        return 1
    fi

    print_warning "This will permanently delete the backup."
    echo ""

    if ! ask_confirmation "Are you sure you want to delete this backup?"; then
        print_info "Deletion cancelled."
        return 0
    fi

    if rm -rf "$backup_path"; then
        print_success "Backup deleted: $backup_name"
    else
        print_error "Deletion failed."
        return 1
    fi
}

delete_all_backups() {
    if [[ ! -d "$BACKUP_ROOT" ]]; then
        print_warning "No backups to delete."
        return
    fi

    local backup_count=$(ls -1 "$BACKUP_ROOT" 2>/dev/null | wc -l)

    if [[ $backup_count -eq 0 ]]; then
        print_warning "No backups to delete."
        return
    fi

    print_warning "This will permanently delete ALL backups ($backup_count)."
    echo ""

    if ! ask_confirmation "Are you absolutely sure?"; then
        print_info "Deletion cancelled."
        return 0
    fi

    if rm -rf "$BACKUP_ROOT"; then
        print_success "All backups deleted."
    else
        print_error "Deletion failed."
        return 1
    fi
}

show_usage() {
    cat <<EOF
Usage: $0 <command> [options]

Commands:
  list                    List all backups
  restore <backup_name>   Restore a specific backup
  delete <backup_name>    Delete a specific backup
  clean                   Delete all backups
  help                    Show this help message

Examples:
  $0 list
  $0 restore 20240514-123456
  $0 delete 20240514-123456
  $0 clean
EOF
}

# Entry point

main() {
    if [[ $# -eq 0 ]]; then
        echo "=== Stow Backup Manager ==="
        echo ""
        show_usage
        exit 0
    fi

    local command="$1"
    shift

    case "$command" in
        list)
            echo "=== Stow Backup Manager ==="
            list_backups
            ;;
        restore)
            if [[ $# -eq 0 ]]; then
                print_error "Please specify the name of the backup to restore."
                echo ""
                list_backups
                exit 1
            fi
            echo "=== Stow Backup Manager ==="
            echo ""
            restore_backup "$1"
            ;;
        delete)
            if [[ $# -eq 0 ]]; then
                print_error "Please specify the name of the backup to delete."
                echo ""
                list_backups
                exit 1
            fi
            echo "=== Stow Backup Manager ==="
            echo ""
            delete_backup "$1"
            ;;
        clean)
            echo "=== Stow Backup Manager ==="
            echo ""
            delete_all_backups
            ;;
        help|--help|-h)
            echo "=== Stow Backup Manager ==="
            echo ""
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
