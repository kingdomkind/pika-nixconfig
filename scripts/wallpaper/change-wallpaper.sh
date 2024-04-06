#!/usr/bin/env bash

if [ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]; then
  SCRIPT_DIRECTORY="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
  DIRECTORY="$SCRIPT_DIRECTORY/pictures"
  WALLPAPER=$(ls $DIRECTORY | shuf -n 1)
  FINAL="$SCRIPT_DIRECTORY/pictures/$WALLPAPER"

  wal -i "$FINAL"
  swww img $FINAL --transition-type wipe --transition-angle 30 --transition-fps 120 --transition-step 50
  killall -SIGUSR2 .waybar-wrapped
  pkill dunst
  rm /home/pika/.config/dunst/dunstrc
  cp /home/pika/.cache/wal/dunstrc /home/pika/.config/dunst/dunstrc
  dunst
fi
