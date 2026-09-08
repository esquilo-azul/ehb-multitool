DEBIAN_PACKAGES=(firefox)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_dependencies() {
  outout_nl 'ehb_ubuntu_base2/mozilla_ppa'
}

function task_condition() {
  package_installed apt "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert apt "${PACKAGE_ARGUMENTS[@]}"
}
