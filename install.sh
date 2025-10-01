#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
#  🐾 Hecate Hyprland Dotfiles Installer
#  Automated installation script with distro detection and dependency management
#  Repository: https://github.com/Aelune/hecate
# ═══════════════════════════════════════════════════════════════════════════

set -e

# ═══════════════════════════════════════════════════════════════════════════
#  Color Definitions
# ═══════════════════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════════════════════
#  Configuration
# ═══════════════════════════════════════════════════════════════════════════
REPO_URL="https://github.com/Aelune/hecate"
INSTALL_DIR="$HOME/.hecate"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# ═══════════════════════════════════════════════════════════════════════════
#  Logging Functions
# ═══════════════════════════════════════════════════════════════════════════
print_banner() {
    echo -e "${MAGENTA}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                                                               ║"
    echo "║              🐾  H E C A T E   I N S T A L L E R             ║"
    echo "║                                                               ║"
    echo "║          Hyprland Dotfiles by Aelune                         ║"
    echo "║          https://github.com/Aelune/hecate                    ║"
    echo "║                                                               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

log_info() {
    echo -e "${CYAN}${BOLD}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}${BOLD}[✓]${NC} ${GREEN}$1${NC}"
}

log_warning() {
    echo -e "${YELLOW}${BOLD}[!]${NC} ${YELLOW}$1${NC}"
}

log_error() {
    echo -e "${RED}${BOLD}[✗]${NC} ${RED}$1${NC}"
}

log_step() {
    echo -e "\n${BLUE}${BOLD}═══ $1 ═══${NC}\n"
}

# ═══════════════════════════════════════════════════════════════════════════
#  Distribution Detection
# ═══════════════════════════════════════════════════════════════════════════
detect_distro() {
    log_step "Detecting Linux Distribution"

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

    log_success "Detected: ${BOLD}$DISTRO${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
#  Hyprland Installation & Verification
# ═══════════════════════════════════════════════════════════════════════════
check_hyprland() {
    if command -v Hyprland &> /dev/null; then
        HYPRLAND_VERSION=$(Hyprland --version 2>/dev/null | head -n1 || echo "unknown")
        log_success "Hyprland found: ${HYPRLAND_VERSION}"
        return 0
    else
        log_warning "Hyprland not detected"
        return 1
    fi
}

install_hyprland() {
    log_step "Installing/Updating Hyprland"

    case $DISTRO in
        arch|manjaro|endeavouros)
            # Install yay if needed
            if ! command -v yay &> /dev/null; then
                log_info "Installing yay AUR helper..."
                sudo pacman -S --needed --noconfirm git base-devel
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                cd -
                log_success "yay installed"
            fi

            log_info "Installing Hyprland and required components..."
            yay -S --needed --noconfirm hyprland hyprland-protocols xdg-desktop-portal-hyprland
            yay -S --needed --noconfirm cmake meson cpio ninja base-devel

            log_success "Hyprland installation complete"
            ;;

        fedora)
            log_info "Installing Hyprland on Fedora..."
            sudo dnf install -y hyprland hyprland-devel cmake meson cpio ninja-build
            log_success "Hyprland installed"
            ;;

        ubuntu|debian|pop)
            log_warning "Building Hyprland from source (this may take a while)..."
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
            [ -d "Hyprland" ] && rm -rf Hyprland
            git clone --recursive https://github.com/hyprwm/Hyprland
            cd Hyprland
            make all
            sudo make install

            log_success "Hyprland built and installed from source"
            ;;

        nixos)
            log_warning "On NixOS, add to your configuration.nix:"
            echo -e "${CYAN}  programs.hyprland.enable = true;${NC}"
            read -p "Press enter when Hyprland is installed..."
            ;;

        *)
            log_error "Unsupported distribution for automatic installation"
            log_warning "Visit: https://hyprland.org for manual installation"
            read -p "Press enter when Hyprland is installed..."
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════
#  Dependencies Installation
# ═══════════════════════════════════════════════════════════════════════════
install_dependencies() {
    log_step "Installing Dependencies"

    case $DISTRO in
        arch|manjaro|endeavouros)
            log_info "Installing packages via yay..."
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
                waypaper \
                exa

            log_success "All dependencies installed"
            ;;

        fedora)
            log_info "Installing packages via dnf..."
            sudo dnf install -y \
                waybar fastfetch kitty firefox zsh cava rofi \
                grim slurp wl-clipboard jq libnotify wf-recorder \
                pavucontrol playerctl

            log_warning "Some packages (swww, hyprlock) may need manual installation"
            log_success "Core dependencies installed"
            ;;

        ubuntu|debian|pop)
            log_info "Installing packages via apt..."
            sudo apt update
            sudo apt install -y \
                kitty firefox zsh cava rofi grim slurp \
                wl-clipboard jq libnotify-bin wf-recorder \
                pavucontrol playerctl

            log_warning "waybar and some packages need manual installation"
            log_success "Core dependencies installed"
            ;;

        nixos)
            log_warning "Add required packages to configuration.nix"
            echo -e "${CYAN}  environment.systemPackages = with pkgs; [${NC}"
            echo -e "${CYAN}    waybar fastfetch kitty firefox zsh cava rofi${NC}"
            echo -e "${CYAN}    grim slurp wl-clipboard jq libnotify swww${NC}"
            echo -e "${CYAN}  ];${NC}"
            read -p "Press enter when packages are installed..."
            ;;

        *)
            log_error "Unsupported distribution"
            log_warning "Please install dependencies manually"
            read -p "Press enter to continue..."
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════
#  Oh My Zsh Installation
# ═══════════════════════════════════════════════════════════════════════════
Set_zsh() {
    log_step "Installing Oh My Zsh"

    # Install Oh My Zsh if not already present
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh My Zsh already installed, skipping..."
    else
        log_info "Downloading and installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    fi

    # Ensure ZSH_CUSTOM path
    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    log_info "Using ZSH_CUSTOM at: $ZSH_CUSTOM"

    echo -e "${BLUE}Installing Zsh plugins and dependencies...${NC}"

    # --- Plugins ---
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        log_success "zsh-autosuggestions installed"
    else
        log_warning "zsh-autosuggestions already exists, skipping..."
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        log_success "zsh-syntax-highlighting installed"
    else
        log_warning "zsh-syntax-highlighting already exists, skipping..."
    fi

    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        log_success "Powerlevel10k installed"
    else
        log_warning "Powerlevel10k already exists, skipping..."
    fi

    # --- FZF ---
    if [ ! -d "$HOME/.fzf" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
        log_success "fzf installed"
    else
        log_warning "fzf already exists, skipping..."
    fi

    # --- Thefuck ---
    if ! command -v thefuck &>/dev/null; then
        if command -v pipx &>/dev/null; then
            pipx install thefuck
        elif command -v pip3 &>/dev/null; then
            pip3 install --user thefuck
        fi
        log_success "thefuck installed"
    else
        log_warning "thefuck already installed, skipping..."
    fi
    
    log_info "Zsh setup complete. Remember to add plugins in ~/.zshrc:"
    echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)"
    echo "ZSH_THEME=\"powerlevel10k/powerlevel10k\""
}

