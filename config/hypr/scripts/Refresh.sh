#!/bin/bash
# Scripts for refreshing ags, waybar, swaync, wallust

#  _   _ _____ ____    _  _____ _____
# | | | | ____/ ___|  / \|_   _| ____|     /\_/\
# | |_| |  _|| |     / _ \ | | |  _|      ( o.o )
# |  _  | |__| |___ / ___ \| | | |___      > ^ <
# |_| |_|_____\____/_/   \_\_| |_____|

SCRIPTSDIR="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"

# --- helpers ---
file_exists() {
    [[ -e "$1" ]]
}

# --- kill processes safely ---
_ps=(waybar swaync ags)
for _prs in "${_ps[@]}"; do
    pkill -x "$_prs" 2>/dev/null || true
done

# --- restart waybar ---
sleep 1
# run Waybar silently (suppress dbus warnings, log to cache)
WAYBAR_DISABLE_DBUS=1 waybar >~/.cache/waybar.log 2>&1 &

# --- restart swaync ---
sleep 0.5
swaync > /dev/null 2>&1 &
swaync-client --reload-config >/dev/null 2>&1 || true

# --- optional AGS restart ---
# ags -q && ags >/dev/null 2>&1 &

# --- optional Quickshell restart ---
# pkill -x qs && qs >/dev/null 2>&1 &

# --- relaunch rainbow borders if present ---
sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
    "${UserScripts}/RainbowBorders.sh" &
fi

exit 0
