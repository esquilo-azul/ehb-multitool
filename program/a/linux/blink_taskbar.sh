#!/bin/bash

source "${BASH_TO_REQUIRE}"

WIN="${1:-}"
INTERVAL="${2:-0.6}"
DURATION="${3:-10}"

if [ -z "$WIN" ]; then
  echo "Uso: $0 '<título da janela>|<id da janela>' [intervalo_s] [duração_s]"
  echo
  echo "Janelas disponíveis (id  título):"
  wmctrl -l | awk '{ id=$1; $1=$2=$3=""; sub(/^ +/, ""); printf "  %s  %s\n", id, $0 }'
  exit 0
fi

WMCTRL_ID_OPT=()
case "$WIN" in
  0x*|[0-9]*)
    WMCTRL_ID_OPT=(-i)
    ;;
esac

END=$((SECONDS + DURATION))
while [ "$SECONDS" -lt "$END" ]; do
    wmctrl "${WMCTRL_ID_OPT[@]}" -r "$WIN" -b add,demands_attention
    sleep "$INTERVAL"
    wmctrl "${WMCTRL_ID_OPT[@]}" -r "$WIN" -b remove,demands_attention
    sleep "$INTERVAL"
done

# garante que termina "aceso" caso queira manter o destaque
wmctrl "${WMCTRL_ID_OPT[@]}" -r "$WIN" -b add,demands_attention
