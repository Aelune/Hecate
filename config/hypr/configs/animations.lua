--   _   _ _____ ____    _  _____ _____
--  | | | | ____/ ___|  / \|_   _| ____|     /\_/\
--  | |_| |  _|| |     / _ \ | | |  _|      ( o.o )
--  |  _  | |__| |___ / ___ \| | | |___      > ^ <
--  |_| |_|_____\____/_/   \_\_| |_____|
--
--  🚀 ANIMATIONS CONFIGURATION
--  -----------------------------------------
--  📚 Wiki: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
--           Usage animation = NAME, ONOFF, SPEED, CURVE [,STYLE]
--  💡 Quick Tips:
--     - Control animation speed, curves, and styles.
--     - Set `animations:enabled = true` to activate.
--     - Use consistent easing for smooth UX.
--  -----------------------------------------

hl.animation({ leaf = "workspaces", enabled = true, speed = 8, bezier = "my_epic_bezier" })
hl.curve( "wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve( "winIn", { type = "bezier", points = { {0.1, 1.2}, {0.1, 1.1} } })
hl.curve( "winOut", { type = "bezier", points = { {0.5, -0.3}, {0, 1.05} } })
hl.curve( "liner", { type = "bezier", points = { {1, 1}, {1, 1} } })
-- Material Design (MD3) style curves
hl.curve("md3_standard", {type = "bezier", points = { {0.2, 0}, {0, 1} } })
hl.curve("md3_decel", {type = "bezier", points = { {0.05, 0.7}, {0.1, 1} } })
hl.curve("md3_accel", {type = "bezier", points = { {0.3, 0}, {0.8, 0.15} } })
hl.curve("md2", {type = "bezier", points = { {0.4, 0}, {0.2, 1} } })

hl.curve("windMove",   { type = "bezier", points = { {0.83, 0.00}, {0.17, 1.00} } })

hl.curve("easy",       { type = "spring", mass = 0.6, stiffness = 70.26, dampening = 15.8 })

hl.animation({ leaf = "borderangle",      enabled = false, })
hl.animation({ leaf = "windows",          enabled = true,  speed = 3.0,  spring = "easy",         style = "popin 60%" })
hl.animation({ leaf = "windowsIn",        enabled = true,  speed = 2.0,  spring = "easy",         style = "popin 10%" })
hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 2.0,  bezier = "menu_decel",   style = "popin 90%" })

hl.animation({ leaf = "layersIn",         enabled = true,  speed = 2.4,  bezier = "menu_decel",   style = "slide" })
hl.animation({ leaf = "layersOut",        enabled = true,  speed = 1.5,  bezier = "menu_accel",   style = "slide" })
hl.animation({ leaf = "fade",             enabled = true,  speed = 3.0,  bezier = "md3_decel"  })
hl.animation({ leaf = "fadeLayersIn",     enabled = true,  speed = 2.0,  bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true,  speed = 4.5,  bezier = "menu_accel" })

hl.animation({ leaf = "workspaces",       enabled = true,  speed = 4.0,  bezier = "windMove",     style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true,  speed = 3.0,  bezier = "md3_decel",    style = "slidefadevert 15%" })



