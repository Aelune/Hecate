local vars = {}
vars.home       = os.getenv("HOME")
vars.cache_home = os.getenv("XDG_CACHE_HOME")  or (home .. "/.cache")
vars.data_home  = os.getenv("XDG_DATA_HOME")   or (home .. "/.local/share")
vars.config_home= os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
vars.state_home = os.getenv("XDG_STATE_HOME")  or (home .. "/.local/state")
vars.runtime_dir= os.getenv("XDG_RUNTIME_DIR") -- set by PAM/logind, don't override
vars.scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"
vars.localBin = os.getenv("HOME") .. "/.local/bin"
vars.mainMod = "SUPER"
vars.terminal = "kitty"
vars.fileManager = "thunar"
vars.browser = "firefox"
vars.workspaces = 5
return vars
