DEBIAN_PACKAGES=(syncthing)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_dependencies() {
  outout_nl curl
}

function task_condition() {
  package_installed apt "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg \
    https://syncthing.net/release-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
  package_assert apt "${PACKAGE_ARGUMENTS[@]}"
}
