--  _   _ _____ ____    _  _____ _____
-- | | | | ____/ ___|  / \|_   _| ____|     /\_/\
-- | |_| |  _|| |     / _ \ | | |  _|      ( o.o )
-- |  _  | |__| |___ / ___ \| | | |___      > ^ <
-- |_| |_|_____\____/_/   \_\_| |_____|
--
-- 🚀 Auto Start CONFIGURATION
-- -----------------------------------------
-- 📚 Wiki: https://wiki.hypr.land/Configuring/Binds/
--       bind = MODS, key, dispatcher, params
-- NOTE: This script is dynamically loaded by the Hecate-helper app
-- "#." is used to hide lines by parser and in line "#" are shown in the app as description to that bind
-- "#/" is used to create categories
-- -----------------------------------------

local vars      = require("variables")
local mainMod   = vars.mainMod        -- "SUPER"
local scripts   = vars.scriptsDir .. "/"
local terminal  = vars.terminal
local fileMgr   = vars.fileManager
local browser   = vars.browser

-- helpers.lua
-- Global utility functions used across keybinds.lua and other modules.
-- Must be require()'d AFTER variables.lua and BEFORE keybinds.lua.

local vars    = require("config.variables")
local scripts = vars.scriptsDir

-- ── Core shortcuts ────────────────────────────────────────────

-- Shorthand for hl.dsp.exec_cmd()
function run(cmd, window_rules)
    return hl.dsp.exec_cmd(cmd, window_rules)
end

-- Run a script from scriptsDir by filename (args can be baked into script_name)
function run_script(script_name)
    return hl.dsp.exec_cmd(scripts .. script_name)
end

-- ── Rofi helpers ──────────────────────────────────────────────

-- Wraps a rofi command with toggle behaviour:
-- if the menu is already open the script closes it instead.
function toggle_rofi(cmd)
    return hl.dsp.exec_cmd(scripts .. "toggle_rofi " .. cmd)
end

function toggle_rofi_script(script_name)
    return toggle_rofi(scripts .. "rofi/" .. script_name)
end

-- ── Cursor zoom ───────────────────────────────────────────────
-- Used by mainMod + ALT + mouse_down / mouse_up in keybinds.lua.
-- Reads the current zoom factor via hyprctl, clamps to ≥1, then doubles/halves it.

function zoom_in()
    return run(
        "hyprctl keyword cursor:zoom_factor " ..
        "\"$(hyprctl getoption cursor:zoom_factor | " ..
        "awk 'NR==1 {f=$2; if(f<1){f=1}; print f*2.0}')\"")
end

function zoom_out()
    return run(
        "hyprctl keyword cursor:zoom_factor " ..
        "\"$(hyprctl getoption cursor:zoom_factor | " ..
        "awk 'NR==1 {f=$2; if(f<1){f=1}; print f/2.0}')\"")
end

-- ── Layout-aware binds ────────────────────────────────────────
-- Returns a function that only dispatches the action matching the
-- current workspace layout, avoiding "unknown layout message" warnings.
--
-- Usage:
--   hl.bind(mainMod .. " + J", layout_bind({
--       dwindle = hl.dsp.layout("togglesplit"),
--       master  = hl.dsp.layout("cyclenext"),
--   }))

function layout_bind(bind_table)
    return function()
        local workspace = hl.get_active_special_workspace()
                       or hl.get_active_workspace()

        if not workspace then return end

        local layout = workspace.tiled_layout

        if bind_table[layout] then
            hl.dispatch(bind_table[layout])
        end
    end
end

-- ──────────────────────────────────────────────────────────────
-- #/ Session Control
-- ──────────────────────────────────────────────────────────────
-- hl.bind("CTRL ALT + Delete",   hl.dsp.exit())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))                                   -- Exit Hyprland
hl.bind("CTRL + ALT + L",        run_script("LockScreen.sh"))                       -- Lock Screen
hl.bind(mainMod .. "+ SHIFT + Q", run("wlogout"))                                  -- Logout Menu
hl.bind(mainMod .. "+ ALT + R",   run_script("Refresh.sh"))                        -- Refresh Waybar, swaync, etc.
hl.bind(mainMod .. "+ ALT + L",   run_script("ChangeLayout.sh"))                   -- Toggle Layout (Master/Dwindle)
hl.bind(mainMod .. "+ CTRL + W",  run("waypaper --backend swww"))                  -- Change Wallpaper
hl.bind(mainMod .. "+ ALT + B",   run("pkill -SIGUSR1 waybar"))                    -- Toggle Waybar Visibility
hl.bind(mainMod .. " + Q",       hl.dsp.window.close())                           -- Close Active Window
-- hl.bind("CTRL + tab",            hl.dsp.focus({ cycle = true }))                  -- Cycle Through Applications
hl.bind(mainMod .. " + R",       run("hyprctl reload"))                           -- Reload Hyprland

