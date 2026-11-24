#!/bin/bash
set -e
echo "🌌 Installing Hyprland and the Hypr tools from apt..."
sudo apt install -y \
  hyprland xdg-desktop-portal-hyprland hyprland-qtutils \
  hyprpolkitagent hyprlock hypridle hyprpicker

# The package ships its own login session (/usr/share/wayland-sessions/hyprland.desktop).
# The Hyprland config itself is installed by scripts/05-dotfiles.sh.

echo "✅ Hyprland installed!"
