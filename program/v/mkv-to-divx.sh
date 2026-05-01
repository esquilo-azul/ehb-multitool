#!/bin/sh

find $1 -name '*.mkv' -print0 | xargs -0 -I {} convert-to-divx.sh {}
