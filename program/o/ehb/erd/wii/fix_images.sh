#!/bin/bash

source "${BASH_TO_REQUIRE}"

function fix_games(){
  BASE_DIR="$1"
  shift
  MOVE_ARG="$1"
  shift
  if [ ! -d "$BASE_DIR" ]; then
    fatal_error "\"$BASE_DIR\" não existe ou não é um diretório"
  fi

  infom '================================='
  infov 'Base dir' "$BASE_DIR"
  infov 'Move arg' "$MOVE_ARG"

  (cd "$BASE_DIR"; "${PROGRAMEIRO_RUNNER}" s/ehbrs-tools vg wii --recursive --move "$MOVE_ARG" . "$@" )
  find "$BASE_DIR" -mindepth 1 -empty -delete
}

fix_games "${EHBRSDISK_WII_SOURCE_PATH}/wbfs" 'WBFS:%m [%i]/%i.wbfs' "$@"
fix_games "${EHBRSDISK_WII_SOURCE_PATH}/games" 'ISO:%n [%i]/%N.iso' "$@"
du -sh "${EHBRSDISK_WII_SOURCE_PATH}"
