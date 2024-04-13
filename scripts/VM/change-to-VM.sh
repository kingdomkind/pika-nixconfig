#!/usr/bin/env bash

LIBVIRT_DEFAULT_URI=qemu:///system virsh start "Windows-GPU"
line=$(pgrep looking-glass)

if test -z "$line"; then
  hyprctl dispatch exec "[workspace 11; fullscreen]" "looking-glass-client"
else
  hyprctl dispatch workspace 11
fi

hyprctl dispatch submap vm
