#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]
  then echo "Please run this script as root / sudo!"
  exit
fi

sudo nixos-rebuild switch --flake /etc/nixos/#default
echo "Reached end of the build script"
