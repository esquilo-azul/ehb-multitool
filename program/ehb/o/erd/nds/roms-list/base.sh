#!/bin/bash

source "${BASH_TO_REQUIRE}"

PLATFORM="$1"
shift
ROMS_DIRECTORY="${EHBRSDISK_NDS_TARGET_PATH}/${PLATFORM}"

"${PROGRAMEIRO_RUNNER}" /ehb/u/vg/roms/list-generate "${ROMS_DIRECTORY}" \
  -e 'bmp' \
  -e 'pub' \
  -e 'sav' \
  -e 'ys0' \
  -e 'yss' \
  -r "${PLATFORM}" \
  "$@"
