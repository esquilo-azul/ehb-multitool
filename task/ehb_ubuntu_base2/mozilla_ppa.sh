set -u
set -e

function firefox_candidate() {
  LANGUAGE=en apt-cache policy firefox | grep 'Candidate:' | awk '{print $2}'
}

function task_condition() {
  if ! firefox_candidate | grep 'build.\+ubuntu'; then
    return 1
  fi
}

function task_fix() {
  sudo add-apt-repository --yes ppa:mozillateam/ppa
  PREFERENCE='Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
'
  sudo_template_file_apply_from_variable "$PREFERENCE" '/etc/apt/preferences.d/firefox.pref'

  UPGRADES='Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";'
  sudo_template_file_apply_from_variable "$UPGRADES" '/etc/apt/apt.conf.d/51unattended-upgrades-firefox'
}
