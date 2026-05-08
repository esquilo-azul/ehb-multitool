git_commit_id() {
  git rev-parse --short HEAD
}

git_current_revision() {
  git rev-parse --abbrev-ref HEAD
}

git_status() {
  local RESULT=''
  local COMMANDS=(git_current_revision git_commit_id git_worktree_dirty)
  for COMMAND in "${COMMANDS[@]}"; do
    var_set_by COMMAND_VALUE "${COMMAND}" 2> /dev/null
    if [[ -n "${COMMAND_VALUE}" ]]; then
      if [[ -n "$RESULT" ]]; then
        RESULT="${RESULT}, "
      fi
      RESULT="${RESULT}${COMMAND_VALUE}"
    fi
  done

  if [[ -n "$RESULT" ]]; then
    outout " (${RESULT})"
  fi
}

git_worktree_dirty() {
  if [[ -n "$(git status --porcelain=v2)" ]]; then
    outout '*'
  fi
}

pwd_basename() {
  basename "${PWD}"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if var_present_r force_color_prompt; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

NA='\[\033'
NZ='\]'
TA=']0;'
TZ='\a'

LIGHT_BLUE='[01;34m'
LIGHT_GREEN='[01;32m'
RED="${NA}[91m${NZ}"
NC='[00m'

COLOUR_END="${NA}${NC}${NZ}"
GIT_REV_COLOR="$RED"
USER_HOST_COLOR="${NA}${LIGHT_GREEN}${NZ}"
CURR_DIR_COLOR="${NA}${LIGHT_BLUE}${NZ}"

TITLE_START="${NA}${TA}"
TITLE_END="${TZ}${NZ}"

DEBIAN="${debian_chroot:+($debian_chroot)}"
USER_HOST='\u@\h'
USER_HOST_PWD="${USER_HOST}: \w"
TITLE_SET="${TITLE_START}\$(pwd_basename)${TITLE_END}"

if [ "$color_prompt" = yes ]; then
  GIT_REV="${GIT_REV_COLOR}\$(git_status)${COLOUR_END}"
  USER_HOST2="${DEBIAN}${USER_HOST_COLOR}${USER_HOST}${COLOUR_END}"
  CURR_DIR="${CURR_DIR_COLOR}\w${COLOUR_END}"
  export PS1="${TITLE_SET}${USER_HOST2}:${CURR_DIR}${GIT_REV}\$ "
else
  export PS1='${DEBIAN}${USER_HOST}:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    export PS1="${TITLE_SET}$PS1"
    ;;
  *)
    ;;
esac