-- Windows open: pop-in with spring (snappy, brief)
hl.animation("windowsIn",  { enabled = true, speed = 3.5, curve = "snap",     style = "popin 70%" })
-- Windows close: slide out fast (you don't wait for dead windows)
hl.animation("windowsOut", { enabled = true, speed = 2.0, curve = "gentleIn", style = "popin 90%" })
-- Windows move/resize: smooth but quick
hl.animation("windowsMove",{ enabled = true, speed = 3.0, curve = "easeOut"  })

-- Fade for layer surfaces (bars, notifications)
hl.animation("fadeIn",     { enabled = true, speed = 3.0, curve = "easeOut"  })
hl.animation("fadeOut",    { enabled = true, speed = 2.5, curve = "gentleIn" })
hl.animation("fadeDim",    { enabled = true, speed = 3.5, curve = "easeOut"  })  -- dim_inactive transition

-- Workspace switch: horizontal slide (matches natural left/right mental model)
hl.animation("workspaces", { enabled = true, speed = 3.5, curve = "easeInOut", style = "slidefade 20%" })

-- Special workspace (scratchpad): slide down from top
hl.animation("specialWorkspace", { enabled = true, speed = 3.0, curve = "easeOut", style = "slidevert" })

-- Border color change (no loop — loop forces constant redraws)
hl.animation("border",      { enabled = true, speed = 5.0, curve = "easeOut" })
hl.animation("borderangle", { enabled = false })   -- animated gradient border = expensive; off



hl.curve("snap",      { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05}  } }) -- springy open
hl.curve("easeOut",   { type = "bezier", points = { {0.16, 1},   {0.3, 1}     } }) -- fast then settle
hl.curve("easeInOut", { type = "bezier", points = { {0.65, 0},   {0.35, 1}    } }) -- smooth slide
hl.curve("gentleIn",  { type = "bezier", points = { {0.4, 0},    {1, 1}       } }) -- closes quickly

hl.config({
    animations = {
        enabled              = true,
        workspace_wraparound = false,  -- wrapping costs an extra frame; skip it
    },
})


-- OLD ANIMATIONS
-- animations {
--     bezier = md3_standard,     0.2, 0, 0, 1
--     bezier = md3_decel,        0.05, 0.7, 0.1, 1
--     bezier = md3_accel,        0.3, 0, 0.8, 0.15
--     bezier = md2,              0.4, 0, 0.2, 1

--     # Fun / experimental curves
--     bezier = overshot,         0.05, 0.9, 0.1, 1.1
--     bezier = crazyshot,        0.1, 1.5, 0.76, 0.92
--     bezier = hyprnostretch,    0.05, 0.9, 0.1, 1.0

--     # Menu/UI curves
--     bezier = menu_decel,       0.1, 1, 0, 1
--     bezier = menu_accel,       0.38, 0.04, 1, 0.07

--     # Easing functions
--     bezier = easeInOutCirc,    0.85, 0, 0.15, 1
--     bezier = easeOutCirc,      0, 0.55, 0.45, 1
--     bezier = easeOutExpo,      0.16, 1, 0.3, 1
--     bezier = softAcDecel,      0.26, 0.26, 0.15, 1

--     # ────────────────────────────────────────────────
--     # Window Animations
--     # ────────────────────────────────────────────────
--     animation = windows,       1, 6, wind, slide
--     animation = windowsIn,     1, 6, winIn, slide
--     animation = windowsOut,    1, 5, winOut, slide
--     animation = windowsMove,   1, 5, wind, slide

--     # ────────────────────────────────────────────────
--     # Borders & Angles
--     # ────────────────────────────────────────────────
--     animation = border,        1, 1, liner
--     animation = borderangle,   1, 30, liner, once

--     # ────────────────────────────────────────────────
--     # Fade & Layer Animations
--     # ────────────────────────────────────────────────
--     animation = fade,              1, 3, md3_decel
--     animation = layersIn,         1, 3, menu_decel, slide
--     animation = layersOut,        1, 1.6, menu_accel
--     animation = fadeLayersIn,     1, 2, menu_decel
--     animation = fadeLayersOut,    1, 4.5, menu_accel

--     # ────────────────────────────────────────────────
--     # Workspace Transitions
--     # ────────────────────────────────────────────────
--     animation = workspaces,       1, 7, menu_decel, slide
--     animation = workspaces,       1, 5, wind

--     # ────────────────────────────────────────────────
--     # Special Workspace
--     # ────────────────────────────────────────────────
--     animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
--     animation = specialWorkspace, 1, 3, md3_decel, slidevert
-- }
