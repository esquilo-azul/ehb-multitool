BIN_TARGET="${USER_BIN_DIR}/flips"

function source_path() {
  "${MYSELF_RUN}" a/git/cache_repository 'https://github.com/Alcaro/Flips.git'
}

function task_condition() {
  [[ -f "$BIN_TARGET" ]]
}

function task_fix() {
  package_assert apt 'g++' 'build-essential' 'libgtk-3-dev'
  SOURCE_DIR="$(source_path)"
  BIN_SOURCE="${SOURCE_DIR}/flips"
  if [ ! -f "$BIN_SOURCE" ]; then
    (cd "$SOURCE_DIR"; ./make-linux.sh )
  fi
  mkdir -p "$(dirname "$BIN_TARGET")"
  cp "$BIN_SOURCE" "$BIN_TARGET"
}
