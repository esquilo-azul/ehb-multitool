#!/bin/bash

source "${BASH_TO_REQUIRE}"

mkdir -p "${ERD_EHBTV_SOURCE_PATH}"
"${PROGRAMEIRO_RUNNER}" s/ehbrs-tools fs selected --build-dir "${ERD_EHBTV_SOURCE_PATH}" \
  --filename '.ehb' \
  "${BBFLN_100_VIDEOS_ROOT}" "$@"
