-- helpers.lua
-- Global utility functions used across keybinds.lua and other modules.
-- Must be require()'d AFTER variables.lua and BEFORE keybinds.lua.

local vars    = require("config.variables")   -- matches the path used in hyprland.lua
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
