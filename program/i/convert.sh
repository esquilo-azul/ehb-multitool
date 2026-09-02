#!/bin/bash

source "${BASH_TO_REQUIRE}"

SOURCE_FILE="$1"
EXTENSION="$2"
TARGET_FILE="$(path_without_extension "${SOURCE_FILE}")${EXTENSION}"

outout_nl "\"${SOURCE_FILE}\" => \"${TARGET_FILE}\""
convert "${SOURCE_FILE}" "${TARGET_FILE}"
rm "${SOURCE_FILE}"
