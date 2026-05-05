#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" /s/eac-tools --no-input source -C "$EHBPUBLICMISC_DEV_INSTALL_PATH" "$@"
