DEBIAN_PACKAGES=( \
  build-essential \
  libsdl2-dev \
  libgl1-mesa-dev \
  libopenal-dev \
  libgmp-dev \
  libfontconfig1-dev \
)
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_condition() {
  package_installed apt "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert apt "${PACKAGE_ARGUMENTS[@]}"
}
