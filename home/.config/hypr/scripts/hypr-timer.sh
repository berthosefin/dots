#!/bin/bash

# Battery
while true; do
  sleep 60
  sh ~/.config/hypr/scripts/hypr-battery-check.sh
done &
