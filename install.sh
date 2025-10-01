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

# Check if Hyprland is installed
check_hyprland() {
    if command -v Hyprland &> /dev/null; then
        HYPRLAND_VERSION=$(Hyprland --version 2>/dev/null | head -n1 || echo "unknown")
        log_info "Hyprland detected: $HYPRLAND_VERSION"
        return 0
    else
        log_warning "Hyprland not found"
        return 1
    fi
}

# Install/Update Hyprland
install_hyprland() {
    log_info "Installing/Updating Hyprland..."

    case $DISTRO in
        arch|manjaro|endeavouros)
            # Check if yay is installed
            if ! command -v yay &> /dev/null; then
                log_warning "yay not found, installing..."
                sudo pacman -S --needed --noconfirm git base-devel
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                cd -
            fi

            log_info "Installing Hyprland and required build tools..."
            yay -S --needed --noconfirm hyprland hyprland-protocols xdg-desktop-portal-hyprland
            yay -S --needed --noconfirm cmake meson cpio ninja base-devel

            log_success "Hyprland installed/updated"
            ;;

        fedora)
            log_info "Installing Hyprland on Fedora..."
            sudo dnf install -y hyprland hyprland-devel cmake meson cpio ninja-build
            ;;

        ubuntu|debian|pop)
            log_warning "Building Hyprland from source on Debian/Ubuntu..."
            log_info "Installing build dependencies..."

            sudo apt update
            sudo apt install -y \
                build-essential cmake meson ninja-build cpio \
                libwayland-dev wayland-protocols \
                libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev \
                libxcb-render-util0-dev libxcb-res0-dev libxcb-xfixes0-dev \
                libxcb-xinput-dev libxkbcommon-dev libpixman-1-dev \
                libdrm-dev libseat-dev libinput-dev \
                libpango1.0-dev libcairo2-dev \
                hwdata libliftoff-dev libdisplay-info-dev \
                git

            log_info "Cloning and building Hyprland..."
            cd /tmp
            if [ -d "Hyprland" ]; then
                rm -rf Hyprland
            fi
            git clone --recursive https://github.com/hyprwm/Hyprland
            cd Hyprland
            make all
            sudo make install

            log_success "Hyprland built and installed from source"
            ;;

        nixos)
            log_warning "On NixOS, add Hyprland to your configuration.nix:"
            echo "  programs.hyprland.enable = true;"
            read -p "Press enter when Hyprland is installed..."
            ;;

        *)
            log_error "Unsupported distribution for automatic Hyprland installation"
            log_warning "Please install Hyprland manually from: https://hyprland.org"
            read -p "Press enter when Hyprland is installed..."
            ;;
    esac
}

# Install dependencies based on distro
install_dependencies() {
    log_info "Installing dependencies for $DISTRO..."

    case $DISTRO in
        arch|manjaro|endeavouros)
            log_info "Using pacman/yay for Arch-based system"

            # Install dependencies
            yay -S --needed --noconfirm \
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
                qt6-wayland \
                cliphist \
                swaync \
                waypaper
            ;;

        fedora)
            log_info "Using dnf for Fedora"
            sudo dnf install -y \
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

            log_warning "Some packages (swww, hyprlock) may need manual installation"
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
                playerctl

            log_warning "waybar and some packages need to be built from source"
            ;;

        nixos)
            log_info "NixOS detected - add packages to configuration.nix"
            log_warning "Add required packages to your configuration.nix"
            read -p "Press enter when packages are installed..."
            ;;

        *)
            log_error "Unsupported distribution: $DISTRO"
            log_warning "Please install dependencies manually"
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
        "rofi"
        "swaync"
    )

    for dir in "${DIRS_TO_BACKUP[@]}"; do
        if [ -d "$CONFIG_DIR/$dir" ]; then
            log_info "Backing up $dir..."
            cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
            log_success "Backed up $dir"
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
        log_success "Zsh set as default shell"
    else
        log_info "Zsh is already the default shell"
    fi
}

# Install Hyprland plugins (only after Hyprland is confirmed running)
install_plugins() {
    log_info "Preparing Hyprland plugin installation..."

    # Create a post-install script for plugins
    cat > "$HOME/.hecate-install-plugins.sh" << 'EOF'
#!/bin/bash
# Post-install script for Hyprland plugins
# Run this AFTER logging into Hyprland

set -e

echo "[INFO] Installing Hyprland plugins..."

# Check if running in Hyprland
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "[ERROR] Not running in Hyprland session!"
    echo "[INFO] Please log into Hyprland first, then run this script"
    exit 1
fi

# Check hyprpm
if ! command -v hyprpm &>/dev/null; then
    echo "[ERROR] hyprpm not found!"
    exit 1
fi

# Update headers
echo "[INFO] Updating Hyprland headers..."
hyprpm update

# Install plugins
echo "[INFO] Installing hyprfocus..."
hyprpm add https://github.com/VortexCoyote/hyprfocus || true

echo "[INFO] Installing Hyprspace..."
hyprpm add https://github.com/KZDKM/Hyprspace || true

# Enable plugins
echo "[INFO] Enabling plugins..."
hyprpm enable hyprfocus || true
hyprpm enable hyprspace || true

# Reload
echo "[INFO] Reloading Hyprland..."
hyprpm reload
hyprctl reload

notify-send "Hecate" "Hyprland plugins installed successfully!" || true

echo "[SUCCESS] Plugins installed and enabled!"
echo "You can now delete this script: rm ~/.hecate-install-plugins.sh"
EOF

    chmod +x "$HOME/.hecate-install-plugins.sh"

    log_success "Plugin installer script created at: ~/.hecate-install-plugins.sh"
    log_info "Run this script AFTER logging into Hyprland"
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
    echo "  2. Install/Update Hyprland"
    echo "  3. Install required dependencies"
    echo "  4. Backup existing configurations"
    echo "  5. Clone and install Hecate dotfiles"
    echo ""
    read -p "Continue? (y/N): " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled"
        exit 0
    fi

    echo ""

    # Run installation steps
    detect_distro

    # Check and install/update Hyprland
    if ! check_hyprland; then
        log_warning "Hyprland not found. Installing..."
        install_hyprland
    else
        read -p "Update Hyprland? (y/N): " update_hypr
        if [[ "$update_hypr" =~ ^[Yy]$ ]]; then
            install_hyprland
        fi
    fi

    install_dependencies
    install_oh_my_zsh
    backup_configs
    clone_repo
    install_dotfiles
    set_zsh_shell
    install_plugins

    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   ✨ Installation Complete!           ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    log_success "Hecate dotfiles installed successfully!"
    echo ""
    log_info "Next steps:"
    echo "  1. Log out and log back in"
    echo "  2. Select 'Hyprland' at the login screen"
    echo "  3. Once in Hyprland, run: ~/.hecate-install-plugins.sh"
    echo "  4. Your old configs are backed up at: $BACKUP_DIR"
    echo ""
    log_info "Keybindings: ~/.config/hypr/keybinds.conf"
    echo ""
}

# Run main function
main
