#!/bin/bash
set -e
echo "🎨 Applying current desktop theme to GTK apps..."

# Same theme as the existing GNOME setup
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-theme-name=material-gnome-theme
gtk-icon-theme-name=Yaru-prussiangreen-dark
gtk-font-name=Ubuntu Nerd Font 11
gtk-cursor-theme-name=DMZ-Black
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

mkdir -p ~/.config/gtk-4.0
cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
