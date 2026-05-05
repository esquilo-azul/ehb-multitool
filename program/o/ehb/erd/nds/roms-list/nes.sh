#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" base 'nes' -r 'fds' -r 'unf' -r 'NES' "$@"
