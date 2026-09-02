#!/bin/bash

source "${BASH_TO_REQUIRE}"

fdupes --recurse --noprompt --order=name "$@"
