#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" f/sync/rsync --fat --delete "${ERD_TV_RETROARCH_SOURCE}" "${ERD_TV_RETROARCH_TARGET}" "$@"