-- ──────────────────────────────────────────────────────────────
-- #/ Applications
-- ──────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + D",           run_script("drun.sh"))                       -- App Launcher (Rofi)
hl.bind(mainMod .. " + B",           run_script("System-apps.sh browser"))        -- Launch Browser
hl.bind(mainMod .. " + C",           run("code"))                                 -- Launch VSCode
hl.bind(mainMod .. " + E",           run("dolphin"))                              -- Launch Dolphin File Manager
hl.bind(mainMod .. " + Return",      run_script("System-apps.sh term"))           -- Launch Terminal
hl.bind(mainMod .. " + SHIFT + Return",run_script("Dropterminal.sh kitty -e zsh"))  -- Dropdown Terminal
hl.bind(mainMod .. " + H",           run("hyprsettings"))                         -- Hypr Settings

-- Super + Space: Launch or kill Aoiler
hl.bind(mainMod .. " + Space",  run_script("Aoiler.sh"))

-- Super + A: Hide/show Aoiler (without killing)
-- hl.bind(mainMod .. " + A",      hl.dsp.special_workspace({ name = "aoiler", action = "toggle" }))

hl.bind(mainMod .. " + ALT + E",  run("rofi -modi emoji -show emoji -config ~/.config/rofi/config-emoji.rasi")) -- Emoji Picker
hl.bind(mainMod .. " + V",      run_script("ClipManager.sh"))                     -- Clipboard Manager
hl.bind(mainMod .. " + SHIFT + V",run("pavucontrol"))                               -- Volume Control
hl.bind(mainMod .. " + SHIFT + N",run("swaync-client -t -sw"))                      -- Notification Panel

-- ──────────────────────────────────────────────────────────────
-- #/ Screenshots
-- ──────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + Print",        run_script("ScreenShot.sh full"))            -- Fullscreen Screenshot
hl.bind(mainMod .. " + SHIFT + Print",  run_script("ScreenShot.sh window"))          -- Active Window Screenshot
hl.bind(mainMod .. " + SHIFT + S",      run_script("ScreenShot.sh area"))            -- Select Area Screenshot

-- ──────────────────────────────────────────────────────────────
-- #/ Workspaces
-- ──────────────────────────────────────────────────────────────
-- hl.bind(mainMod .. " + tab",         hl.dsp.workspace({ move = 1 }))              -- Next Workspace
-- hl.bind(mainMod .. " + SHIFT + tab",   hl.dsp.workspace({ move = -1 }))             -- Previous Workspace
-- hl.bind(mainMod .. " + mouse_down",  hl.dsp.workspace({ move = 1 }))              -- Next Workspace (Mouse Down)
-- hl.bind(mainMod .. " + mouse_up",    hl.dsp.workspace({ move = -1 }))             -- Previous Workspace (Mouse Up)

-- Switch to workspace 1-6  (code:10 = key 1, code:15 = key 6)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- hl.bind(mainMod .. " + SHIFT + bracketleft",   hl.dsp.move_to_workspace({ move = -1 }))           -- Move Window to Previous Workspace
-- hl.bind(mainMod .. " + SHIFT + bracketright",  hl.dsp.move_to_workspace({ move = 1 }))            -- Move Window to Next Workspace
-- hl.bind(mainMod .. " + CTRL + bracketleft",    hl.dsp.move_to_workspace({ move = -1, silent = true })) -- Move Silently to Prev Workspace
-- hl.bind(mainMod .. " + CTRL + bracketright",   hl.dsp.move_to_workspace({ move = 1,  silent = true })) -- Move Silently to Next Workspace

hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special("magic"))     -- Toggle Special Workspace

-- ──────────────────────────────────────────────────────────────
-- #/ Window Management – Focus
-- ──────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + left",   hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",  hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",   hl.dsp.focus({ direction = "down" }))

