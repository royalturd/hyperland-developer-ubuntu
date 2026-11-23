#!/bin/bash
echo "🎨 Aplicando personalização visual..."

# GTK Settings
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
gtk-icon-theme-name=Papirus
gtk-font-name=JetBrainsMono Nerd Font 10
gtk-cursor-theme-name=Adwaita
EOF

mkdir -p ~/.config/gtk-4.0
cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
