#!/bin/bash

source "${BASH_TO_REQUIRE}"

git log -1 '--format=%s' | xsel -b
git reset HEAD~1