-- Swap windows
hl.bind(mainMod .. " + ALT + left",   hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right",  hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up",     hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down",   hl.dsp.window.swap({ direction = "down" }))

-- Move floating window
hl.bind(mainMod .. " + CTRL + left",   hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right",  hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",   hl.dsp.window.move({ direction = "down" }))

-- Resize (binde – repeatable)
hl.bind(mainMod .. " + SHIFT + left",   hl.dsp.window.resize({ x = -50, y = 0   ,relative = true }))
hl.bind(mainMod .. " + SHIFT + right",  hl.dsp.window.resize({ x =  50, y = 0   ,relative = true }))
hl.bind(mainMod .. " + SHIFT + up",     hl.dsp.window.resize({ x = 0,   y = -50 ,relative = true }))
hl.bind(mainMod .. " + SHIFT + down",   hl.dsp.window.resize({ x = 0,   y =  50 ,relative = true }))

-- Floating / Fullscreen
hl.bind(mainMod .. " + SHIFT + Space",  hl.dsp.window.float({ action = "toggle" }))           -- Toggle Floating
-- hl.bind(mainMod .. " + ALT + Space",    hl.dsp.workspace_opt({ allfloat = true }))             -- Toggle All Float
hl.bind(mainMod .. " + F",            hl.dsp.window.fullscreen())                            -- Toggle Fullscreen
hl.bind(mainMod .. " + CTRL + F",       hl.dsp.window.fullscreen({ mode = 1 }))               -- Fullscreen Mode 1

-- ──────────────────────────────────────────────────────────────
-- #/ Groups & Layouts
-- ──────────────────────────────────────────────────────────────
-- hl.bind(mainMod .. " + G",            hl.dsp.window.group({ action = "toggle" }))            -- Toggle Group
-- hl.bind(mainMod .. " + CTRL + tab",     hl.dsp.window.group({ cycle = true }))                 -- Cycle Group Window
hl.bind(mainMod .. " + CTRL + D",       hl.dsp.layout("removemaster"))                         -- Remove Master
hl.bind(mainMod .. " + I",            hl.dsp.layout("addmaster"))                            -- Add Master
hl.bind(mainMod .. " + J",            hl.dsp.layout("cyclenext"))                            -- Cycle Next Window
hl.bind(mainMod .. " + K",            hl.dsp.layout("cycleprev"))                            -- Cycle Prev Window
hl.bind(mainMod .. " + CTRL + Return",  hl.dsp.layout("swapwithmaster"))                       -- Swap with Master
hl.bind(mainMod .. " + P",            hl.dsp.window.pseudo())                                -- Toggle Pseudo Tiling
hl.bind(mainMod .. " + M",            run("hyprctl dispatch splitratio 0.3"))                -- Set Split Ratio 0.3

-- ──────────────────────────────────────────────────────────────
-- #/ Mouse
-- ──────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + mouse:272",    hl.dsp.window.drag())                             -- Drag to Move
hl.bind(mainMod .. " + mouse:273",    hl.dsp.window.resize())                           -- Drag to Resize
hl.bind(mainMod .. " + ALT + mouse_down", zoom_in())                                           -- Zoom In Cursor
hl.bind(mainMod .. " + ALT + mouse_up",  zoom_out())                                           -- Zoom Out Cursor

-- ──────────────────────────────────────────────────────────────
-- #/ Media  (bindel / bindl equivalents – device-level, repeat where needed)
-- ──────────────────────────────────────────────────────────────
hl.bind("xf86audioraisevolume",  run_script("Volume.sh --inc"),   { repeating = true })         -- Volume Up
hl.bind("xf86audiolowervolume",  run_script("Volume.sh --dec"),   { repeating = true })         -- Volume Down
hl.bind("xf86AudioMicMute",      run_script("Volume.sh --toggle-mic"))                       -- Toggle Mic
hl.bind("xf86audiomute",         run_script("Volume.sh --toggle"))                           -- Toggle Volume Mute
hl.bind("code:172",             run("playerctl play-pause"),                      { locked = true }) -- XF86AudioPlayPause
-- hl.bind("xf86AudioPlayPause",    run_script("MediaContol.sh --pause"))                       -- Play/Pause Media
hl.bind("xf86AudioPause",        run_script("MediaContol.sh --pause"))                       -- Pause Media
hl.bind("xf86AudioPlay",         run_script("MediaContol.sh --pause"))                       -- Play Media
hl.bind("xf86AudioNext",         run_script("MediaContol.sh --nxt"))                         -- Next Track
hl.bind("xf86AudioPrev",         run_script("MediaContol.sh --prv"))                         -- Previous Track
hl.bind("xf86audiostop",         run_script("MediaContol.sh --stop"))                        -- Stop Media
hl.bind("xf86Sleep",             run("systemctl suspend"))                                   -- Sleep System
hl.bind("xf86Rfkill",            run_script("AirplaneMode.sh"))                              -- Toggle Airplane Mode
