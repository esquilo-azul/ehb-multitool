#!/bin/bash

source "${BASH_TO_REQUIRE}"

function find_by_name() {
  find -type f -iname "*${NAME}*" "$@"
}

if [ $# -lt 1 ]; then
  cliutils_usage '<NAME>' '[<TARGET_DIR>]'
fi

export NAME="$1"
var_set_by TARGET_DIRECTORY cli_arg 2 '' "$@"
infov_compact NAME TARGET_DIRECTORY

find_by_name

if [[ -n "${TARGET_DIRECTORY}" ]]; then
  if [[ -d "${TARGET_DIRECTORY}" ]]; then
    find_by_name -exec mv '{}' "${TARGET_DIRECTORY}" \;
  else
    fatal_error "\"${TARGET_DIRECTORY}\" is not a directory"
  fi
fi
