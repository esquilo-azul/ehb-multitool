# Referência: https://code.visualstudio.com/docs/setup/linux

DEBIAN_PACKAGES=(code)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")
KEYRING_FILE='/usr/share/keyrings/microsoft.gpg'
SOURCES_FILE='/etc/apt/sources.list.d/vscode.sources'

function task_condition() {
  package_installed "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert apt curl gpg apt-transport-https
  keyring_write
  sources_write
  package_assert "${PACKAGE_ARGUMENTS[@]}"
}

function keyring_write() {
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | \
    sudo tee "${KEYRING_FILE}" > /dev/null
}

function sources_write() {
  printf '%s\n' \
    'Types: deb' \
    'URIs: https://packages.microsoft.com/repos/code' \
    'Suites: stable' \
    'Components: main' \
    'Architectures: amd64,arm64,armhf' \
    "Signed-By: ${KEYRING_FILE}" | \
    sudo tee "${SOURCES_FILE}" > /dev/null
}
