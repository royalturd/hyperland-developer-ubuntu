#!/bin/bash
set -e
echo "🌌 Installing Hyprland from apt..."
sudo apt install -y \
  hyprland xdg-desktop-portal-hyprland hyprland-qtutils \
  hyprpolkitagent hyprpaper hyprlock hypridle

# The package ships its own login session (/usr/share/wayland-sessions/hyprland.desktop).

echo "🧾 Setting up Hyprland config..."
mkdir -p ~/.config/hypr
if [ ! -f ~/.config/hypr/hyprland.conf ]; then
  cp /usr/share/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
else
  echo "ℹ️  ~/.config/hypr/hyprland.conf already exists, keeping it."
fi

# The stock config points at kitty, dolphin and hyprlauncher, none of which
# are installed. Switch them to the apps this setup installs. Only the exact
# stock values are replaced, so custom choices are kept.
sed -i \
  -e 's|^\$terminal = kitty$|$terminal = alacritty|' \
  -e 's|^\$fileManager = dolphin$|$fileManager = nautilus|' \
  -e 's|^\$menu = hyprlauncher$|$menu = wofi --show drun|' \
  ~/.config/hypr/hyprland.conf
