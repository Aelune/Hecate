#!/bin/bash

# Hecate Hyprland Dotfiles Installer
# Automated installation script with distro detection and dependency management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/Aelune/hecate"
INSTALL_DIR="$HOME/.hecate"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect Linux distribution
detect_distro() {
    log_info "Detecting Linux distribution..."

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_LIKE=$ID_LIKE
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DISTRO=$DISTRIB_ID
    else
        log_error "Cannot detect distribution"
        exit 1
    fi

    log_success "Detected distribution: $DISTRO"
}

# Install dependencies based on distro
install_dependencies() {
    log_info "Installing dependencies for $DISTRO..."

    case $DISTRO in
        arch|manjaro|endeavouros)
            log_info "Using pacman/yay for Arch-based system"

            # Check if yay is installed, install if not
            if ! command -v yay &> /dev/null; then
                log_warning "yay not found, installing..."
                sudo pacman -S --needed --noconfirm git base-devel
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                cd -
            fi

            # Install dependencies
            yay -S --needed --noconfirm \
                hyprland \
                waybar \
                fastfetch \
                kitty \
                firefox \
                zsh \
                cava \
                rofi \
                rofi-emoji \
                grim \
                slurp \
                wl-clipboard \
                jq \
                libnotify \
                swww \
                wf-recorder \
                hyprlock \
                hypridle \
                wlogout \
                pavucontrol \
                playerctl \
                polkit-kde-agent \
                xdg-desktop-portal-hyprland \
                qt5-wayland \
                qt6-wayland
            ;;

        fedora)
            log_info "Using dnf for Fedora"
            sudo dnf install -y \
                hyprland \
                waybar \
                fastfetch \
                kitty \
                firefox \
                zsh \
                cava \
                rofi \
                grim \
                slurp \
                wl-clipboard \
                jq \
                libnotify \
                wf-recorder \
                pavucontrol \
                playerctl

            # Install swww from source or copr if not available
            if ! command -v swww &> /dev/null; then
                log_warning "swww not in repos, you may need to install manually"
            fi
            ;;

        ubuntu|debian|pop)
            log_info "Using apt for Debian-based system"
            sudo apt update
            sudo apt install -y \
                kitty \
                firefox \
                zsh \
                cava \
                rofi \
                grim \
                slurp \
                wl-clipboard \
                jq \
                libnotify-bin \
                wf-recorder \
                pavucontrol \
                playerctl \
                build-essential \
                git \
                cmake \
                meson \
                ninja-build

            log_warning "Hyprland, waybar, and some packages need to be built from source on Debian/Ubuntu"
            log_warning "Please visit https://hyprland.org for build instructions"
            ;;

        nixos)
            log_info "NixOS detected - please add packages to your configuration.nix"
            log_warning "This script cannot install packages on NixOS"
            log_warning "Add the following to your configuration.nix:"
            echo "  environment.systemPackages = with pkgs; ["
            echo "    hyprland waybar fastfetch kitty firefox zsh cava rofi"
            echo "    grim slurp wl-clipboard jq libnotify swww wf-recorder"
            echo "  ];"
            read -p "Press enter when packages are installed..."
            ;;

        *)
            log_error "Unsupported distribution: $DISTRO"
            log_warning "Please install dependencies manually:"
            echo "  - hyprland, waybar, fastfetch, kitty, firefox, zsh"
            echo "  - cava, rofi, rofi-emoji, grim, slurp, wl-clipboard"
            echo "  - jq, libnotify, swww, wf-recorder, hyprlock, hypridle"
            read -p "Press enter when ready to continue..."
            ;;
    esac

    log_success "Dependencies installation completed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    log_info "Installing Oh My Zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh My Zsh already installed, skipping..."
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    fi
}

# Backup existing configurations
backup_configs() {
    log_info "Backing up existing configurations..."

    mkdir -p "$BACKUP_DIR"

    # List of directories to backup
    DIRS_TO_BACKUP=(
        "hypr"
        "waybar"
        "kitty"
        "fastfetch"
        "wlogout"
        "zsh"
    )

    for dir in "${DIRS_TO_BACKUP[@]}"; do
        if [ -d "$CONFIG_DIR/$dir" ]; then
            log_info "Backing up $dir..."
            cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
            log_success "Backed up $dir to $BACKUP_DIR"
        fi
    done

    # Backup .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        log_info "Backing up .zshrc..."
        cp "$HOME/.zshrc" "$BACKUP_DIR/"
    fi

    log_success "Backup completed at $BACKUP_DIR"
}

