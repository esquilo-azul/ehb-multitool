#!/bin/bash

source "${BASH_TO_REQUIRE}"

PLATFORM="$1"
shift
ROMS_DIRECTORY="${EHBRSDISK_NDS_TARGET_PATH}/${PLATFORM}"

"${PROGRAMEIRO_RUNNER}" /u/vg/roms/list-generate "${ROMS_DIRECTORY}" \
  -e 'bin' \
  -e 'bmp' \
  -e 'pal' \
  -e 'pub' \
  -e 'rom' \
  -e 'sav' \
  -e 'ss0' \
  -e 'txt' \
  -e 'ys0' \
  -e 'yss' \
  -r "${PLATFORM}" \
  "$@"
