#!/bin/bash

source "${BASH_TO_REQUIRE}"

if [[ $# -lt 2 ]]; then
  fatal_error "Usage: $0 <MOUNT_PATH> <DISK_UUID>"
fi

MOUNT_PATH="$1"
DISK_UUID="$2"

function build_content() {
  outout "[Unit]
Description=Mount ${DISK_UUID} in %%MOUNT_PATH%%
After=local-fs.target

[Mount]
What=/dev/disk/by-uuid/${DISK_UUID}
Where=%%MOUNT_PATH%%
Type=ext4
Options=rw,noatime

[Install]
WantedBy=multi-user.target
"
}

build_content
