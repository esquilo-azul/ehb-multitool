SNAP_PACKAGES=(whatsie)
PACKAGE_ARGUMENTS=(snap "${SNAP_PACKAGES[@]}")

function task_condition() {
  package_installed "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert "${PACKAGE_ARGUMENTS[@]}"
}
