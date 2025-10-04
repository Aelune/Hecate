#!/bin/bash

# Hyprland Dotfiles Installer with Gum
# Author: Hecate Dotfiles
# Description: Interactive installer for Hyprland configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global Variables
HECATEDIR="$HOME/Hecate"
CONFIGDIR="$HOME/.config"
REPO_URL="https://github.com/Aelune/Hecate.git"
OS=""
PACKAGE_MANAGER=""

# Check if gum is installed
check_gum() {
    if ! command -v gum &> /dev/null; then
        echo -e "${RED}Gum is not installed!${NC}"
        echo -e "${YELLOW}Gum is required for this installer to work.${NC}"
        echo ""
        echo "Please install Gum using one of the following methods:"
        echo ""
        echo "Arch Linux:"
        echo "  sudo pacman -S gum"
        echo ""
        echo "Fedora:"
        echo "  sudo dnf install gum"
        echo ""
        echo "Ubuntu/Debian:"
        echo "  sudo mkdir -p /etc/apt/keyrings"
        echo "  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg"
        echo "  echo \"deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *\" | sudo tee /etc/apt/sources.list.d/charm.list"
        echo "  sudo apt update && sudo apt install gum"
        echo ""
        echo "Or visit: https://github.com/charmbracelet/gum"
        exit 1
    fi
}

# Check OS
check_OS() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch|manjaro|endeavouros)
                OS="arch"
                ;;
            fedora)
                OS="fedora"
                ;;
            ubuntu|debian|pop|linuxmint)
                OS="ubuntu"
                ;;
            *)
                gum style --foreground 196 --bold "Error: OS '$ID' is not supported!"
                gum style --foreground 220 "Supported: Arch Linux, Fedora, Ubuntu/Debian"
                exit 1
                ;;
        esac
    else
        gum style --foreground 196 --bold "Error: Cannot detect OS!"
        exit 1
    fi
    gum style --foreground 82 "✓ Detected OS: $OS"
}

# Get package manager
get_packageManager() {
    case "$OS" in
        arch)
            if command -v paru &> /dev/null; then
                PACKAGE_MANAGER="paru"
            elif command -v yay &> /dev/null; then
                PACKAGE_MANAGER="yay"
            elif command -v pacman &> /dev/null; then
                PACKAGE_MANAGER="pacman"
            fi
            ;;
        fedora)
            PACKAGE_MANAGER="dnf"
            ;;
        ubuntu)
            if command -v nala &> /dev/null; then
                PACKAGE_MANAGER="nala"
            elif command -v apt &> /dev/null; then
                PACKAGE_MANAGER="apt"
            fi
            ;;
    esac

    if [ -z "$PACKAGE_MANAGER" ]; then
        gum style --foreground 196 "Error: No supported package manager found!"
        exit 1
    fi

    gum style --foreground 82 "✓ Package Manager: $PACKAGE_MANAGER"
}

# Download dependencies
download_Deps() {
    gum style --border double --padding "1 2" --border-foreground 212 "Installing Dependencies"

    local base_deps=""

    case "$PACKAGE_MANAGER" in
        paru|yay)
            base_deps="base-devel git wget curl unzip hyprland waybar rofi-wayland dunst kitty fastfetch btop"
            gum style --foreground 220 "Installing base dependencies with $PACKAGE_MANAGER..."
            echo ""
            $PACKAGE_MANAGER -S --needed $base_deps
            ;;
        pacman)
            # Install paru first
            if ! command -v paru &> /dev/null; then
                gum style --foreground 220 "Installing paru AUR helper..."
                cd /tmp
                git clone https://aur.archlinux.org/paru.git
                cd paru
                makepkg -si
                cd "$HOME"
                PACKAGE_MANAGER="paru"
            fi
            base_deps="base-devel git wget curl unzip hyprland waybar rofi-wayland dunst kitty fastfetch btop"
            gum style --foreground 220 "Installing base dependencies with paru..."
            echo ""
            paru -S --needed $base_deps
            ;;
        dnf)
            base_deps="git wget curl unzip hyprland waybar rofi dunst kitty fastfetch btop"
            gum style --foreground 220 "Installing base dependencies..."
            echo ""
            sudo dnf install -y $base_deps
            ;;
        apt)
            # Install nala if not present
            if ! command -v nala &> /dev/null; then
                gum style --foreground 220 "Installing nala..."
                sudo apt update
                sudo apt install -y nala
                PACKAGE_MANAGER="nala"
            fi
            base_deps="git wget curl unzip build-essential kitty fastfetch btop"
            gum style --foreground 220 "Updating repositories..."
            sudo nala update
            echo ""
            gum style --foreground 220 "Installing base dependencies..."
            sudo nala install -y $base_deps
            ;;
        nala)
            base_deps="git wget curl unzip build-essential kitty fastfetch btop"
            gum style --foreground 220 "Updating repositories..."
            sudo nala update
            echo ""
            gum style --foreground 220 "Installing base dependencies..."
            sudo nala install -y $base_deps
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo ""
        gum style --foreground 82 "✓ Dependencies installed successfully!"
    else
        echo ""
        gum style --foreground 196 "✗ Error installing dependencies!"
        exit 1
    fi
}

