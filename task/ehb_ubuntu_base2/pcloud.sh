PCLOUD_SOURCE='https://www.pcloud.com/how-to-install-pcloud-drive-linux.html?download=electron-64'
PCLOUD_SOURCE_CACHE="$HOME/.cache/pcloud"
PCLOUD_DIR="$HOME/opt/network/pcloud"
PCLOUD_BIN="${PCLOUD_DIR}/pcloud"

function start_banner() {
  infov 'Source' "$PCLOUD_SOURCE"
  infov 'Source cache' "$PCLOUD_SOURCE_CACHE"
  infov 'Target directory' "$PCLOUD_DIR"
  infov 'Executable' "$PCLOUD_BIN"
}

function file_is_a_executable() {
  [ "$(file_mime_type "$PCLOUD_BIN")" == "application/x-executable" ]
}

function pcloud_bin_application() {
  if [ ! -f "$PCLOUD_BIN" ]; then
    return 1
  fi

  if ! file_is_a_executable; then
    return 1
  fi

  return 0
}

function pcloud_dependencies() {
  if package_assert apt libfuse2t64; then
    return
  fi

  package_assert apt libfuse2
}

function pcloud_install() {
  if ! pcloud_bin_application; then
    wget --continue -O "$PCLOUD_SOURCE_CACHE" "$PCLOUD_SOURCE"
    if ! file_is_a_executable "$PCLOUD_SOURCE_CACHE"; then
      fatal_error "Downloaded file \"${PCLOUD_SOURCE_CACHE}\" is not a executable"
    fi
    mkdir -p "$PCLOUD_DIR"
    mv "$PCLOUD_SOURCE_CACHE" "$PCLOUD_BIN"
  else
    infom "\"$PCLOUD_BIN\" already installed"
  fi
  chmod +x "${PCLOUD_BIN}"
}

function task_condition() {
  deb_installed "${DEBIAN_PACKAGES[@]}"
}

function task_fix() {
  pcloud_dependencies
  pcloud_install
}






cliutils_run_jobs start_banner pcloud_dependencies pcloud_install
