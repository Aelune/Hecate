-- ENVariables.lua
-- hl.env(key, value) only — exactly two string args in Hyprland v0.55
-- Fallback chains (wayland,x11) must be a single semicolon-separated string.

local home        = os.getenv("HOME")
local cache_home  = os.getenv("XDG_CACHE_HOME")  or (home .. "/.cache")
local data_home   = os.getenv("XDG_DATA_HOME")   or (home .. "/.local/share")
local config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local state_home  = os.getenv("XDG_STATE_HOME")  or (home .. "/.local/state")
local runtime_dir = os.getenv("XDG_RUNTIME_DIR")

-- ── XDG Base Directories ──────────────────────────────────────
hl.env("XDG_CACHE_HOME",  cache_home)
hl.env("XDG_DATA_HOME",   data_home)
hl.env("XDG_CONFIG_HOME", config_home)
hl.env("XDG_STATE_HOME",  state_home)

-- ── XDG Desktop Session ───────────────────────────────────────
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- ── Toolkit Backends ─────────────────────────────────────────
-- Fallback chains use semicolons inside a single string
hl.env("GDK_BACKEND",     "wayland;x11;*")
hl.env("GSK_RENDERER",    "gl")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER",  "wayland;x11")
hl.env("CLUTTER_BACKEND",  "wayland")
hl.env("EGL_PLATFORM",     "wayland")

-- ── Qt Theming ────────────────────────────────────────────────
hl.env("QT_QPA_PLATFORMTHEME",            "qt6ct")
hl.env("QT5_QPA_PLATFORMTHEME",           "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",     "1")

-- ── Firefox ───────────────────────────────────────────────────
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("MOZ_DBUS_REMOTE",    "1")

-- ── Electron ─────────────────────────────────────────────────
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- ── Cursor ───────────────────────────────────────────────────
hl.env("XCURSOR_THEME",    "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE",     "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE",  "24")

-- ── AMD GPU / Hardware Video Acceleration ────────────────────
hl.env("AMD_USERQ",         "1")
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("VDPAU_DRIVER",      "radeonsi")

-- ── Java ─────────────────────────────────────────────────────
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("_JAVA_OPTIONS", "-Djava.util.prefs.userRoot=" .. config_home .. "/java")

-- ── Go ───────────────────────────────────────────────────────
hl.env("GOPATH",     data_home .. "/public/go")
hl.env("GOMODCACHE", data_home .. "/public/go/mod")

-- ── Miscellaneous ─────────────────────────────────────────────
if runtime_dir then
    hl.env("SSH_AUTH_SOCK", runtime_dir .. "/ssh-agent.socket")
end
hl.env("NO_AT_BRIDGE", "1")
