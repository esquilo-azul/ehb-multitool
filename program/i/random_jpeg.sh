#!/bin/bash

source "${BASH_TO_REQUIRE}"

if [ $# -lt 1 ]; then
  fatal_error "Usage:\n\n$0 <OUTPUT_FILE>"
fi
OUTPUT_FILE="$1"

mx=320;my=256;head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- "$OUTPUT_FILE"
