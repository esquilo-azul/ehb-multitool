#!/bin/bash

source "${BASH_TO_REQUIRE}"

"${PROGRAMEIRO_RUNNER}" o/ehb/erd/carro/lyrics_book
"${PROGRAMEIRO_RUNNER}" o/ehb/erd/carro/upload -vry
"${PROGRAMEIRO_RUNNER}" o/ehb/erd/carro/sort
