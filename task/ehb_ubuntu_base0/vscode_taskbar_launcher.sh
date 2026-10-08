DESKTOP_FILE_BASENAME='vscode-workspaces.desktop'
PANEL_ID='panel-1'

function task_dependencies() {
  outout_nl \
    core_bundle \
    ehb_ubuntu_base0/vscode
}

function task_condition() {
  local PLUGIN_ID
  PLUGIN_ID="$(launcher_plugin_id)" || return 1
  desktop_entry_content | template_diff - "$(desktop_file_path "${PLUGIN_ID}")"
}

function task_fix() {
  local PLUGIN_ID
  if PLUGIN_ID="$(launcher_plugin_id)"; then
    desktop_file_write "${PLUGIN_ID}"
  else
    PLUGIN_ID="$(plugin_id_next)"
    desktop_file_write "${PLUGIN_ID}"
    launcher_plugin_register "${PLUGIN_ID}"
  fi
  xfce4-panel -r
}

function desktop_entry_content() {
  "${PROGRAMEIRO_RUNNER}" /o/ehbrs/ehbrs_ubuntu_base0/desktop_entry \
    --extra 'Name=VS Code Workspaces' \
    --extra 'Icon=vscode' \
    -- "${PROGRAMEIRO_RUNNER}" /o/ehb/ehb_ubuntu_base0/vs-code-open
}

function desktop_file_path() {
  printf '%s\n' "${HOME}/.config/xfce4/panel/launcher-${1}/${DESKTOP_FILE_BASENAME}"
}

function desktop_file_write() {
  local TARGET_PATH
  TARGET_PATH="$(desktop_file_path "$1")"
  mkdir -p "$(dirname "${TARGET_PATH}")"
  desktop_entry_content | template_apply - "${TARGET_PATH}"
}

function panel_query() {
  xfconf-query -c xfce4-panel "$@"
}

function panel_plugin_ids() {
  panel_query -p "/panels/${PANEL_ID}/plugin-ids" | grep -E '^[0-9]+$'
}

function launcher_plugin_id() {
  local PLUGIN_ID
  for PLUGIN_ID in $(panel_plugin_ids); do
    if launcher_plugin_has_desktop_file "${PLUGIN_ID}"; then
      printf '%s\n' "${PLUGIN_ID}"
      return 0
    fi
  done
  return 1
}

function launcher_plugin_has_desktop_file() {
  [[ "$(panel_query -p "/plugins/plugin-${1}" 2> /dev/null)" == 'launcher' ]] &&
    panel_query -p "/plugins/plugin-${1}/items" 2> /dev/null | grep -qxF "${DESKTOP_FILE_BASENAME}"
}

function plugin_id_next() {
  local MAX_ID
  MAX_ID="$(panel_query -l -p /plugins | sed -nE 's|^/plugins/plugin-([0-9]+)$|\1|p' | sort -n | tail -n 1)"
  printf '%s\n' "$(( ${MAX_ID:-0} + 1 ))"
}

function launcher_plugin_register() {
  panel_query -p "/plugins/plugin-${1}" -n -t string -s launcher
  panel_query -p "/plugins/plugin-${1}/items" -n -a -t string -s "${DESKTOP_FILE_BASENAME}"
  panel_plugin_ids_write $(panel_plugin_ids_with_inserted "$1")
}

# Insere o plugin antes do primeiro separador do painel ou, se não houver, ao final.
function panel_plugin_ids_with_inserted() {
  local NEW_ID="$1" PLUGIN_ID INSERTED=0
  for PLUGIN_ID in $(panel_plugin_ids); do
    if [[ "${INSERTED}" == 0 && "$(panel_query -p "/plugins/plugin-${PLUGIN_ID}")" == 'separator' ]]; then
      printf '%s\n' "${NEW_ID}"
      INSERTED=1
    fi
    printf '%s\n' "${PLUGIN_ID}"
  done
  if [[ "${INSERTED}" == 0 ]]; then
    printf '%s\n' "${NEW_ID}"
  fi
}

function panel_plugin_ids_write() {
  local ARGS=() PLUGIN_ID
  for PLUGIN_ID in "$@"; do
    ARGS+=(-t int -s "${PLUGIN_ID}")
  done
  panel_query -p "/panels/${PANEL_ID}/plugin-ids" -a "${ARGS[@]}"
}
