#!/bin/bash

source "${BASH_TO_REQUIRE}"

PREVIEW="$(cli_arg 1 false "$@")"
infov 'Preview' "$(bool_s "$PREVIEW")"
"${PROGRAMEIRO_RUNNER}" s/ehbrs-tools music lyrics-book "$EHBRSDISK_CARRO_SOURCE_PATH" \
  -o "$EHBRSDISK_CARRO_LYRICS_BOOK_PATH"
if bool_r "$PREVIEW"; then
  xdg-open "$EHBRSDISK_CARRO_LYRICS_BOOK_PATH"
fi
