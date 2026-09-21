var_set_by TARGET_NAME systemd-escape -p --suffix=mount "${BBFLN_100_STORAGE_MOUNT_PATH}"
TARGET_PATH="/etc/systemd/system/${TARGET_NAME}"

function unit_content() {
  "${PROGRAMEIRO_RUNNER}" /a/systemd/disk-mount-unit \
    "${BBFLN_100_STORAGE_MOUNT_PATH}" \
    "${BBFLN_100_STORAGE_UUID}"
}

function task_condition() {
  unit_content | template_diff - "${TARGET_PATH}" && \
    SUDO=true package_installed systemctl "${TARGET_NAME}"
}

function task_fix() {
  unit_content | SUDO=t template_apply - "${TARGET_PATH}"
  SUDO=t package_assert systemctl "${TARGET_NAME}"
}
