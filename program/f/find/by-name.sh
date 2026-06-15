#!/bin/bash

source "${BASH_TO_REQUIRE}"

if [ $# -lt 1 ]; then
  cliutils_usage '<NAME>'
fi

NAME='*'
for ARG in "$@"; do
  NAME="${NAME}${ARG}*"
done

infov 'Search name' "${NAME}"
find -iname "*${NAME}*"
