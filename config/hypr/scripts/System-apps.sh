#!/usr/bin/env sh
set -e

CONFIG="$HOME/.config/hecate/hecate.toml"
SCRIPT="$HOME/.config/hecate/scripts/install-updates.sh"

# Extract terminal, browser preference safely
terminal=$(awk -F'=' '
  /^\[preferences\]/ { in_pref=1; next }
  /^\[/ { in_pref=0 }
  in_pref && $1 ~ /term/ {
    gsub(/"/, "", $2)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
    print $2
    exit
  }
' "$CONFIG")

browser=$(awk -F'=' '
  /^\[preferences\]/ { in_pref=1; next }
  /^\[/ { in_pref=0 }
  in_pref && $1 ~ /browser/ {
    gsub(/"/, "", $2)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
    print $2
    exit
  }
' "$CONFIG")
if [ -z "$terminal" ]; then
  echo "Error: no terminal found in $CONFIG"
  exit 1
fi

# Choose correct command based on terminal
case "$1" in
term)
  echo "$terminal"
  ;;
  browser)
  echo "$browser"
  ;;
*)
  echo "huh??"
  exit 1
  ;;
esac
