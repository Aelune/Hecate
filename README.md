<div align="center">

# 🌙 Hecate
<!-- <img src="assets/img/header.webp" alt="Header"/> -->
### ✦ Dotfiles for hyprland like never before
<!-- *Experience Hyprland with intelligent theming that adapts to your wallpaper* -->

[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Hyprland](https://img.shields.io/badge/Hyprland-Dynamic-5e81ac?logo=wayland)](https://hyprland.org)
[![Made with Love](https://img.shields.io/badge/Made%20with-♥-ff69b4.svg)](https://dwukn.vercel.app)

<!-- ![Hecate Banner](https://via.placeholder.com/1200x300/1a1b26/c0caf5?text=Hecate+%E2%80%A2+Dynamic+Hyprland+Setup) -->



<!-- [Features](#-features) • [Installation](#-installation) • [Configuration](#-configuration) • [Supported Apps](#-supported-applications) • [Contributing](#-contributing) -->

</div>

---

## DEMO

### Installation
<img src="assets/gifs/hecate-install.gif" alt="Installation Demo" width="600"/>

### Usage
<img src="assets/gifs/hecate-demo.gif" alt="Usage Demo" width="600"/>


<!-- ### Auto generates pallet
![Installation and Usage Demo](assets/gifs/palette.png) -->

## 🌟 Features

<table>
<tr>
<td width="50%">

### 🎨 **Dynamic Theming**
Hecate automatically extracts colors from your wallpaper and applies them across your entire system. Watch your interface transform with every wallpaper change.

### 🚀 **Smart Installation**
Interactive setup that asks for your preferences upfront - so less editing config files manuall 🤌

### 🔧 **Multi-Shell Support**
Choose your preferred shell during installation:
- Bash
- Zsh
- Fish

</td>
<td width="50%">

### 🖥️ **Multiple Terminals**
Support for your favorite terminal emulator:
- Alacritty
- Kitty
- Foot
- Ghostty

### 💾 **Safe Backups**
Automatically backs up your existing configurations before making any changes.

### 📦 **All-in-One Setup**
Single command installation with intelligent package management detection.

</td>
</tr>
</table>

---

## 🎯 Supported Applications

Hecate provides beautiful, coordinated configurations for:

<div align="center">

| Category | Applications |
|----------|-------------|
| **Compositors** | Hyprland |
| **Terminals** | Alacritty • Kitty • Foot • Ghostty |
| **Shells** | Bash • Zsh • Fish |
| **Bars** | Waybar |
| **Notifications** | SwayNC |
| **Launchers** | Rofi |
| **Logout** | Wlogout |
| **Wallpapers** | Waypaper • Wallust |
| **System Info** | Fastfetch |

</div>

---

## 📦 Installation

### Prerequisites

> [!Note]
> Hecate will detect your package manager automatically (pacman, yay, paru)
> if paru is installed on system the script selects paru to install packages

```bash
# Ensure you have git and gum installed
sudo pacman -S git gum
```

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/Aelune/Hecate/main/install.sh | bash
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/Aelune/Hecate.git
cd Hecate

# Make the installer executable
chmod +x install.sh

# Run the installer
./install.sh
```

## ⚙️ Configuration

### Hecate Configuration File

Hecate stores your preferences in `~/.config/hecate/hecate.toml`:

```toml
[metadata]
version = "0.3.4"
install_date = "2025-01-01"
last_update = "2025-01-01"
repo_url = "https://github.com/Aelune/Hecate.git"

[theme]
# Theme mode: "dynamic" or "static"
# dynamic: Automatically updates system colors when wallpaper changes
# static: Keeps colors unchanged regardless of wallpaper
mode = "dynamic"
```

### Theme Modes

<table>
<tr>
<td width="50%">

#### 🌈 Dynamic Mode (Default)
```toml
[theme]
mode = "dynamic"
```
- Colors automatically extracted from wallpaper
- Real-time updates across all applications
- Seamless visual harmony

</td>
<td width="50%">

#### 🎨 Static Mode
```toml
[theme]
mode = "static"
```
- Fixed color scheme
- Manual theme changes only
- Predictable appearance

</td>
</tr>
</table>

### Customization

All configuration files are located in `~/.config/`:

```
~/.config/
├── hypr/           # Hyprland configuration
├── waybar/         # Status bar configuration
├── rofi/           # Application launcher
├── swaync/         # Notification center
├── wlogout/        # Logout menu
├── alacritty/      # Terminal configs
├── kitty/
├── foot/
└── hecate/         # Hecate main config
```

---

## 🎨 Dynamic Theming in Action

Hecate uses **Wallust** to intelligently extract colors from your wallpaper and applies them to:

- **Rofi** - Application launcher themes
- **Waybar** - Status bar colors
- **SwayNC** - Notification styling
- **Wlogout** - Logout menu appearance

Simply change your wallpaper, and watch your entire desktop environment transform!

---

## 🔨 Post-Installation

 Setup your wallpaper by pressing  `SUPER+CTRL+W` and see the magic happen

> [!NOTE]
> Hyprland Plugin's have been removed from the system cause they break system when hyprland is updated

<!-- After installation, Hecate creates a plugin installer script:

```bash
# Install additional shell plugins
~/.config/hecate/install_plugins.sh
```

### Updating Hecate

```bash
# Navigate to Hecate directory
cd ~/Hecate

# Pull latest changes
git pull

# Re-run installer (your configs will be preserved)
./install.sh
``` -->

---

## 🎯 Keybindings

Hecate automatically generates keybindings based on your preferred applications:

| Key Combination | Action |
|----------------|--------|
| `SUPER + Return` | Open Terminal |
| `SUPER + D` | Application Launcher (Rofi) |
| `SUPER + Q` | Close Window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + N` | Toggle Notifications |

> **Note:** Full keybinding list available in `~/.config/hypr/keybinds.conf`

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. 🍴 Fork the repository
2. 🔧 Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push to the branch (`git push origin feature/AmazingFeature`)
5. 🎉 Open a Pull Request

### Adding New Applications

Want to add support for more applications? Check out our [Contributing Guide](CONTRIBUTING.md) for details on:
- Adding new terminal emulators
- Supporting additional shells
- Integrating new theme components

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<!-- ## 🙏 Acknowledgments

- [Hyprland](https://hyprland.org) - Amazing wayland compositor
- [Wallust](https://github.com/explosion-mental/wallust) - Color palette generation
- All the amazing developers of the supported applications -->

---

<div align="center">

### 🌙 Hecate - *Transform Your Desktop*

**[⭐ Star this repo](https://github.com/Aelune/Hecate)** if you find it useful!

Made with ♥ by [Aelune](https://github.com/Aelune)

<sub>*Hecate - Greek goddess of magic, crossroads, and transformation*</sub>

</div>
