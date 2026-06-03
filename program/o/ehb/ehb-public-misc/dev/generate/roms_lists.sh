#!/bin/bash

source "${BASH_TO_REQUIRE}"

function erd_nds_generate_list {
  local PROGRAM="$1"
  if [[ $# -ge 2 ]]; then
    local PLATAFORM="$2"
  else
    var_set_by PLATAFORM basename "$PROGRAM"
  fi
  local SUB_PATH="$(basename "$PROGRAM")"
  local TARGET_ROOT="${EHBPUBLICMISC_DEV_INSTALL_PATH}/content/videogames/plataformas"
  local TARGET_PATH="${TARGET_ROOT}/${PLATAFORM}/jogos/body.adoc"

  infov 'Gerando' "$TARGET_PATH"
  mkdir -p "$(dirname "$TARGET_PATH")"
  "${PROGRAMEIRO_RUNNER}" "${PROGRAM}" --format asciidoc --output "$TARGET_PATH"
}

erd_nds_generate_list '/o/ehb/erd/nds/roms-list/gb'
erd_nds_generate_list '/o/ehb/erd/nds/roms-list/gba'
erd_nds_generate_list '/o/ehb/erd/nds/roms-list/gbc'
erd_nds_generate_list '/o/ehb/erd/nds/roms-list/nds'
erd_nds_generate_list '/o/ehb/erd/nds/roms-list/nes'
erd_nds_generate_list '/o/ehb/erd/snes/roms-list' 'snes'
