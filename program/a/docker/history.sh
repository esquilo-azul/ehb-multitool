#!/bin/bash

source "${BASH_TO_REQUIRE}"

docker history --no-trunc --format "{{.CreatedBy}}" "$1" | sed -n '1!G;h;$p'
