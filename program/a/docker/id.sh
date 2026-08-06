#!/bin/bash

source "${BASH_TO_REQUIRE}"

NOT_FOUND_EXIT=1

if [ "$#" -lt 1 ]; then
  1>&2 echo "Usage: $0 <CONTAINER_NAME> [NOT_FOUND_EXIT=1]"
  exit 1
fi

if [ "$#" -gt 1 ]; then
  NOT_FOUND_EXIT=$2
fi

ID=$(docker ps -aqf "name=$1")

if [ -z "$ID" ]; then
  1>&2 echo "Container not found with name \"$1\" (Exit code: $NOT_FOUND_EXIT)"
  exit $NOT_FOUND_EXIT
else
  echo "$ID"
fi
