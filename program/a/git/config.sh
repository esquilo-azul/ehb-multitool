#!/bin/bash

source "${BASH_TO_REQUIRE}"

git config --global alias.bb 'bisect bad'
git config --global alias.bg 'bisect good'
git config --global alias.br 'bisect run'
git config --global alias.bs 'bisect start'
git config --global alias.ca 'cherry-pick --abort'
git config --global alias.cp 'cherry-pick'
git config --global alias.cc 'cherry-pick --continue'
git config --global alias.co 'checkout'
git config --global alias.cm 'commit --amend'
git config --global alias.ct 'commit'
git config --global alias.cg 'commit --message'
git config --global alias.dc 'diff --cached'
git config --global alias.ft 'fetch --prune --prune-tags --tags'
git config --global alias.fx 'commit --fixup'
git config --global alias.meld 'difftool -t meld -y'
git config --global alias.rc 'rebase --continue'
git config --global alias.ra 'rebase --abort'
git config --global alias.rs 'rebase --skip'
git config --global alias.rh 'reset HEAD'
git config --global alias.rp 'reset HEAD~1'
git config --global alias.rws 'restore --worktree --stage'
git config --global alias.st 'status --untracked-files=all'
git config --global alias.sc 'switch --create'
git config --global alias.sf 'switch --force-create'
git config --global alias.sn 'switch --no-guess'
git config --global alias.lg \
  "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%Creset' --abbrev-commit"
git config --global core.excludesfile "${MYSELF_RESOURCES}/my/git/global_ignore"
"${PROGRAMEIRO_RUNNER}" m/sources/git/config_aliases