# Clone dotfiles
clone_dotfiles() {
    gum style --border double --padding "1 2" --border-foreground 212 "Cloning Hecate Dotfiles"

    if [ -d "$HECATEDIR" ]; then
        if gum confirm "Hecate directory already exists. Remove and re-clone?"; then
            rm -rf "$HECATEDIR"
        else
            gum style --foreground 220 "Using existing directory..."
            return
        fi
    fi

    gum style --foreground 220 "Cloning repository..."
    git clone "$REPO_URL" "$HECATEDIR"

    if [ $? -eq 0 ]; then
        gum style --foreground 82 "✓ Dotfiles cloned successfully!"
    else
        gum style --foreground 196 "✗ Error cloning repository!"
        exit 1
    fi
}

# Backup config
backup_config() {
    gum style --border double --padding "1 2" --border-foreground 212 "Backing Up Existing Configs"

    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$HOME/.config_backup_$timestamp"

    if [ -d "$HECATEDIR/config" ]; then
        mkdir -p "$backup_dir"

        for folder in "$HECATEDIR/config"/*; do
            if [ -d "$folder" ]; then
                local folder_name=$(basename "$folder")
                if [ -d "$CONFIGDIR/$folder_name" ]; then
                    gum style --foreground 220 "Backing up: $folder_name"
                    cp -r "$CONFIGDIR/$folder_name" "$backup_dir/"
                fi
            fi
        done

        gum style --foreground 82 "✓ Backup created at: $backup_dir"
    fi
}

# Move config files
move_config() {
    gum style --border double --padding "1 2" --border-foreground 212 "Installing Configuration Files"

    if [ ! -d "$HECATEDIR/config" ]; then
        gum style --foreground 196 "Error: Config directory not found!"
        exit 1
    fi

    mkdir -p "$CONFIGDIR"

    for folder in "$HECATEDIR/config"/*; do
        if [ -d "$folder" ]; then
            local folder_name=$(basename "$folder")

            case "$folder_name" in
                zsh)
                    if [ -f "$folder/.zshrc" ]; then
                        gum style --foreground 82 "Installing .zshrc..."
                        cp "$folder/.zshrc" "$HOME/.zshrc"
                    fi
                    ;;
                bash)
                    if [ -f "$folder/.bashrc" ]; then
                        gum style --foreground 82 "Installing .bashrc..."
                        cp "$folder/.bashrc" "$HOME/.bashrc"
                    fi
                    ;;
                fish)
                    gum style --foreground 82 "Installing fish config..."
                    mkdir -p "$CONFIGDIR/fish"
                    cp -r "$folder/"* "$CONFIGDIR/fish/"
                    ;;
                *)
                    gum style --foreground 82 "Installing $folder_name..."
                    rm -rf "$CONFIGDIR/$folder_name"
                    cp -r "$folder" "$CONFIGDIR/"
                    ;;
            esac
        fi
    done

    gum style --foreground 82 "✓ Configuration hyprland dotfiles installed...!"
    gum style --foreground 82 "Oh wait a sec it need some configuration...!"

}

setup_Waybar(){
    gum style --foreground 82 "Configuring waybar..."
    ln -s $HOME/.config/waybar/configs/top $HOME/.config/waybar/config
    ln -s $HOME/.config/waybar/style/default.css $HOME/.config/waybar/style.css
    gum style --foreground 82 "✓ Waybar configured...!"
}

# Setup Zsh
setup_zsh() {
    gum style --border double --padding "1 2" --border-foreground 212 "Setting Up Zsh"

    local packages="zsh fzf bat exa fd thefuck"

    gum style --foreground 220 "Installing Zsh packages..."
    echo ""

    case "$PACKAGE_MANAGER" in
        paru|yay|pacman)
            sudo $PACKAGE_MANAGER -S --needed $packages
            ;;
        dnf)
            sudo dnf install -y zsh fzf bat exa fd-find thefuck
            ;;
        nala|apt)
            sudo $PACKAGE_MANAGER install -y zsh fzf bat exa fd-find thefuck
            ;;
    esac

    echo ""

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        gum style --foreground 220 "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install Powerlevel10k
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        gum style --foreground 220 "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi

    # Install plugins
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        gum style --foreground 220 "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        gum style --foreground 220 "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    echo ""

    # Set zsh as default shell
    if gum confirm "Set Zsh as default shell?"; then
        chsh -s $(which zsh)
        gum style --foreground 82 "✓ Zsh set as default shell!"
    fi

    gum style --foreground 82 "✓ Zsh setup complete!"
}

# Setup Bash
setup_bash() {
    gum style --border double --padding "1 2" --border-foreground 212 "Setting Up Bash"

    local packages="bash curl wget git unzip fzf fd bat exa kitty fastfetch thefuck net-tools"

    gum style --foreground 220 "Installing Bash packages..."
    echo ""

    case "$PACKAGE_MANAGER" in
        paru|yay|pacman)
            sudo $PACKAGE_MANAGER -S --needed $packages
            ;;
        dnf)
            sudo dnf install -y bash curl wget git unzip fzf fd-find bat exa kitty fastfetch thefuck net-tools
            ;;
        nala|apt)
            sudo $PACKAGE_MANAGER install -y bash curl wget git unzip fzf fd-find bat exa kitty fastfetch thefuck net-tools
            ;;
    esac

    echo ""
    gum style --foreground 82 "✓ Bash setup complete!"
}

# Setup Fish
setup_fish() {
    gum style --border double --padding "1 2" --border-foreground 212 "Setting Up Fish"

    local packages="fish fzf bat exa thefuck net-tools"

    gum style --foreground 220 "Installing Fish packages..."
    echo ""

    case "$PACKAGE_MANAGER" in
        paru|yay|pacman)
            sudo $PACKAGE_MANAGER -S --needed $packages fd fisher
            ;;
        dnf)
            sudo dnf install -y fish fzf fd-find bat exa thefuck net-tools procps-ng coreutils
            ;;
        nala|apt)
            sudo $PACKAGE_MANAGER install -y fish fzf fd-find bat exa thefuck net-tools procps coreutils
            ;;
    esac

    echo ""

    # Install fisher
    if ! fish -c "type -q fisher" 2>/dev/null; then
        gum style --foreground 220 "Installing Fisher..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    fi

    echo ""

    # Set fish as default shell
    if gum confirm "Set Fish as default shell?"; then
        chsh -s $(which fish)
        gum style --foreground 82 "✓ Fish set as default shell!"
    fi

    gum style --foreground 82 "✓ Fish setup complete!"
}

# Setup Shell
setup_Shell() {
    gum style --border double --padding "1 2" --border-foreground 212 "Shell Configuration"

    local shell_choice=$(gum choose "zsh" "bash" "fish" --header "Choose your shell:")

    case "$shell_choice" in
        zsh)
            setup_zsh
            ;;
        bash)
            setup_bash
            ;;
        fish)
            setup_fish
            ;;
    esac
}

# Developer setup
developer_setup() {
    gum style --border double --padding "1 2" --border-foreground 212 "Developer Setup"

    local dev_types=$(gum choose --no-limit --header "Select development areas (space to select, enter to confirm):" \
        "AI/ML" \
        "Web Development" \
        "Server/Backend" \
        "Database" \
        "Mobile Development" \
        "DevOps" \
        "Game Development")

    local packages=""

    if echo "$dev_types" | grep -q "AI/ML"; then
        packages="$packages python python-pip python-pytorch python-numpy jupyter-notebook"
    fi

    if echo "$dev_types" | grep -q "Web Development"; then
        packages="$packages nodejs npm yarn"
    fi

    if echo "$dev_types" | grep -q "Server/Backend"; then
        packages="$packages docker docker-compose postgresql mysql"
    fi

    if echo "$dev_types" | grep -q "Database"; then
        packages="$packages postgresql mysql sqlite redis"
    fi

    if echo "$dev_types" | grep -q "Mobile Development"; then
        packages="$packages android-tools"
    fi

    if echo "$dev_types" | grep -q "DevOps"; then
        packages="$packages docker docker-compose kubectl terraform ansible"
    fi

    if echo "$dev_types" | grep -q "Game Development"; then
        packages="$packages godot blender"
    fi

    # Show selected packages
    gum style --foreground 220 "Packages to install: $packages"

    if gum confirm "Proceed with installation?"; then
        echo ""
        case "$PACKAGE_MANAGER" in
            paru|yay)
                $PACKAGE_MANAGER -S --needed $packages
                ;;
            pacman)
                sudo pacman -S --needed $packages
                ;;
            dnf)
                sudo dnf install -y $packages
                ;;
            nala|apt)
                sudo $PACKAGE_MANAGER install -y $packages
                ;;
        esac

        echo ""
        gum style --foreground 82 "✓ Developer tools installed!"
    fi

    # Allow custom packages
    if gum confirm "Add additional packages?"; then
        local custom_packages=$(gum input --placeholder "Enter package names (space-separated)")
        echo ""
        case "$PACKAGE_MANAGER" in
            paru|yay)
                $PACKAGE_MANAGER -S --needed $custom_packages
                ;;
            pacman)
                sudo pacman -S --needed $custom_packages
                ;;
            dnf)
                sudo dnf install -y $custom_packages
                ;;
            nala|apt)
                sudo $PACKAGE_MANAGER install -y $custom_packages
                ;;
        esac
    fi
}

# Gamer setup
gamer_setup() {
    gum style --border double --padding "1 2" --border-foreground 212 "Gamer Setup"

    local packages="steam lutris wine-staging gamemode lib32-gamemode mangohud lib32-mangohud"

    gum style --foreground 220 "Installing gaming packages..."
    echo ""

    case "$PACKAGE_MANAGER" in
        paru|yay)
            $PACKAGE_MANAGER -S --needed $packages discord
            ;;
        pacman)
            sudo pacman -S --needed $packages
            ;;
        dnf)
            sudo dnf install -y steam lutris wine discord gamemode
            ;;
        nala|apt)
            sudo $PACKAGE_MANAGER install -y steam lutris wine discord gamemode
            ;;
    esac

    echo ""

    if gum confirm "Install emulators?"; then
        local emulators=$(gum choose --no-limit --header "Select emulators:" \
            "RetroArch" \
            "PCSX2 (PS2)" \
            "Dolphin (GameCube/Wii)" \
            "RPCS3 (PS3)" \
            "Yuzu (Switch)" \
            "Cemu (Wii U)")

        local emu_packages=""

        echo "$emulators" | grep -q "RetroArch" && emu_packages="$emu_packages retroarch"
        echo "$emulators" | grep -q "PCSX2" && emu_packages="$emu_packages pcsx2"
        echo "$emulators" | grep -q "Dolphin" && emu_packages="$emu_packages dolphin-emu"
        echo "$emulators" | grep -q "RPCS3" && emu_packages="$emu_packages rpcs3"
        echo "$emulators" | grep -q "Yuzu" && emu_packages="$emu_packages yuzu"
        echo "$emulators" | grep -q "Cemu" && emu_packages="$emu_packages cemu"

        echo ""

        case "$PACKAGE_MANAGER" in
            paru|yay)
                $PACKAGE_MANAGER -S --needed $emu_packages
                ;;
            *)
                gum style --foreground 220 "Some emulators may not be available for your distro"
                ;;
        esac
    fi

    echo ""
    gum style --foreground 82 "✓ Gaming setup complete!"
}

# Madlad setup
madlad_Setup() {
    gum style --border double --padding "1 2" --border-foreground 212 "Madlad Setup (Developer + Gamer)"
    developer_setup
    gamer_setup
}

# User profile
User_Profile() {
    gum style --border double --padding "1 2" --border-foreground 212 "User Profile Selection"

    local profile=$(gum choose --header "Select your profile:" \
        "minimal (default)" \
        "developer" \
        "gamer" \
        "madlad (dev + gamer)")

    case "$profile" in
        "developer")
            developer_setup
            ;;
        "gamer")
            gamer_setup
            ;;
        "madlad (dev + gamer)")
            madlad_Setup
            ;;
        *)
            gum style --foreground 82 "✓ Minimal setup selected"
            ;;
    esac
}

# Set SDDM
set_Sddm() {
    if gum confirm "Switch to SDDM login manager?"; then
        gum style --border double --padding "1 2" --border-foreground 212 "Installing SDDM"

        case "$PACKAGE_MANAGER" in
            paru|yay|pacman)
                sudo pacman -S --noconfirm sddm
                sudo systemctl enable sddm
                sudo systemctl set-default graphical.target
                ;;
            dnf)
                sudo dnf install -y sddm
                sudo systemctl enable sddm
                sudo systemctl set-default graphical.target
                ;;
            nala|apt)
                sudo $PACKAGE_MANAGER install -y sddm
                sudo systemctl enable sddm
                sudo systemctl set-default graphical.target
                ;;
        esac

        gum style --foreground 82 "✓ SDDM installed and enabled!"
    fi
}

# Set SDDM theme
set_Sddm_Theme() {
    if gum confirm "Install SDDM Astronaut theme?"; then
        gum spin --spinner dot --title "Installing SDDM theme..." -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
        gum style --foreground 82 "✓ SDDM theme installed!"
    fi
}

# Install Hyprland plugins
install_hyprland_plugins() {
    gum style --border double --padding "1 2" --border-foreground 212 "Installing Hyprland Plugins"

    if ! command -v hyprpm &> /dev/null; then
        gum style --foreground 220 "Installing hyprpm..."
        case "$PACKAGE_MANAGER" in
            paru|yay)
                $PACKAGE_MANAGER -S --noconfirm hyprpm
                ;;
            *)
                gum style --foreground 196 "hyprpm not available for this distro"
                return
                ;;
        esac
    fi

    local plugins=$(gum choose --no-limit --header "Select Hyprland plugins:" \
        "hyprland-plugins" \
        "hy3" \
        "hyprexpo" \
        "Skip")

    if echo "$plugins" | grep -q "Skip"; then
        return
    fi

    echo "$plugins" | while read -r plugin; do
        [ -n "$plugin" ] && gum spin --spinner dot --title "Installing $plugin..." -- hyprpm add "$plugin"
    done

    gum style --foreground 82 "✓ Hyprland plugins installed!"
}

# Set GRUB theme
setGrub_Theme() {
    if [ ! -d "/boot/grub" ] && [ ! -d "/boot/grub2" ]; then
        gum style --foreground 220 "GRUB not detected, skipping..."
        return
    fi

    if gum confirm "Install a GRUB theme?"; then
        gum style --border double --padding "1 2" --border-foreground 212 "GRUB Themes"

        local theme=$(gum choose --header "Select GRUB theme:" \
            "Catppuccin" \
            "Dracula" \
            "Nordic" \
            "Cyberpunk" \
            "Skip")

        case "$theme" in
            "Catppuccin")
                git clone https://github.com/catppuccin/grub.git /tmp/grub-theme
                sudo cp -r /tmp/grub-theme/src/* /boot/grub/themes/
                ;;
            "Dracula")
                git clone https://github.com/dracula/grub.git /tmp/grub-theme
                sudo mkdir -p /boot/grub/themes/dracula
                sudo cp -r /tmp/grub-theme/* /boot/grub/themes/dracula/
                ;;
            "Nordic")
                git clone https://github.com/Lxtharia/minegrub-theme.git /tmp/grub-theme
                cd /tmp/grub-theme
                sudo ./install.sh
                ;;
            "Cyberpunk")
                git clone https://github.com/VandalByte/grub2-cyberpunk.git /tmp/grub-theme
                cd /tmp/grub-theme
                sudo ./install.sh
                ;;
            *)
                return
                ;;
        esac

        sudo grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || sudo grub2-mkconfig -o /boot/grub2/grub.cfg
        gum style --foreground 82 "✓ GRUB theme installed!"
    fi
}

# Main function
main() {
    clear

    # Check for gum first
    check_gum

    # Welcome banner
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        'HECATE DOTFILES' 'Hyprland Configuration Installer' ''

    gum style --foreground 220 "Starting installation process..."
    sleep 1

    # Run installation steps
    check_OS
    get_packageManager
    download_Deps
    clone_dotfiles
    backup_config
    move_config
    setup_Waybar
    setup_Shell
    User_Profile
    install_hyprland_plugins
    set_Sddm
    set_Sddm_Theme
    setGrub_Theme

    # Completion message
    gum style \
        --foreground 82 --border-foreground 82 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        '✓ Installation Complete!' '' 'Please reboot your system to apply all changes.'

    if gum confirm "Reboot now?"; then
        sudo reboot
    fi
}

# Run main function
main
