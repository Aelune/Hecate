# ~/.bashrc - Adapted from .zshrc

# Load Powerlevel10k instant prompt (Bash-compatible)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-bash.sh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-bash.sh"
fi

# Oh My Bash installation path
export BASH_IT="$HOME/.bash_it"

# PATH Configuration
export PATH="$PATH:/snap/bin"
export PATH="$HOME/.local/bin:$PATH"

# Load Oh My Bash
if [ -f "$BASH_IT/bash_it.sh" ]; then
  source "$BASH_IT/bash_it.sh"
fi

# Theme Configuration (Powerlevel10k for Bash, if installed)
export BASH_IT_THEME='powerlevel10k'

# Aliases
alias fast='fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc'

# Modern command replacements (if installed)
alias ls='exa --icons --group-directories-first'
alias ll='exa -la --icons --group-directories-first'
alias lt='exa -T --icons --level=2'
alias icat='kitty icat'
# alias rm='vx --noconfirm'

# Directory shortcuts
alias doc='cd ~/Documents/'
alias dow='cd ~/Downloads/'
alias pic='cd ~/Pictures/'
alias rdb='rm ~/.cache/cliphist/db'

# System utilities
# alias upgrade='sudo pacman -Syu'
alias meminfo='free -m'
alias cpuinfo='cat /proc/cpuinfo'
alias ports='sudo netstat -tulanp'

# History Configuration
export HISTFILE=~/.bash_history
export HISTSIZE=100000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# FZF Configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# FZF key bindings (requires fd, bat, exa)
export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="--preview 'exa --tree --level=1 {}'"

# thefuck integration
eval "$(thefuck --alias)"

# Source environment variables if file exists
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# Load Powerlevel10k config if available
[ -f ~/.p10k.bash ] && source ~/.p10k.bash

# Custom function: fuzzy cd into directories
cdf() {
  local dir
  dir=$(fd --type d --hidden --exclude .git . ~ | fzf)
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# Bind Ctrl+G to `cdf` using `bind -x` (Bash 4.0+)
bind -x '"\C-g": cdf'