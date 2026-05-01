#!/bin/bash

source "${BASH_TO_REQUIRE}"

if [ $# -lt 2 ]; then
  >&2 echo "Usage: $0 <OUTPUT> <INPUT1> [INPUTN...]"
  exit 1
fi

OUTPUT=$1
shift
echo "Output: $OUTPUT"
echo "Input: " $@

if [ -e "$OUTPUT" ]; then
  >&2 echo "\"$OUTPUT\" já existe"
  exit 2
fi

function av_error {
  set +e
  grep "$1" /tmp/av_concat_errors
  result=$?
  set -e
  echo $result
}

#set +e
mencoder -oac copy -ovc copy -idx -o "$OUTPUT" "$@" 2> /tmp/av_concat_errors
result=$?
set -e

if [ $result -ne 0 ]; then
  VIDEO_NO_IDENTICAL=$(av_error 'All video files must have identical fps, resolution, and codec for -ovc copy')
  if [ VIDEO_NO_IDENTICA != '0' ]; then
    mencoder -oac copy -ovc x264 -idx -o "$OUTPUT" "$@"
  fi
fi

mkdir -p converted
for f in "$@"; do
  x=$(basename "$f")
  mv "$f" "converted/$OUTPUT""_$x"
done
