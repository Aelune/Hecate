-- windowrules.lua
-- Hyprland v0.55+ Lua window/layer/workspace rules
-- All rules use hl.window_rule() / hl.layer_rule()
-- Rules are evaluated TOP-TO-BOTTOM; order matters.

-- ══════════════════════════════════════════════════════════════
-- §1  OPACITY / NATIVE TRANSPARENCY
--     These apps either use native transparency or must be
--     forced opaque so compositing artefacts don't show.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    match   = { class = "foot|equibop|org\\.quickshell|imv|swappy" },
    opacity = "1.0 override 1.0 override",   -- active / inactive both forced opaque
})

-- ══════════════════════════════════════════════════════════════
-- §2  GLOBAL FLOAT CENTERING
--     Center every floating non-xwayland window by default.
--     Specific rules below can still override size/position.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    match  = { float = true, xwayland = false },
    center = true,
})

-- ══════════════════════════════════════════════════════════════
-- §3  SIMPLE FLOAT RULES
--     Windows that should always open floating.
-- ══════════════════════════════════════════════════════════════

local simple_float_classes = {
    "guifetch",
    "yad",
    "org\\.gnome\\.FileRoller",
    "file-roller",
    "blueman-manager",
    "com\\.github\\.GradienceTeam\\.Gradience",
    "feh",
    "imv",
    "system-config-printer",
    "org\\.quickshell",
    "nm-connection-editor",
    "xdg-desktop-portal-gtk",
    "hyprsettings",
    "Hera",
    "nwg-look",
}

for _, cls in ipairs(simple_float_classes) do
    hl.window_rule({ match = { class = cls }, float = true })
end

-- Float by title
local simple_float_titles = {
    "Library",
    "nmtui",
    ".*Properties",
    "Export Image as PNG",
    "GIMP Crash Debug",
    "Save As",
    "System Monitor",
}

for _, ttl in ipairs(simple_float_titles) do
    hl.window_rule({ match = { title = ttl }, float = true })
end

-- File/folder dialogs (matches common browser/GTK picker titles)
hl.window_rule({
    match = { title = "(Select|Open)( a)? (File|Folder)(s)?" },
    float = true,
})
hl.window_rule({
    match = { title = "File (Operation|Upload)( Progress)?" },
    float = true,
})
hl.window_rule({
    match = { class = "^firefox$", title = "^Opening .*$" },
    float = true,
})

-- ══════════════════════════════════════════════════════════════
-- §4  FLOAT + SIZE + CENTER  (apps that need a consistent size)
-- ══════════════════════════════════════════════════════════════

-- nmtui in foot terminal
hl.window_rule({
    match  = { class = "foot", title = "nmtui" },
    float  = true,
    size   = "monitor_w*0.6 monitor_h*0.7",
    center = true,
})

-- GNOME Settings
hl.window_rule({
    match  = { class = "org\\.gnome\\.Settings" },
    float  = true,
    size   = "monitor_w*0.7 monitor_h*0.8",
    center = true,
})

-- PulseAudio / yad icon browser / waypaper
hl.window_rule({
    match  = { class = "org\\.pulseaudio\\.pavucontrol|yad-icon-browser|waypaper" },
    float  = true,
    size   = "monitor_w*0.8 monitor_h*0.7",
    center = true,
})

-- nwg-look theming tool
hl.window_rule({
    match  = { class = "nwg-look" },
    float  = true,
    size   = "monitor_w*0.5 monitor_h*0.6",
    center = true,
})

-- OBS on a special workspace (scratchpad style)
hl.window_rule({
    match     = { class = "com\\.obsproject\\.Studio" },
    float     = true,
    workspace = "special silent",
    size      = "monitor_w*0.7 monitor_h*0.8",
    center    = true,
})

-- dotfiles floating terminal
hl.window_rule({
    name   = "dotfiles-float",
    match  = { class = "^dotfiles-floating$" },
    float  = true,
    size   = "900 600",
    center = true,
})

-- ══════════════════════════════════════════════════════════════
-- §5  SPECIAL WINDOW BEHAVIORS
-- ══════════════════════════════════════════════════════════════

-- Picture-in-Picture: float, pin, push to bottom-right corner
hl.window_rule({
    name  = "pip",
    match = { title = "^Picture-in-Picture$" },
    float = true,
    pin   = true,
    -- sits 69.5% across and 4% down from top-left of monitor
    move  = "monitor_w*0.695 monitor_h*0.04",
})

