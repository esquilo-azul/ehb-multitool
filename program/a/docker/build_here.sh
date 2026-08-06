#!/bin/bash

DIR=$(readlink -f .)
NAME=$(basename "$DIR")
echo "NAME: $NAME"
docker build -t "$NAME" "$DIR"