# Clone repository
clone_repo() {
    log_info "Cloning Hecate dotfiles..."

    if [ -d "$INSTALL_DIR" ]; then
        log_warning "Installation directory exists, removing..."
        rm -rf "$INSTALL_DIR"
    fi

    git clone "$REPO_URL" "$INSTALL_DIR"
    log_success "Repository cloned to $INSTALL_DIR"
}

# Install dotfiles
install_dotfiles() {
    log_info "Installing dotfiles..."

    cd "$INSTALL_DIR"

    # Create .config directory if it doesn't exist
    mkdir -p "$CONFIG_DIR"

    # Copy config directories
    if [ -d "config" ]; then
        log_info "Copying configuration files..."

        # Copy each config directory
        for item in config/*; do
            if [ -d "$item" ]; then
                dir_name=$(basename "$item")
                log_info "Installing $dir_name..."

                # Remove existing config if present
                if [ -d "$CONFIG_DIR/$dir_name" ]; then
                    rm -rf "$CONFIG_DIR/$dir_name"
                fi

                cp -r "$item" "$CONFIG_DIR/"
                log_success "$dir_name installed"
            fi
        done
    fi

    # Make scripts executable
    if [ -d "$CONFIG_DIR/hypr/scripts" ]; then
        log_info "Making scripts executable..."
        chmod +x "$CONFIG_DIR/hypr/scripts/"*.sh
        log_success "Scripts are now executable"
    fi

    log_success "Dotfiles installation completed"
}

# Set Zsh as default shell
set_zsh_shell() {
    log_info "Setting Zsh as default shell..."

    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        log_success "Zsh set as default shell (restart required)"
    else
        log_info "Zsh is already the default shell"
    fi
}

# --- Install Hyprland plugins (hyprfocus, hyprspace) ---
install_plugins() {
    echo "[INFO] Setting up Hyprland plugins..."

    # Check hyprpm
    if ! command -v hyprpm &>/dev/null; then
        echo "[WARN] hyprpm not found. Installing..."
        if command -v yay &>/dev/null; then
            yay -S --noconfirm hyprpm
        elif command -v paru &>/dev/null; then
            paru -S --noconfirm hyprpm
        else
            echo "[ERROR] No AUR helper found (yay/paru). Install hyprpm manually."
            return 1
        fi
    fi

    # Update and install plugins
    hyprpm update
    hyprpm add https://github.com/VortexCoyote/hyprfocus || true
    hyprpm add https://github.com/KZDKM/Hyprspace || true
}

# --- Enable and apply plugins ---
setup_plugins() {
    echo "[INFO] Enabling Hyprland plugins..."
    hyprpm enable hyprfocus || true
    hyprpm enable hyprspace || true

    echo "[INFO] Reloading Hyprland with plugins..."
    hyprpm reload
    hyprctl reload
    notify-send "Hyprland" "Hyprland plugins installed & enabled ✅"
}


# Main installation flow
main() {
    echo "╔════════════════════════════════════════╗"
    echo "║   🐾 Hecate Hyprland Dotfiles         ║"
    echo "║       Installation Script             ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    log_warning "This script will:"
    echo "  1. Detect your Linux distribution"
    echo "  2. Install required dependencies"
    echo "  3. Backup existing configurations"
    echo "  4. Clone and install Hecate dotfiles"
    echo ""
    read -p "Continue? (y/N): " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled"
        exit 0
    fi

    echo ""

    # Run installation steps
    detect_distro
    install_dependencies
    install_oh_my_zsh
    backup_configs
    clone_repo
    install_dotfiles
    set_zsh_shell
    install_plugins
    setup_plugins

    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   ✨ Installation Complete!           ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    log_success "Hecate dotfiles installed successfully!"
    echo ""
    log_info "Next steps:"
    echo "  1. Log out and log back in (or reboot)"
    echo "  2. Select Hyprland as your session at login"
    echo "  3. Your old configs are backed up at: $BACKUP_DIR"
    echo ""
    log_info "For keybindings, check: ~/.config/hypr/documentation/keybinds.md"
    echo ""
}

# Run main function
main
