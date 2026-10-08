#!/bin/bash

source "${BASH_TO_REQUIRE}"

img2pdf \
  --border 5mm \
  --fit into \
  --pagesize A4 \
  "$@"
