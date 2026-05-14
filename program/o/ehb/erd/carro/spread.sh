#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" s/ehbrs-tools music spread "$@" "$EHBRSDISK_CARRO_SOURCE_PATH/"*
