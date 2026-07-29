#!/bin/bash

source "${BASH_TO_REQUIRE}"

TERMS=('conflicted copy' 'Cópia em conflito' 'Case Conflict' \
  'Conflitos entre maiúsculas e minúsculas')

source "${BASH_TO_REQUIRE}"

ARGS=('(')
first=true
for TERM in "${TERMS[@]}"; do
  infov 'Term' "$TERM"
  if bool_r "$first"; then
    first=false
  else
    ARGS+=('-or')
  fi
  ARGS+=('-iname' "*${TERM}*")
done

ARGS+=(')')

infov 'Args' "${ARGS[@]}"
find "${ARGS[@]}" "$@"
