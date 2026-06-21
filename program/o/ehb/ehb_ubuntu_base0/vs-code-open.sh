#!/bin/bash

source "${BASH_TO_REQUIRE}"

PROJECT_EXTENSION='.code-workspace'

function files_list() {
  find "${DEVEL_VSCODE_WORKSPACES_ROOT}" -name "*${PROJECT_EXTENSION}" | sort
}

hash_init OPTIONS
while read -r FILE_PATH; do
  var_set_by FILE_BASENAME basename "${FILE_PATH}" "${PROJECT_EXTENSION}"
  hash_put OPTIONS "${FILE_BASENAME}" "${FILE_PATH}"
done < <(files_list)

ehb_open_selector 'OPTIONS' "$@"
