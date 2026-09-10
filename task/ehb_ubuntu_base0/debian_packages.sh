DEBIAN_PACKAGES=(
  gimp \
  gitk \
  gpick \
  inkscape \
  parcellite \
  pwgen \
  remmina \
  xsel \
)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_condition() {
  package_installed apt "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert apt "${PACKAGE_ARGUMENTS[@]}"
}
