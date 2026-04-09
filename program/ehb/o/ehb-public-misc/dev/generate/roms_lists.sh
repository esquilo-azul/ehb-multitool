#!/bin/bash

source "${BASH_TO_REQUIRE}"

function erd_nds_generate_list {
  local PROGRAM="$1"
  local SUB_PATH="$(basename "$PROGRAM")"
  local TARGET_ROOT="${EHBPUBLICMISC_DEV_INSTALL_PATH}/content/videogames/plataformas"
  local TARGET_PATH="${TARGET_ROOT}/${SUB_PATH}/jogos/body.adoc"

  infov 'Gerando' "$TARGET_PATH"
  mkdir -p "$(dirname "$TARGET_PATH")"
  "${PROGRAMEIRO_RUNNER}" "${PROGRAM}" --format asciidoc --output "$TARGET_PATH"
}

erd_nds_generate_list '/ehb/o/erd/nds/roms-list/gb'
erd_nds_generate_list '/ehb/o/erd/nds/roms-list/gba'
erd_nds_generate_list '/ehb/o/erd/nds/roms-list/gbc'
erd_nds_generate_list '/ehb/o/erd/nds/roms-list/nds'
