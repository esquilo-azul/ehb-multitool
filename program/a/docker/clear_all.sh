#!/bin/bash

source "${BASH_TO_REQUIRE}"

docker system prune --all --volumes --force
