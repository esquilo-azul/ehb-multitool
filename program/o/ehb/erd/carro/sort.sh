#!/bin/bash

source "${BASH_TO_REQUIRE}"

function mount_device() {
  set +e
  mount | grep "$EHBRSDISK_CARRO_INSTALL_PATH" | grep -o '^\S\+'
  set -e
}

if [ $# -ge 1 ]; then
  DEVICE="$1"
else
  DEVICE="$(mount_device)"
fi

infov 'Device' "$DEVICE"
if [ -z "$DEVICE" ]; then
  fatal_error "Device not found for directory \"$EHBRSDISK_CARRO_INSTALL_PATH\""
fi

infom "Umounting directory..."
sudo umount "$EHBRSDISK_CARRO_INSTALL_PATH"

infom "Sorting..."
sudo fatsort -n "$DEVICE"
