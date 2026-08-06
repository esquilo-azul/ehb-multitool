#!/bin/bash

source "${BASH_TO_REQUIRE}"

function volume_exist() {
  if [ -n "$(docker volume ls -qf "name=$VOLUME_NAME")" ]; then
    printf 'TRUE'
  else
    printf 'FALSE'
  fi
}

function volume_create() {
  docker volume create "$VOLUME_NAME"
}

function volume_remove() {
  docker volume rm "$VOLUME_NAME"
}

if [ $# -lt 2 ]; then
  infom "Usage:\n\n$0 <VOLUME_NAME> <ASSERT_EXIST>\n"
  exit 1
fi

export VOLUME_NAME="$1"
export ASSERT_EXIST="$2"

infov 'Name' "$VOLUME_NAME"
infov 'Assert exist?' "$(bool_s "$ASSERT_EXIST")"

if bool_r "$ASSERT_EXIST"; then
  if bool_r $(volume_exist); then
    infom "Volume already exist"
  else
    infom "Creating volume..."
    volume_create
  fi
else
  if bool_r $(volume_exist); then
    infom "Removing volume..."
    volume_remove
  else
    infom "Volume not exist"
  fi
fi
