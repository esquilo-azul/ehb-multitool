TARGET_DIRECTORY='/usr/share/doc/git/contrib/credential/libsecret'
TARGET_FILE="${TARGET_DIRECTORY}/git-credential-libsecret"
CONFIG_NAME='credential.helper'

function git_config() {
  git config --global "$@"
}

function git_config_read() {
  git_config --get "${CONFIG_NAME}"
}

function git_config_write() {
  git_config "${CONFIG_NAME}" "$1"
}

function task_condition() {
  [[ $(git_config_read) == "${TARGET_FILE}" ]]
}

function task_fix() {
  package_assert apt libsecret-1-0 libsecret-1-dev

  if [[ ! -f "${TARGET_FILE}" ]]; then
    sudo make --directory "${TARGET_DIRECTORY}"
  fi

  if [[ "$(git_config_read)" != "${TARGET_FILE}" ]]; then
    git_config_write "${TARGET_FILE}"
  fi
}
