# open_selector <OPTIONS> [<CHOICE>...]
function ehb_open_selector() {
  if [ "$#" -ge 2 ]; then
    open_files "$@"
  else
    user_chooses "$@"
  fi
}
export -f ehb_open_selector

# choose_option <OPTIONS_VAR>
function choose_option() {
  local OPTIONS_VAR="$1"
  local KEYS=()
  while read -r KEY; do
    KEYS+=("$KEY")
  done < <(hash_keys "$OPTIONS_VAR")
  zenity --list \
    --window-icon 'question' \
    --title="Selecione" \
    --column="Task file" \
    --height=350 \
    "${KEYS[@]}"
}

# open_files <OPTIONS_VAR> [<CHOICE>...]
function open_files() {
  local OPTIONS_VAR="$1"
  shift
  for FILE_KEY in "$@"; do
    if ! hash_key "${OPTIONS_VAR}" "$FILE_KEY"; then
      fatal_error "Key \"$FILE_KEY\" not found"
    fi
    var_set_by FILE_PATH hash_get "$OPTIONS_VAR" "$FILE_KEY"
    xdg-open "${FILE_PATH}"
  done
}

# user_chooses <OPTIONS_VAR>
function user_chooses() {
  local OPTIONS_VAR="$1"
  var_set_by CHOICE choose_option "$1"
  infov_compact 'CHOICE'
  if var_present_r 'CHOICE'; then
    open_files "$OPTIONS_VAR" "$CHOICE"
  fi
}
