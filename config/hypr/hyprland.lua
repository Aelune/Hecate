-- hyprland.lua
-- Entry point. Load order matters:
--   1. variables  — defines mainMod, terminal, paths, etc.
--   2. helpers    — defines run(), run_script(), zoom_in/out(), layout_bind()
--   3. ENVariables — hl.env() calls (must fire before the display server inits)
--   4. monitors   — monitor layout (needed before workspaces are created)
--   5. decorations — hl.config() for general/decoration/animations/render/binds
--   6. WindowRules — hl.window_rule() / hl.layer_rule()
--   7. keybinds   — hl.bind() (depends on helpers + variables)
--   8. AutoStart  — exec-once equivalents (last, so the DE is fully configured first)
local hypr = os.getenv("HOME") .. "/.config/hypr/"
package.path = hypr .. "configs/?.lua;" .. package.path
require("configs.variables")
require("configs.helpers")
require("configs.ENVariables")
require("configs.monitors")
require("configs.decorations")
require("configs.WindowRules")
require("configs.keybinds")
require("configs.AutoStart")
