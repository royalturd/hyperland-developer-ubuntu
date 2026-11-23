#!/bin/bash
set -e
echo "🔧 Installing base tools..."

sudo apt update
sudo apt install -y \
  git curl wget unzip \
  xwayland wl-clipboard qtwayland5 qt6-wayland \
  swaybg waybar alacritty wofi dunst \
  grim slurp cliphist \
  brightnessctl playerctl pavucontrol network-manager-gnome \
  fonts-font-awesome

echo "✅ Base tools installed successfully!"
