#!/bin/bash
set -e
echo "🔧 Installing packages..."

sudo apt update

# Base tools and Wayland utilities
sudo apt install -y \
  git curl wget unzip rsync jq bc ripgrep yq \
  xwayland wl-clipboard qtwayland5 qt6-wayland \
  grim slurp swappy wf-recorder wtype ydotool cliphist \
  brightnessctl playerctl pavucontrol pavucontrol-qt ddcutil upower \
  network-manager-gnome gnome-keyring geoclue-2.0 xdg-user-dirs \
  xdg-desktop-portal-gtk xdg-desktop-portal-kde \
  imagemagick tesseract-ocr tesseract-ocr-eng translate-shell qalc \
  pipx python3-dev python3-venv

# Apps and shell tools used by the config and keybinds
sudo apt install -y \
  alacritty kitty nautilus rofi fuzzel wlogout cava btop easyeffects \
  fish zsh starship eza kdialog

# Fonts, icons and Qt theme
sudo apt install -y \
  fonts-jetbrains-mono fonts-noto-color-emoji fonts-font-awesome \
  breeze breeze-icon-theme qt6-image-formats-plugins qt6-svg-plugins \
  qt6-virtualkeyboard-plugin qt6-translations-l10n

# Quickshell build dependencies
sudo apt install -y \
  build-essential cmake ninja-build pkg-config clang \
  qt6-base-dev qt6-base-private-dev qt6-declarative-dev qt6-declarative-private-dev \
  qt6-shadertools-dev qt6-wayland-dev qt6-wayland-private-dev qt6-svg-dev \
  qt6-5compat-dev qt6-multimedia-dev \
  libcli11-dev spirv-tools libvulkan-dev wayland-protocols libwayland-dev \
  libdrm-dev libgbm-dev libxcb1-dev libglib2.0-dev libpipewire-0.3-dev \
  libjemalloc-dev libpam0g-dev libpolkit-agent-1-dev libpolkit-gobject-1-dev \
  libdwarf-dev libunwind-dev libcairo2-dev libdbus-1-dev \
  gobject-introspection libgirepository-2.0-dev gir1.2-gtk-4.0 libdbusmenu-gtk3-4

# QML modules the illogical-impulse shell imports at runtime
sudo apt install -y \
  qml6-module-qtquick qml6-module-qtquick-controls qml6-module-qtquick-layouts \
  qml6-module-qtquick-window qml6-module-qtquick-shapes qml6-module-qtquick-effects \
  qml6-module-qtquick-dialogs qml6-module-qtquick-templates qml6-module-qtquick-timeline \
  qml6-module-qtquick-particles qml6-module-qtquick-virtualkeyboard \
  qml6-module-qtqml-workerscript qml6-module-qtcore qml6-module-qtmultimedia \
  qml6-module-qtpositioning qml6-module-qtsensors qml6-module-qtwayland-compositor \
  qml6-module-qt5compat-graphicaleffects qml6-module-qt-labs-platform \
  qml6-module-qt-labs-folderlistmodel \
  qml6-module-org-kde-kirigami qml6-module-org-kde-syntaxhighlighting

echo "✅ Packages installed successfully!"
