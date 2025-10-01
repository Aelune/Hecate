# ZSH Configuration (`.zshrc`) Documentation

This document explains the structure and functionality of my custom **ZSH configuration** designed for Arch Linux and Hyprland setups, including Oh My Zsh, Powerlevel10k, and various productivity plugins.

---

## Table of Contents

1. [Instant Prompt](#instant-prompt)
2. [Environment Variables & PATH](#environment-variables--path)
3. [Theme Configuration](#theme-configuration)
4. [Plugins](#plugins)
5. [Aliases](#aliases)
6. [History Configuration](#history-configuration)
7. [FZF Integration](#fzf-integration)
8. [Modern Command Replacements](#modern-command-replacements)
9. [Directory Shortcuts](#directory-shortcuts)
10. [System Utilities](#system-utilities)
11. [TheFuck Setup](#thefuck-setup)
12. [Environment Variables](#environment-variables)
13. [Powerlevel10k Configuration](#powerlevel10k-configuration)
14. [ZSH Autosuggestions & Syntax Highlighting](#zsh-autosuggestions--syntax-highlighting)
15. [Autoload Functions](#autoload-functions)
16. [Miscellaneous](#miscellaneous)

---

## Instant Prompt

```zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
````

* Speeds up ZSH startup by preloading **Powerlevel10k instant prompt**.
* Must stay at the **top** of `.zshrc` to function correctly.

---

## Environment Variables & PATH

```zsh
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/snap/bin"
export PATH="$HOME/.local/bin:$PATH"
```

* `$ZSH`: Location of Oh My Zsh installation.
* `$PATH`: Adds Snap and user-local binaries for convenience.

---

## Theme Configuration

```zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
```

* Uses **Powerlevel10k** for a modern, highly configurable prompt.

---

## Plugins

```zsh
plugins=(
    sudo
    history
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
    thefuck
)
```

* **sudo**: Press `ESC` twice to prepend `sudo` automatically.
* **history**: Enhances command history functionality.
* **fzf**: Fuzzy finder integration for files and directories.
* **zsh-autosuggestions**: Fish-like autosuggestions.
* **zsh-syntax-highlighting**: Highlights command syntax errors.
* **thefuck**: Suggests fixes for mistyped commands.

---

## Aliases

### Fun / Decorative

```zsh
alias poke='pokemon-colorscripts --no-title -s -n'
alias fast='fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc'
```

### System & File Operations

```zsh
alias upgrade='sudo pacman -Syu'
alias services='systemctl --type=service --state=running'
alias meminfo='free -m'
alias cpuinfo='cat /proc/cpuinfo'
alias ports='sudo netstat -tulanp'
alias rdb='rm ~/.cache/cliphist/db'
```

---

## History Configuration

```zsh
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt APPENDHISTORY
```

* Stores and shares a large history between sessions.
* Reduces duplicates and unnecessary blank commands.

---

## FZF Integration

```zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="--preview 'exa --tree --level=1 {}'"
```

* Fuzzy file and directory search.
* Previews files with `bat` and directories with `exa`.
* Uses `fd` for faster searches.

---

## Modern Command Replacements

```zsh
alias ls='exa --icons --group-directories-first'
alias ll='exa -la --icons --group-directories-first'
alias lt='exa -T --icons --level=2'
alias icat='kitty icat'
```

* Replaces `ls` with `exa` for a better visual file listing.
* Supports icons and tree views.
* `icat` displays images inline in `kitty` terminal.

---

## Directory Shortcuts

```zsh
alias doc='cd ~/Documents/'
alias dow='cd ~/Downloads/'
alias pic='cd ~/Pictures/'
```

* Quick navigation to common directories.

---

## TheFuck Setup

```zsh
eval $(thefuck --alias)
```

* Enables `fuck` alias to correct previous mistyped commands.

---

## Environment Variables

```zsh
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
```

* Sources custom environment variables if they exist.

---

## Powerlevel10k Configuration

```zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

* Loads saved Powerlevel10k preferences if available.

---

## ZSH Autosuggestions & Syntax Highlighting

* Already included in `plugins=(...)`.
* Manual sourcing lines removed to prevent duplicate loading.

---

## Autoload Functions

```zsh
autoload -Uz compinit
compinit
```

* Enables advanced **tab completion** support.

---

### Custom Function: `cdf()`

```zsh
cdf() {
  local dir
  dir=$(fd --type d --hidden --exclude .git . ~ | fzf) && cd "$dir"
}
bindkey -s '^G' 'cdf\n'
```

* Fuzzy directory search using `fd` and `fzf`.
* Bind `Ctrl+G` to run `cdf`.

---

## Miscellaneous

```zsh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH=$PATH:$HOME/.govm/bin
```

* Loads Node.js version manager completions.
* Adds `govm` binary to path.

---

## Notes

* Keep the **instant prompt** at the top for faster startup.
* All plugin installations should be handled via **Oh My Zsh custom folder**.
* Remove any redundant `source` statements if using Oh My Zsh plugins.
