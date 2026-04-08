#!/bin/bash

# Configuration des dossiers
NORMAL_DIR=~/Documents/gdrive
CRYPT_DIR=~/Documents/gdrive/crypt
LOG_DIR=~/Documents/backup_logs
mkdir -p "$LOG_DIR"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/backup_$DATE.log"
CONFLICT_LOG="$LOG_DIR/conflicts_$DATE.log"

echo "Debut du backup : $DATE" | tee -a "$LOG_FILE"

# Backup crypté (push uniquement)
echo "Backup crypté (crypt)" | tee -a "$LOG_FILE"
rclone copy "$CRYPT_DIR" gdrive-crypt: --progress 2>&1 | tee -a "$LOG_FILE"

# Synchronisation bidirectionnelle du dossier normal
echo "Synchronisation bidirectionnelle (normal)" | tee -a "$LOG_FILE"
rclone bisync "$NORMAL_DIR" gdrive:/ --exclude "crypt/**" 2>&1 | tee -a "$LOG_FILE"

# Detection des conflits
echo "Recherche des conflits" | tee -a "$LOG_FILE"
find "$NORMAL_DIR" -name "*_conflict*" >"$CONFLICT_LOG"
if [ -s "$CONFLICT_LOG" ]; then
  echo "Conflits detectes. Voir $CONFLICT_LOG" | tee -a "$LOG_FILE"
else
  echo "Aucun conflit detecte." | tee -a "$LOG_FILE"
fi

echo "Backup termine : $DATE" | tee -a "$LOG_FILE"
