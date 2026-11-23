#!/bin/bash
set -e
echo "🔧 Installing base tools..."

sudo apt update
sudo apt install -y \
  git curl wget unzip \
  xwayland wl-clipboard \
  swaybg waybar alacritty wofi dunst

echo "✅ Base tools installed successfully!"
