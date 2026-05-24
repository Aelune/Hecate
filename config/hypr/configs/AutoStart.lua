--   _   _ _____ ____    _  _____ _____
--  | | | | ____/ ___|  / \|_   _| ____|     /\_/\
--  | |_| |  _|| |     / _ \ | | |  _|      ( o.o )
--  |  _  | |__| |___ / ___ \| | | |___      > ^ <
--  |_| |_|_____\____/_/   \_\_| |_____|
--
--  🚀 Auto Start CONFIGURATION
--  -----------------------------------------
--  📚 Wiki: https://wiki.hypr.land/Configuring/Basics/Autostart/
--  -----------------------------------------

local vars      = require("variables")
local scriptDir = vars.scriptsDir
local localBin = vars.localBin
local startup = {
    -- Wallpaper and widgets Daemon
    "awww-daemon --format xrgb",

    -- Environment Sync (Wayland vars)
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",

    "hyprctl setcursor Bibata-Modern-Ice 24", -- Sets cursor
    -- Startup Applications
    "nm-applet --indicator", -- Network Manager
    "swaync",                -- Notification daemon
    "blueman-applet",        -- Bluetooth manager
    scriptDir .. "/launch-widgets.sh", -- QuickShell
    "bash -c 'sleep 2 && " .. localBin .. "/hecate startup 2>&1 | tee /tmp/hecate-startup.log'",

    -- Clipboard Manager (cliphist)
    "wl-clip-persist --clipboard regular", -- Enables clipboard
    "wl-paste --type text --watch cliphist store", -- Enables Clipboard for text
    "wl-paste --type image --watch cliphist -max-items=10 store", -- Enable clipboard for images

    -- Lock + Idle Management
    "hypridle" -- Idle detection
}

hl.on("hyprland.start", function()
    for i = 1, #startup do
        hl.exec_cmd(startup[i])
    end
end)
