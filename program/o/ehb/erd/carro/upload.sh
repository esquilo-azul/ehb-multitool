#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" f/sync/rsync "$@" --fat --delete -E '--copy-links' "$EHBRSDISK_CARRO_SOURCE_PATH" \
  "$EHBRSDISK_CARRO_INSTALL_PATH"
