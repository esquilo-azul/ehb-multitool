#!/bin/bash

source "${BASH_TO_REQUIRE}"

function ffmpeg_convert() {
  local SOURCE_FILE="$1"
  local TARGET_FILE="$2"
  ffmpeg -i "${SOURCE_FILE}" -c copy \
    -vcodec libx264 -crf 17 -filter:v format\=yuv420p \
    -acodec aac \
    -scodec copy \
    -f matroska "${TARGET_FILE}"
}

function process_file() {
  local SOURCE_FILE="$1"
  local CONVERTING_FILE="${SOURCE_FILE}.converting"
  local CONVERTED_FILE="${SOURCE_FILE}.converted"

  infov_compact SOURCE_FILE CONVERTING_FILE CONVERTED_FILE
  ffmpeg_convert "${SOURCE_FILE}" "${CONVERTING_FILE}"
  mv "${CONVERTING_FILE}" "${CONVERTED_FILE}"
}

for FILE in "$@"; do
  process_file "$FILE"
done
