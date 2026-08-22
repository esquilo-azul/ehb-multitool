DEVICES=(blueman gvfs-backends)
NETWORK=(firefox)
OFFICE=(p7zip-full atril baobab file-roller kolourpaint libreoffice mate-calc thunar-archive-plugin unrar)
SYSTEM=(breeze-icon-theme gnome-system-monitor gparted heif-gdk-pixbuf menulibre openssh-server
  xfce4-netload-plugin xfce4-systemload-plugin xubuntu-core)
TERMINAL=(bash-completion command-not-found nano)

DEBIAN_PACKAGES=("${DEVELOPMENT[@]}" "${DEVICES[@]}" "${IMAGES[@]}" "${MULTIMEDIA[@]}" \
  "${NETWORK[@]}" "${OFFICE[@]}" "${SYSTEM[@]}" "${TERMINAL[@]}")
PACKAGE_ARGUMENTS=(apt "${DEBIAN_PACKAGES[@]}")

function task_condition() {
  package_installed apt "${PACKAGE_ARGUMENTS[@]}"
}

function task_fix() {
  package_assert apt "${PACKAGE_ARGUMENTS[@]}"
}
