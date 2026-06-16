#!/bin/bash

source "${BASH_TO_REQUIRE}"

function rom_file() {
  var_set_by BASENAME basename_without_extension "$1"
  find "${EHBRSDISK_SNES_INSTALL_PATH}" -type f -name "$(printf '%q' "${BASENAME}.sfc")"
}

function doc_file_perform() {
  local DOC_FILE="$1"
  var_set_by BASENAME basename_without_extension "$DOC_FILE"
  var_set_by ROM_FILE rom_file "$DOC_FILE"
  infov "${BASENAME}" "${ROM_FILE}"

  if [[ -f "${ROM_FILE}" ]]; then
    var_set_by DOC_DIRECTORY dirname "${DOC_FILE}"
    var_set_by ROM_DIRECTORY dirname "${ROM_FILE}"

    if [[ "${DOC_DIRECTORY}" != "${ROM_DIRECTORY}" ]]; then
      infom "Moving \"${DOC_FILE}\" to \"${ROM_DIRECTORY}\"..."
      mv "${DOC_FILE}" "${ROM_DIRECTORY}"
    fi
  fi
}

DOC_DIR="${EHBRSDISK_SNES_INSTALL_PATH}/docs"

while read -r DOC_FILE; do
  doc_file_perform "$DOC_FILE"
done < <(find "${DOC_DIR}" -type f )
