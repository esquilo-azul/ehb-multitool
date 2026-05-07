#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" /m/sources/ruby/gems/exe_wrapper ehbrs-tools "$EHBRSTOOLS_DEV_INSTALL_PATH" ehbrs "$@"
