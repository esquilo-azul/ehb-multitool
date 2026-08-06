#!/bin/bash

source "${BASH_TO_REQUIRE}"

function run_on_run() {
  FIRST_CMD=()
  while true; do
    ARG="$1"
    shift
    if [ "$ARG" == ';' ]; then
      break
    else
      FIRST_CMD+=("$ARG")
      infov 'After' "${FIRST_CMD[@]}"
    fi
  done
  if [ -n "$(docker "$@")" ]; then
    docker "${FIRST_CMD[@]}" $(docker "$@")
  fi
}

function stop_containers() {
  run_on_run kill \; ps -q
}

function remove_containers() {
  run_on_run rm \; ps -aq
}

function remove_volumes() {
  run_on_run volume rm \; volume ls -q
}

function remove_images() {
  run_on_run rmi -f \; images -q
}

function remove_networks() {
  run_on_run network rm \; network ls -q
}

cliutils_run_jobs stop_containers remove_containers remove_volumes remove_images remove_networks
