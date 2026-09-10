#!/bin/bash

source "${BASH_TO_REQUIRE}"

PACKAGE_ARGS=(apt pgadmin4-desktop)

if package_installed "${PACKAGE_ARGS[@]}"; then
  exit
fi

curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | \
  sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

TARGET_CONTENT="deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main\n"
TARGET_FILE='/etc/apt/sources.list.d/pgadmin4.list'
sudo_template_file_apply_from_variable "$TARGET_CONTENT" "$TARGET_FILE"
package_assert apt "${PACKAGE_ARGS[@]}"
