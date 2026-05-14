#!/bin/bash

source "${BASH_TO_REQUIRE}"

function subdir_sync() {
  SOURCE="${EHBRSDISK_WII_SOURCE_PATH}/$1"
  TARGET="${EHBRSDISK_WII_INSTALL_PATH}/$1"
  shift
  "${PROGRAMEIRO_RUNNER}" f/sync/rsync "$@" --fat "$SOURCE" "$TARGET"
}

subdir_sync apps -e usbloader_gx "$@"
subdir_sync games --delete -E '--copy-links' "$@"
subdir_sync roms --delete -E '--copy-links' "$@"
subdir_sync wbfs --delete -E '--copy-links' "$@"
