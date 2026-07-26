#!/bin/bash

source "${BASH_TO_REQUIRE}"

WIN="$1"
INTERVAL="${2:-0.6}"
DURATION="${3:-10}"

if [ -z "$WIN" ]; then
  echo "Uso: $0 '<título da janela>' [intervalo_s] [duração_s]" >&2
  exit 1
fi

END=$((SECONDS + DURATION))
while [ "$SECONDS" -lt "$END" ]; do
    wmctrl -r "$WIN" -b add,demands_attention
    sleep "$INTERVAL"
    wmctrl -r "$WIN" -b remove,demands_attention
    sleep "$INTERVAL"
done

# garante que termina "aceso" caso queira manter o destaque
wmctrl -r "$WIN" -b add,demands_attention
