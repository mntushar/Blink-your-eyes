#!/usr/bin/env bash
set -euo pipefail

# -------- child code: runs INSIDE the new terminal --------
child_script='
set -euo pipefail

center_print_colored() {
  local text="$1" color="$2"
  local cols len leftPad spaces
  cols=$(tput cols 2>/dev/null || echo 80)
  len=${#text}
  leftPad=$(( (cols - len) / 2 )); (( leftPad < 0 )) && leftPad=0
  spaces=$(printf "%*s" "$leftPad" "")
  echo -e "${spaces}\e[${color}m${text}\e[0m"
}

tput civis 2>/dev/null || true
trap "tput cnorm 2>/dev/null || true" EXIT INT TERM

for sec in $(seq 20 -1 1); do
  clear
  lines=$(tput lines 2>/dev/null || echo 24)
  topPad=$(( (lines / 2) - 2 )); (( topPad < 0 )) && topPad=0
  for ((i=0; i<topPad; i++)); do echo; done

  center_print_colored "Blink your eyes." "1;33"
  echo
  center_print_colored "Closing in ${sec} seconds..." 33
  sleep 1
done

# child ends -> terminal can auto-close (depending on settings)
exit 0
'

# -------- parent loop: opens new terminal each cycle --------
trap 'exit' INT TERM

while true; do
  gnome-terminal -- bash -lc "$child_script"
  sleep 60   # 20 minutes
done

