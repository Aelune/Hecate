#  _   _ _____ ____    _  _____ _____
# | | | | ____/ ___|  / \|_   _| ____|     /\_/\
# | |_| |  _|| |     / _ \ | | |  _|      ( o.o )
# |  _  | |__| |___ / ___ \| | | |___      > ^ <
# |_| |_|_____\____/_/   \_\_| |_____|


# Must stay at the top of ~/.zshrc to work properly
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH installation path
export ZSH="$HOME/.oh-my-zsh"                     # Path to oh-my-zsh installation

# PATH Configuration
# These define where the shell looks for executables
export PATH="$PATH:/home/dawu/.dotnet/tools"      # .NET CLI tools
export PATH="/usr/local/cuda/bin:$PATH"           # CUDA toolkit binaries
export PATH="$PATH:$HOME/scripts/gus"             # Custom user scripts
export PATH="$HOME/.nvm/versions/node/v20.18.2/bin:$PATH"  # Node.js binaries
export PATH="$PATH:/snap/bin"                     # Snap package binaries
#export PATH="$HOME/.pyenv/bin:$PATH"              # Pyenv binaries
export PATH="$HOME/.local/bin:$PATH"              # User local binaries

# Uncomment these lines if you need them

# .NET Configuration
#export DOTNET_ROOT=/usr/lib64/dotnet             # .NET SDK root directory

# Node Version Manager setup
# Lazy load NVM (user installation path)
export NVM_DIR="$HOME/.nvm"

load-nvm() {
  if ! command -v nvm >/dev/null; then
    unset -f node npm npx 2>/dev/null
    source "$NVM_DIR/nvm.sh"
  fi
}

autoload -U add-zsh-hook

for cmd in node npm npx; do
  eval "
    function $cmd() {
      load-nvm
      $cmd \"\$@\"
    }
  "
done


# Theme Configuration
ZSH_THEME="powerlevel10k/powerlevel10k"          # Set the ZSH theme to Powerlevel10k
#typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet    # Uncomment to silence instant prompt warnings

# Enhanced Plugins
plugins=(
    sudo                      # Press ESC twice to prepend sudo
    history                   # History command enhancements
    fzf                       # Fuzzy finder integration
    zsh-autosuggestions       # Fish-like autosuggestions
    zsh-syntax-highlighting   # Syntax highlighting for commands
    thefuck                   # Corrects previous command errors
#   git                       # Git integration and aliases
#   encode64                  # Encode/decode base64 strings
#   copypath                  # Copy current directory path
#   charm                     # Charm CLI tools integration
#   conda                     # Conda environment integration
#   dnf                       # DNF package manager helpers
#   docker                    # Docker command completion and aliases
#   docker-compose            # Docker Compose support
#   npm                       # NPM commands completion and aliases
#   nvm                       # Node Version Manager integration
#   pyenv                     # Python version management
#   python                    # Python support
#   vscode                    # VS Code integration
#   jsontools                 # Tools for working with JSON
#   kubectl                   # Kubernetes CLI support
#   z                         # Jump to frequent directories
#   colored-man-pages         # Colorize man pages
#   command-not-found         # Suggests packages for unknown commands
#   dirhistory                # Keyboard shortcuts for directory history
#   web-search                # Search web from terminal
)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh                        # Initialize Oh-My-Zsh with the configuration

# Display a random Pokemon sprite on terminal startup (fun decoration)
alias poke='pokemon-colorscripts --no-title -s -n'  # Show random Pokemon sprite

# System information display (alternative to neofetch)
alias fast='fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc'  # Display system info

# History Configuration
HISTFILE=~/.zsh_history                         # History file location
HISTSIZE=100000                                 # Number of commands to store in memory
SAVEHIST=100000                                 # Number of commands to save in history file
setopt SHARE_HISTORY                            # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST                   # Remove duplicates first when history is full
setopt HIST_IGNORE_DUPS                         # Don't store duplicated commands
setopt HIST_FIND_NO_DUPS                        # Don't display duplicates when searching
setopt HIST_REDUCE_BLANKS                       # Remove superfluous blanks from commands
setopt APPENDHISTORY                            # Append to history file instead of overwriting

# FZF (Fuzzy Finder) Configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh          # Source FZF if installed
source <(fzf --zsh)                             # Set up FZF key bindings for zsh

# FZF key bindings enhancement
export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"  # Use fd instead of find for better performance
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"  # Preview files with bat
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"  # Directory search with fd
export FZF_ALT_C_OPTS="--preview 'exa --tree --level=1 {}'"  # Preview directories with exa

# Modern command replacements
# Uncomment if you have these tools installed
alias ls='exa --icons --group-directories-first'  # Replace ls with exa
alias ll='exa -la --icons --group-directories-first'  # Detailed list
alias lt='exa -T --icons --level=2'               # Tree view (2 levels)
#alias cat='bat'                                   # Replace cat with bat
# alias grep='rg'                                   # Replace grep with ripgrep
#alias find='fd'                                   # Replace find with fd
#alias du='dust'                                   # Replace du with dust
#alias top='btm'                                   # Replace top with bottom