# ═══════════════════════════════════════════════════════════════════════════
#  SDDM Display Manager Setup
# ═══════════════════════════════════════════════════════════════════════════
setup_sddm() {
    log_step "Setting up SDDM Display Manager"

    # Check if SDDM is running
    if systemctl is-active --quiet sddm.service 2>/dev/null; then
        log_success "SDDM is already active"
        return 0
    fi

    # Check if SDDM is installed
    if command -v sddm &> /dev/null; then
        log_warning "SDDM installed but not active"
        read -p "Enable SDDM? (y/N): " enable_sddm
        if [[ "$enable_sddm" =~ ^[Yy]$ ]]; then
            sudo systemctl enable sddm.service
            sudo systemctl set-default graphical.target
            log_success "SDDM enabled (active after reboot)"
        fi
        return 0
    fi

    # SDDM not found
    log_warning "SDDM not detected on your system"
    CURRENT_DM=$(systemctl status display-manager 2>/dev/null | grep -oP '(?<=Loaded: loaded \()[^;]+' || echo 'None')
    echo -e "  Current display manager: ${YELLOW}${CURRENT_DM}${NC}"
    echo ""
    read -p "Install and switch to SDDM? (y/N): " install_sddm

    if [[ ! "$install_sddm" =~ ^[Yy]$ ]]; then
        log_info "Skipping SDDM installation"
        return 0
    fi

    log_info "Installing SDDM..."

    case $DISTRO in
        arch|manjaro|endeavouros)
            yay -S --needed --noconfirm sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg
            sudo systemctl enable sddm.service
            sudo systemctl set-default graphical.target
            ;;

        fedora)
            sudo dnf install -y sddm qt5-qtgraphicaleffects qt5-qtquickcontrols2 qt5-qtsvg
            sudo systemctl enable sddm.service
            sudo systemctl set-default graphical.target
            ;;

        ubuntu|debian|pop)
            sudo apt update
            sudo apt install -y sddm qml-module-qtquick-controls2 qml-module-qtgraphicaleffects
            sudo systemctl enable sddm.service
            sudo systemctl set-default graphical.target
            ;;

        nixos)
            log_warning "On NixOS, add to configuration.nix:"
            echo -e "${CYAN}  services.xserver.displayManager.sddm.enable = true;${NC}"
            read -p "Press enter when configured..."
            ;;

        *)
            log_error "Unsupported distribution for SDDM auto-install"
            return 1
            ;;
    esac

    log_success "SDDM installed and enabled"
}

