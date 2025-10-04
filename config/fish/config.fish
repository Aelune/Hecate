# ~/.config/fish/config.fish

# === PATH Configuration ===
set -gx PATH $PATH /snap/bin
set -gx PATH $HOME/.local/bin $PATH

# === Theme: Powerlevel10k for Fish ===
# Requires: https://github.com/jorgebucaran/theme-pure or fish-p10k (Fish doesn’t support P10K natively)
# For demonstration, setting prompt to a popular alternative like `fish-pure`:
# Install with: fisher install rafaelrinaldi/pure
# Or use Starship as universal prompt: https://starship.rs
# Example (recommended):
# fisher install starship/starship
set -gx STARSHIP_CONFIG ~/.config/starship.toml
starship init fish | source

# === Plugins (via fisher) ===
# Install fisher if not yet installed: 
# curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# Install equivalent plugins:
# fisher install jorgebucaran/fisher
# fisher install jethrokuan/z       # directory jumping
# fisher install jethrokuan/fzf     # FZF integration
# fisher install jorgebucaran/nvm.fish  # NVM support
# fisher install oh-my-fish/plugin-thefuck
# fisher install PatrickF1/fzf.fish
# fisher install decors/fish-colored-man

# === TheFuck setup ===
thefuck --alias | source

# === Aliases ===
alias fast "fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc"

# Modern command replacements
alias ls "exa --icons --group-directories-first"
alias ll "exa -la --icons --group-directories-first"
alias lt "exa -T --icons --level=2"
alias icat "kitty icat"
# alias rm "vx --noconfirm"

# Directory shortcuts
alias doc "cd ~/Documents"
alias dow "cd ~/Downloads"
alias pic "cd ~/Pictures"
alias rdb "rm ~/.cache/cliphist/db"

# System utilities
alias upgrade "sudo pacman -Syu"
alias services "systemctl --type=service --state=running"
alias meminfo "free -m"
alias cpuinfo "cat /proc/cpuinfo"
alias ports "sudo netstat -tulanp"

# === History Settings ===
set -Ux fish_history ~/.local/share/fish/fish_history
set -g fish_history_limit 100000

# === FZF Config ===
# These variables customize keybindings
set -Ux FZF_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git"
set -Ux FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always {}'"
set -Ux FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
set -Ux FZF_ALT_C_OPTS "--preview 'exa --tree --level=1 {}'"

# === Source environment file if it exists ===
if test -f "$HOME/.local/bin/env"
    source "$HOME/.local/bin/env"
end

# === NVM support (via plugin) ===
# If you installed jorgebucaran/nvm.fish via fisher, NVM is ready to go
# Otherwise, source it manually if needed:
# set -gx NVM_DIR "$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ]; and source "$NVM_DIR/nvm.sh"

# === cdf: Fuzzy directory jump ===
function cdf
    set dir (fd --type d --hidden --exclude .git . ~ | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end

# Bind Ctrl+G to `cdf`
bind \cg cdf