# Git shortcuts
# alias gt='git'                                   # Git shorthand
alias gs='git status'                           # Show git status
alias ga='git add'                              # Stage files
alias gaa='git add --all'                       # Stage all files
alias gra='git remote add origin'               # Add remote origin
alias gc='git commit'                           # Commit changes
alias gcm='git commit -m'                       # Commit with message
alias gco='git checkout'                        # Checkout branch
alias gbr='git branch'                          # List branches
alias gbl='git blame'                           # Show file blame
alias gpo='git push origin'                     # Push to origin
alias gpom='git push origin main'               # Push to origin main
alias gpl='git pull'                            # Pull changes
alias gd='git diff'                             # Show differences
alias gl='git log --oneline --graph --decorate' # Compact git log
alias gls='git log --stat'                      # Git log with stats
alias gcl='git clone'                           # Clone repository
alias gf='git fetch'                            # Fetch changes
alias gr='git restore'                          # Restore files
alias grs='git restore --staged'                # Unstage files
alias grb='git rebase'                          # Rebase branch

# Docker shortcuts
# alias d='docker'                                # Docker shorthand
# alias dc='docker compose'                       # Docker compose shorthand
# alias dps='docker ps'                           # List running containers
# alias dpsa='docker ps -a'                       # List all containers
# alias di='docker images'                        # List images
# alias dex='docker exec -it'                     # Execute in container interactively
# alias dlf='docker logs -f'                      # Follow container logs

# Kubernetes shortcuts
# alias k='kubectl'                               # Kubectl shorthand
# alias kgp='kubectl get pods'                    # Get pods
# alias kgs='kubectl get svc'                     # Get services
# alias kgd='kubectl get deployments'             # Get deployments
# alias kgn='kubectl get nodes'                   # Get nodes
# alias kd='kubectl describe'                     # Describe resource
# alias kl='kubectl logs'                         # Show logs

# # Development shortcuts
# alias nrd='npm run dev'                         # Run npm dev script
# alias nrs='npm run start'                       # Run npm start script
# alias nrb='npm run build'                       # Run npm build script
# alias nrt='npm run test'                        # Run npm test script
# alias pips='pip install -e .'                   # Install package in development mode
# alias pyc='python -m compileall .'              # Compile Python files
# alias pyt='pytest'                              # Run pytest
# alias mng='python manage.py'                    # Django manage.py shortcut

# System utilities
alias upgrade='sudo pacman -Syu'                # Update Arch Linux
# alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # Remove orphaned packages
alias services='systemctl --type=service --state=running' # List running services
# alias diskspace='df -h'                         # Check disk space
alias meminfo='free -m'                         # Show memory info
alias cpuinfo='cat /proc/cpuinfo'               # Show CPU info
alias ports='sudo netstat -tulanp'              # Show open ports

# Development environment tools
# alias activate='source venv/bin/activate'       # Activate Python virtual environment
# alias deactivate='deactivate'                   # Deactivate Python virtual environment
# alias mkenv='python -m venv venv'               # Create virtual environment
# alias prp='poetry run python'                   # Run Python with Poetry

# Pyenv setup - for managing multiple Python versions
#eval "$(pyenv init --path)"                     # Initialize Pyenv PATH
#eval "$(pyenv init -)"                          # Initialize Pyenv shell integration

# Conda setup - for data science and ML environment management
# __conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"                       # Set up conda for the shell
# else
#     if [ -f "/usr/etc/profile.d/conda.sh" ]; then
#         . "/usr/etc/profile.d/conda.sh"         # Alternative conda setup
#     else
#         export PATH="/usr/bin:$PATH"            # Fall back to system path
#     fi
# fi
# unset __conda_setup                             # Clean up setup variable

# TheFuck setup - for correcting previous command errors
eval $(thefuck --alias)                         # Initialize 'thefuck' alias

# Source environment variables if they exist
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"  # Load custom environment variables

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh    # Load Powerlevel10k configuration if it exists

# Command execution time calculation
# Uncomment to enable timing for each command
#function preexec() {
#  START_TIME=$(date +%s%3N)                    # Record start time in milliseconds
#}
#
#function precmd() {
#  if [[ -n "$START_TIME" ]]; then
#    END_TIME=$(date +%s%3N)                    # Record end time
#    DIFF_TIME=$((END_TIME - START_TIME))       # Calculate difference
#    echo "Took $((DIFF_TIME / 1000))s $((DIFF_TIME % 1000))ms"  # Show execution time
#  fi
#}

# Load zsh-autosuggestions and zsh-syntax-highlighting if not loaded by Oh-My-Zsh
# These should be at the end of .zshrc for proper functioning
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autoload zsh functions for advanced usage
autoload -Uz compinit                           # Initialize completion system
compinit                                        # Load completions


cdf() {
  local dir
  dir=$(fd --type d --hidden --exclude .git . ~ | fzf) && cd "$dir"
}

# Bind Ctrl+G to run `cdf`
bindkey -s '^G' 'cdf\n'
#eval "$(zoxide init zsh)"

#z() {
#  cd "$(zoxide query -i "$@")"
#}
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