# ═══════════════════════════════════════════════════════════════════════════
#  Configuration Backup
# ═══════════════════════════════════════════════════════════════════════════
backup_configs() {
    log_step "Backing Up Existing Configurations"

    mkdir -p "$BACKUP_DIR"

    DIRS_TO_BACKUP=(
        "hypr" "waybar" "kitty" "fastfetch"
        "wlogout" "rofi" "swaync"
    )

    local backed_up=false

    for dir in "${DIRS_TO_BACKUP[@]}"; do
        if [ -d "$CONFIG_DIR/$dir" ]; then
            log_info "Backing up ${BOLD}$dir${NC}..."
            cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
            backed_up=true
        fi
    done

    if [ -f "$HOME/.zshrc" ]; then
        log_info "Backing up ${BOLD}.zshrc${NC}..."
        cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc"
        backed_up=true
    fi

    if [ "$backed_up" = true ]; then
        log_success "Backup saved to: ${BOLD}$BACKUP_DIR${NC}"
    else
        log_info "No existing configurations to backup"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
#  Repository Cloning
# ═══════════════════════════════════════════════════════════════════════════
clone_repo() {
    log_step "Cloning Hecate Repository"

    if [ -d "$INSTALL_DIR" ]; then
        log_warning "Installation directory exists, removing..."
        rm -rf "$INSTALL_DIR"
    fi

    log_info "Cloning from: ${BOLD}$REPO_URL${NC}"
    git clone "$REPO_URL" "$INSTALL_DIR"
    log_success "Repository cloned to: ${BOLD}$INSTALL_DIR${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════
#  Dotfiles Installation
# ═══════════════════════════════════════════════════════════════════════════
install_dotfiles() {
    log_step "Installing Dotfiles"

    cd "$INSTALL_DIR"

    # Create necessary directories
    mkdir -p "$CONFIG_DIR"/{waybar,kitty,fastfetch}

    # Install Hypr configuration
    if [ -d "config/hypr" ]; then
        log_info "Installing ${BOLD}Hypr${NC} configuration..."
        [ -d "$CONFIG_DIR/hypr" ] && rm -rf "$CONFIG_DIR/hypr"
        cp -r "config/hypr" "$CONFIG_DIR/"
        chmod +x "$CONFIG_DIR/hypr/scripts/"*.sh
        log_success "Hypr installed"
    fi

    # Install wlogout
    if [ -d "config/wlogout" ]; then
        log_info "Installing ${BOLD}wlogout${NC} configuration..."
        [ -d "$CONFIG_DIR/wlogout" ] && rm -rf "$CONFIG_DIR/wlogout"
        cp -r "config/wlogout" "$CONFIG_DIR/"
        log_success "wlogout installed"
    fi

    # Install Waybar with symlinks
    if [ -d "config/waybar" ]; then
        log_info "Installing ${BOLD}Waybar${NC} configuration..."

        [ -d "$CONFIG_DIR/waybar/configs" ] && rm -rf "$CONFIG_DIR/waybar/configs"
        [ -d "$CONFIG_DIR/waybar/style" ] && rm -rf "$CONFIG_DIR/waybar/style"
        [ -d "$CONFIG_DIR/waybar/module" ] && rm -rf "$CONFIG_DIR/waybar/module"

        cp -r "config/waybar/configs" "$CONFIG_DIR/waybar/"
        cp -r "config/waybar/style" "$CONFIG_DIR/waybar/"
        cp -r "config/waybar/module" "$CONFIG_DIR/waybar/"

        # Create symlinks
        [ -L "$CONFIG_DIR/waybar/config" ] && rm "$CONFIG_DIR/waybar/config"
        [ -L "$CONFIG_DIR/waybar/style.css" ] && rm "$CONFIG_DIR/waybar/style.css"

        ln -sf "$CONFIG_DIR/waybar/configs/top" "$CONFIG_DIR/waybar/config"
        ln -sf "$CONFIG_DIR/waybar/style/default.css" "$CONFIG_DIR/waybar/style.css"

        log_success "Waybar installed with symlinks"
    fi

    # Install Kitty
    if [ -f "config/kitty/kitty.conf" ]; then
        log_info "Installing ${BOLD}Kitty${NC} configuration..."
        cp "config/kitty/kitty.conf" "$CONFIG_DIR/kitty/"
        log_success "Kitty installed"
    fi

    # Install Fastfetch
    if [ -f "config/fastfetch/config.jsonc" ]; then
        log_info "Installing ${BOLD}Fastfetch${NC} configuration..."
        cp "config/fastfetch/config.jsonc" "$CONFIG_DIR/fastfetch/"
        log_success "Fastfetch installed"
    fi

    # Install Zsh config
    if [ -f "config/zsh/.zshrc" ]; then
        log_info "Installing ${BOLD}.zshrc${NC} to home directory..."
        [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$BACKUP_DIR/.zshrc.bak"
        cp "config/zsh/.zshrc" "$HOME/"
        log_success ".zshrc installed"
    fi

    log_success "All dotfiles installed successfully"
}

# ═══════════════════════════════════════════════════════════════════════════
#  SDDM Theme Installation
# ═══════════════════════════════════════════════════════════════════════════
install_sddm_theme() {
    log_step "Installing SDDM Astronaut Theme"

    if ! command -v sddm &> /dev/null; then
        log_warning "SDDM not installed, skipping theme"
        return 0
    fi

    read -p "Install SDDM Astronaut Theme? (y/N): " install_theme
    if [[ ! "$install_theme" =~ ^[Yy]$ ]]; then
        log_info "Skipping theme installation"
        return 0
    fi

    log_info "Downloading and installing theme..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

    log_success "SDDM Astronaut theme installed"
}

# ═══════════════════════════════════════════════════════════════════════════
#  Shell Configuration
# ═══════════════════════════════════════════════════════════════════════════
set_zsh_shell() {
    log_step "Configuring Zsh Shell"

    if [ "$SHELL" != "$(which zsh)" ]; then
        log_info "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
        log_success "Zsh set as default shell"
    else
        log_success "Zsh is already the default shell"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
#  Hyprland Plugins Setup
# ═══════════════════════════════════════════════════════════════════════════
install_plugins() {
    log_step "Preparing Hyprland Plugins"

    cat > "$HOME/.hecate-install-plugins.sh" << 'EOF'
#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
#  Hecate - Hyprland Plugins Installer
#  Run this AFTER logging into Hyprland
# ═══════════════════════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}╔═══════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║   Hecate Plugin Installer            ║${NC}"
echo -e "${CYAN}${BOLD}╚═══════════════════════════════════════╝${NC}\n"

# Check if in Hyprland
if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo -e "${RED}[✗] Not running in Hyprland!${NC}"
    echo -e "${YELLOW}Please log into Hyprland first${NC}"
    exit 1
fi

# Check hyprpm
if ! command -v hyprpm &>/dev/null; then
    echo -e "${RED}[✗] hyprpm not found!${NC}"
    exit 1
fi

echo -e "${CYAN}[INFO] Updating Hyprland headers...${NC}"
hyprpm update

echo -e "${CYAN}[INFO] Installing hyprfocus...${NC}"
hyprpm add https://github.com/pyt0xic/hyprfocus || true

echo -e "${CYAN}[INFO] Installing Hyprspace...${NC}"
hyprpm add https://github.com/KZDKM/Hyprspace || true

echo -e "${CYAN}[INFO] Enabling plugins...${NC}"
hyprpm enable hyprfocus || true
hyprpm enable Hyprspace || true

echo -e "${CYAN}[INFO] Reloading Hyprland...${NC}"
hyprpm reload
hyprctl reload

notify-send "Hecate" "Plugins installed successfully! 🎉" || true

echo -e "\n${GREEN}${BOLD}[✓] Plugins installed and enabled!${NC}"
echo -e "${YELLOW}You can now delete this script:${NC}"
echo -e "  rm ~/.hecate-install-plugins.sh\n"
EOF

    chmod +x "$HOME/.hecate-install-plugins.sh"

    log_success "Plugin installer created: ${BOLD}~/.hecate-install-plugins.sh${NC}"
    log_info "Run this script ${BOLD}AFTER${NC} logging into Hyprland"
}

# ═══════════════════════════════════════════════════════════════════════════
#  Main Installation Flow
# ═══════════════════════════════════════════════════════════════════════════
main() {
    print_banner

    echo -e "${YELLOW}${BOLD}This installer will:${NC}"
    echo -e "  ${CYAN}→${NC} Detect your Linux distribution"
    echo -e "  ${CYAN}→${NC} Install/Update Hyprland"
    echo -e "  ${CYAN}→${NC} Install required dependencies"
    echo -e "  ${CYAN}→${NC} Setup SDDM display manager"
    echo -e "  ${CYAN}→${NC} Backup existing configurations"
    echo -e "  ${CYAN}→${NC} Clone and install Hecate dotfiles"
    echo -e "  ${CYAN}→${NC} Install SDDM Astronaut theme"
    echo -e "  ${CYAN}→${NC} Configure shell and plugins\n"

    read -p "$(echo -e ${BOLD}Continue with installation? ${NC}${GREEN}[y/N]${NC}: )" confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_warning "Installation cancelled"
        exit 0
    fi

    echo ""

    # Execute installation steps
    detect_distro

    # Hyprland check and install
    if ! check_hyprland; then
        log_warning "Hyprland not found"
        install_hyprland
    else
        read -p "Update Hyprland? (y/N): " update_hypr
        [[ "$update_hypr" =~ ^[Yy]$ ]] && install_hyprland
    fi

    install_dependencies
    Set_zsh
    setup_sddm
    backup_configs
    clone_repo
    install_dotfiles
    install_sddm_theme
    set_zsh_shell
    install_plugins

    # Success message
    echo ""
    echo -e "${GREEN}${BOLD}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║                                                               ║${NC}"
    echo -e "${GREEN}${BOLD}║              ✨  I N S T A L L A T I O N                      ║${NC}"
    echo -e "${GREEN}${BOLD}║                  C O M P L E T E !                            ║${NC}"
    echo -e "${GREEN}${BOLD}║                                                               ║${NC}"
    echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    log_success "Hecate dotfiles installed successfully!"
    echo ""
    echo -e "${CYAN}${BOLD}Next Steps:${NC}"
    echo -e "  ${CYAN}1.${NC} Log out and log back in"
    echo -e "  ${CYAN}2.${NC} Select ${BOLD}Hyprland${NC} at the login screen"
    echo -e "  ${CYAN}3.${NC} Run: ${BOLD}~/.hecate-install-plugins.sh${NC}"
    echo -e "  ${CYAN}4.${NC} Backup location: ${BOLD}$BACKUP_DIR${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}Resources:${NC}"
    echo -e "  ${CYAN}→${NC} Keybindings: ${BOLD}~/.config/hypr/configs/keybinds.conf${NC}"
    echo -e "  ${CYAN}→${NC} Documentation: ${BOLD}https://github.com/Aelune/Hecate/tree/main/documentation/hyprland/${NC}"
    echo -e "  ${CYAN}→${NC} Repository: ${BOLD}https://github.com/Aelune/hecate${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
#  Execute Main Function
# ═══════════════════════════════════════════════════════════════════════════
main
