DEBIAN_PACKAGES=(
  gimp \
  gitk \
  gpick \
  img2pdf \
  inkscape \
  parcellite \
  pwgen \
  remmina \
  xsel \
)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_condition() {
  package_installed "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert "${PACKAGE_ARGUMENTS[@]}"
}
