#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" f/sync/rsync --fat --delete "$@" "${ERD_EHBTV_SOURCE_PATH}" "${ERD_EHBTV_INSTALL_PATH}/videos"
