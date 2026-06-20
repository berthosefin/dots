#!/bin/bash

source /tmp/matugen-xfce4-terminal

xfconf-query -c xfce4-terminal -p /color-foreground -s "$foreground"
xfconf-query -c xfce4-terminal -p /color-background -s "$background"
xfconf-query -c xfce4-terminal -p /color-cursor -s "$cursor"
xfconf-query -c xfce4-terminal -p /color-palette -s "$palette"
