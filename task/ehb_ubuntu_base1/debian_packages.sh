DEBIAN_PACKAGES=( \
  clementine \
  fdupes \
  gnome-disk-utility \
  kate \
  kde-spectacle \
  mcomix \
  plocate \
  qml-module-qtquick-shapes \ # Dependência de "kde-spectacle"
  smplayer \
)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_condition() {
  package_installed apt "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert apt "${PACKAGE_ARGUMENTS[@]}"
}
