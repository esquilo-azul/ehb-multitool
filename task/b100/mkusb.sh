DEBIAN_PACKAGES=(mkusb)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_condition() {
  package_installed apt "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  sudo add-apt-repository --yes --no-update ppa:mkusb/ppa
  package_assert apt "${PACKAGE_ARGUMENTS[@]}"
}
