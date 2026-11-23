#!/bin/bash
set -e
echo "🌌 Installing Hyprland from apt..."
sudo apt install -y hyprland xdg-desktop-portal-hyprland

# The package ships its own login session (/usr/share/wayland-sessions/hyprland.desktop).

echo "🧾 Setting up Hyprland config..."
mkdir -p ~/.config/hypr
if [ ! -f ~/.config/hypr/hyprland.conf ]; then
  cp /usr/share/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
else
  echo "ℹ️  ~/.config/hypr/hyprland.conf already exists, leaving it untouched."
fi