-- Update/splash windows: borderless, centered, no chrome
hl.window_rule({
    name        = "update-window",
    match       = { title = "^update-window$" },
    center      = true,
    border_size = 0,
})

-- Firefox browser window: remove shadow/border (clean look)
hl.window_rule({
    name        = "firefox-tiled",
    match       = { class = "^firefox$", float = false },
    border_size = 0,
    -- no_shadow removed in 0.55; shadow is controlled via hl.config decoration
})

-- Shotcut "Projects Folder" dialog
hl.window_rule({
    name          = "shotcut-projects",
    match         = { initial_class = "^shotcut$", initial_title = "^Projects Folder$" },
    float         = true,
})

-- ══════════════════════════════════════════════════════════════
-- §6  SYSTEM WIDGETS  (Pulse, Hecate-Settings)
--     Borderless, no blur – they manage their own appearance.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    name        = "pulse-widget",
    match       = { class = "^Pulse$" },
    float       = true,
    border_size = 0,
    no_blur     = true,
})

hl.window_rule({
    name        = "hecate-settings",
    match       = { class = "^Hecate-Settings$" },
    float       = true,
    border_size = 0,
    no_blur     = true,
})

-- ══════════════════════════════════════════════════════════════
-- §7  AOILER SCRATCHPAD PANEL
--     Slim side panel: 20% wide, full height, anchored left.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    name      = "aoiler-panel",
    match     = { class = "Aoiler" },
    workspace = "special:aoiler",
    float     = true,
    size      = "monitor_w*0.2 monitor_h*0.95",
    move      = "10 40",
})

-- ══════════════════════════════════════════════════════════════
-- §8  IDLE INHIBIT
--     Don't let the screen lock while media is playing/fullscreen.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    match        = { fullscreen = true },
    idle_inhibit = "fullscreen",
})

hl.window_rule({
    match        = { class = "mpv|vlc|celluloid|totem" },
    idle_inhibit = "focus",
    content      = "video",   -- hint compositor about content type
})

-- ══════════════════════════════════════════════════════════════
-- §9  GAMING / TEARING
--     Allow immediate/tearing for games to reduce latency.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    match     = { class = "steam_app.*|gamescope|lutris|heroic" },
    immediate = true,
    content   = "game",
})

-- ══════════════════════════════════════════════════════════════
-- §10 SUPPRESS MAXIMIZE REQUESTS
--     Prevent apps from forcing themselves fullscreen/maximized.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    match          = { class = "^firefox$|^chromium$|^brave-browser$" },
    suppress_event = "maximize",
})

-- ══════════════════════════════════════════════════════════════
-- §11 PERSISTENT SIZE
--     Remember last size for these floating apps between opens.
-- ══════════════════════════════════════════════════════════════

hl.window_rule({
    match          = { class = "org\\.pulseaudio\\.pavucontrol|nwg-look|blueman-manager" },
    persistent_size = true,
})

-- ══════════════════════════════════════════════════════════════
-- §12 WORKSPACE RULES
--     Gaps for single-window and floating-only workspaces.
-- ══════════════════════════════════════════════════════════════

-- hl.workspace_rule({ workspace = "w[tv1]s[false]", gapsout = 10 })
-- hl.workspace_rule({ workspace = "f[1]s[false]",   gapsout = 10 })

-- ══════════════════════════════════════════════════════════════
-- §13 LAYER RULES
-- ══════════════════════════════════════════════════════════════

-- Fade animations for transient overlays
hl.layer_rule({ match = { namespace = "hyprpicker"    }, animation = "fade" })  -- colour picker
hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "fade" })  -- wlogout
hl.layer_rule({ match = { namespace = "selection"     }, animation = "fade" })  -- slurp
hl.layer_rule({ match = { namespace = "wayfreeze"     }, animation = "fade" })  -- screen freeze

-- App launcher (rofi / fuzzel): pop-in + blur
hl.layer_rule({ match = { namespace = "launcher" }, animation = "popin 80%" })
hl.layer_rule({ match = { namespace = "launcher" }, blur = true })

-- Waybar: blur for a frosted-glass effect
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })

-- Notification daemon (swaync)
hl.layer_rule({ match = { namespace = "swaync-.*" }, blur = true, animation = "slide" })
