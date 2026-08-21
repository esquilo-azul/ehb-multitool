# Referência https://packagecloud.io/filips/FirefoxPWA

DEBIAN_PACKAGES=(firefoxpwa)

function task_condition() {
  deb_installed "${DEBIAN_PACKAGES[@]}"
}

function task_fix() {
  package_assert apt debian-archive-keyring curl gpg apt-transport-https
  curl -fsSL https://packagecloud.io/filips/FirefoxPWA/gpgkey | gpg --dearmor | \
    sudo tee /usr/share/keyrings/firefoxpwa-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/firefoxpwa-keyring.gpg] https://packagecloud.io/filips/FirefoxPWA/any any main" | \
    sudo tee /etc/apt/sources.list.d/firefoxpwa.list > /dev/null
  package_assert apt "${DEBIAN_PACKAGES[@]}"
}
