PACKAGE_ARGUMENTS=(systemctl "syncthing@${USER}.service")

function task_dependencies() {
  outout_nl ehb_ubuntu_base1/syncthing/package
}

function task_condition() {
  SUDO=t package_installed "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  SUDO=t package_assert "${PACKAGE_ARGUMENTS[@]}"
}
