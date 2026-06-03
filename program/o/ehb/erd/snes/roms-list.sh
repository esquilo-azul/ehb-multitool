#!/bin/bash

source "${BASH_TO_REQUIRE}"

ROMS_DIRECTORY="${EHBRSDISK_SNES_INSTALL_PATH}"
if [[ ! -d "${ROMS_DIRECTORY}" ]]; then
  ROMS_DIRECTORY="${ EHBRSDISK_SNES_TARGET_PATH}"
fi

"${PROGRAMEIRO_RUNNER}" /u/vg/roms/list-generate "${ROMS_DIRECTORY}" \
  -e xml \
  -r sfc \
  -r bs \
  "$@"
