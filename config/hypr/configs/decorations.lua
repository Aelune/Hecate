--   _   _ _____ ____    _  _____ _____
--  | | | | ____/ ___|  / \|_   _| ____|     /\_/\
--  | |_| |  _|| |     / _ \ | | |  _|      ( o.o )
--  |  _  | |__| |___ / ___ \| | | |___      > ^ <
--  |_| |_|_____\____/_/   \_\_| |_____|
--
--  🎀 Decoration Configuration
--  -------------------------------------------------
--  📚 Official Wiki:
--    Window Rules -> https://wiki.hypr.land/Configuring/Variables/
--    dwindle -> https://wiki.hypr.land/Configuring/Dwindle-Layout/
--    Master -> https://wiki.hypr.land/Configuring/Master-Layout/
-- 💡 Quick Tips:
--    1. Use `rgba(RRGGBBAA)` for colors — last two digits are transparency.
--    2. Borders & background colors can be animated (see animations.conf).
--
--   Syntax ->  windowrule=RULE,PARAMETERS
--  -------------------------------------------------


-- #/  Borders & Styling
-- decoration.lua
-- Hyprland v0.55+ — general, decoration, layouts, render, binds, animations
-- Design goal: clean & modern with minimal GPU overhead.
-- Your accent palette: warm rose  #F7DCDE (active) / muted mauve #A58A8D (inactive)

-- #/ 1  GENERAL  (borders, gaps, layout)

hl.config({
    general = {
        -- Active border: rose with a subtle gradient shimmer
        -- Uses two stops so the border has gentle depth without costing more than a solid color
        -- col_active_border   = "rgba(F7DCDEcc) rgba(C9A0A4cc) 45deg",
        -- col_inactive_border = "rgba(A58A8D28)",   -- barely-there inactive border

        gaps_in  = 3,
        gaps_out = 8,

        border_size          = 2,
        resize_on_border     = true,
        extend_border_grab_area = 8,   -- wider invisible grab margin = easier resizing

        layout = "dwindle",

        -- Window snapping (0.45+): makes floating windows snap to each other
        snap = {
            enabled         = true,
            window_gap      = 10,
            monitor_gap     = 10,
        },
    },
})


-- #/ 2  DECORATION  (rounding, opacity, blur, shadow, dim)
hl.config({
    decoration = {
        --  Rounding
        rounding       = 10,       -- 10 px corners: modern but not distracting
        rounding_power = 2.6,      -- between circle (2.0) and squircle (4.0) — iOS-ish

        --  Opacity
        -- Slight inactive dim shifts visual focus to the active window
        -- without the cost of heavy blur on every window.
        active_opacity   = 1.0,
        inactive_opacity = 0.94,
        fullscreen_opacity = 1.0,

        -- Inactive dimming
        dim_inactive  = true,
        dim_strength  = 0.06,      -- very subtle (0–1); just enough to read focus at a glance
        dim_special   = 0.25,      -- darken tiled background when special WS opens
        dim_modal     = true,      -- darken parent when a modal is shown

        -- Blur
        -- Power budget: size=6, passes=2 is the sweet spot.
        -- passes=1 looks grainy; passes=3+ costs 3× GPU vs passes=2.
        -- new_optimizations caches the blur texture and skips redraws when
        -- nothing behind the window has changed — a big win on AMD.
        blur = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            new_optimizations = true,   -- must-have for performance
            ignore_opacity    = true,
            xray              = false,  -- true lets floats see through tiles; disable to avoid cost

            -- Visual polish: slight noise breaks up banding on AMD
            noise      = 0.012,
            contrast   = 0.92,
            brightness = 0.85,
            vibrancy   = 0.18,          -- lifts muted colours behind glass
            vibrancy_darkness = 0.0,

            special = false,            -- blurring special WS is expensive; keep off
            popups  = true,             -- right-click menus look glassy (cheap, single layer)
            popups_ignorealpha = 0.3,
        },

        -- Shadow
        -- Soft, close shadow: depth cue without eating GPU on every frame.
        -- Inactive windows get a nearly invisible shadow — they visually recede.
        shadow = {
            enabled       = true,
            range         = 14,           -- how far the shadow spreads
            render_power  = 2,            -- softer falloff (1–4; lower = softer, more GPU)
            sharp         = false,
            -- ignore_window = true,         -- only render shadow outside the window
            color         = "rgba(0d0d0dcc)",          -- near-black, 80 % opacity
            color_inactive= "rgba(0d0d0d44)",          -- almost invisible for inactive
            offset        = "0 4",        -- slight downward offset = natural light from above
            scale         = 1.0,
        },
    },
})

-- #/ 3  LAYOUTS
hl.config({
    dwindle = {
        preserve_split       = true,   -- keeps your split direction on reload
        special_scale_factor = 0.82,   -- special WS windows don't fill 100 %
        smart_split          = false,  -- enabling this fights with preserve_split
        -- pseudotile removed in 0.55 as a global; use window rule `pseudo` instead
    },

    master = {
        new_status = "master",
        new_on_top = true,
        mfact      = 0.50,
    },
})

-- #/ 4  RENDER

hl.config({
    render = {
        -- direct_scanout bypasses the compositor on fullscreen windows.
        -- Great for games/video; safe to enable — Hyprland falls back gracefully.
        direct_scanout = true,

        -- explicit_sync=2 (auto) lets the driver decide; best for AMD with newer Mesa
        -- explicit_sync  = 2,
    },
})

-- #/ 5  XWAYLAND

hl.config({
    xwayland = {
        enabled           = true,
        force_zero_scaling = true,  -- prevents blurry XWayland apps on HiDPI
    },
})

-- #/ 6  BINDS

hl.config({
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
        scroll_event_delay       = 280,   -- ms debounce for scroll-to-switch-workspace
    },
})

-- #/ 7  MISCELLANEOUS

hl.config({
    misc = {
        -- Disable the random anime girl / Hyprland logo wallpaper
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,

        -- Slightly delay focus-follows-mouse to avoid accidental switches
        -- when the cursor crosses a window during normal movement.
        mouse_move_focuses_monitor = true,

        -- Focus the window under the cursor after a workspace switch
        -- (avoids needing an extra click to start typing).
        focus_on_activate = false,

        -- Keep the last focused window highlighted after all windows close
        -- no_direct_scanout = false,   -- we set direct_scanout above; this is the legacy toggle
    },
})
