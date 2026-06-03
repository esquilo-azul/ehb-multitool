#!/bin/bash

for file in "$@"; do
  if [ -f "$file" ]; then
    letra=$(echo $file | grep -Eio '^[a-z]')
    echo "$file -> $letra"
    mkdir -p "$letra"
    mv "$file" "$letra"
  fi
done
