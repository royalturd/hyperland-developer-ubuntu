#!/bin/bash
set -e
# Install the desktop configuration from dots/ (captured with ./snapshot.sh).
# Anything it replaces is backed up first.

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DOTS="$REPO_DIR/dots"
BACKUP="$HOME/.config-backup-hyprland-$(date +%Y%m%d-%H%M%S)"

# Copy src to dest, backing up dest if it exists, then swap @HOME@ for $HOME.
install_dot() { # src dest
  local src="$1" dest="$2"
  if [ -e "$dest" ]; then
    mkdir -p "$BACKUP/$(dirname "${dest#$HOME/}")"
    cp -a "$dest" "$BACKUP/${dest#$HOME/}"
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -d "$src" ]; then
    rsync -a --delete "$src/" "$dest/"
  else
    cp -a "$src" "$dest"
  fi
  grep -rlI --null '@HOME@' "$dest" 2>/dev/null | xargs -0 -r sed -i "s|@HOME@|$HOME|g"
}

echo "🧾 Installing config files..."
for item in "$DOTS"/config/*; do
  install_dot "$item" "$HOME/.config/$(basename "$item")"
done
chmod +x "$HOME"/.config/hypr/hyprland/scripts/*.sh "$HOME"/.config/hypr/hyprland/scripts/ai/*.sh \
  "$HOME"/.config/hypr/hyprlock/*.sh "$HOME"/.config/hypr/custom/scripts/*.sh 2>/dev/null || true
find "$HOME/.config/quickshell" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

echo "🎨 Installing generated colours, icon and QML stub..."
install_dot "$DOTS/state/quickshell/user/generated" "$HOME/.local/state/quickshell/user/generated"
install_dot "$DOTS/local/share/icons/illogical-impulse.svg" "$HOME/.local/share/icons/illogical-impulse.svg"
install_dot "$DOTS/local/lib/qt6/qml/QtQuick/Controls/FluentWinUI3" \
  "$HOME/.local/lib/qt6/qml/QtQuick/Controls/FluentWinUI3"

echo "🖼️  Installing wallpapers..."
mkdir -p "$HOME/Pictures/Wallpapers"
for w in "$DOTS"/wallpapers/*; do
  [ -e "$w" ] && cp --update=none "$w" "$HOME/Pictures/Wallpapers/"
done

# zsh: terminal colours follow the wallpaper
if [ -f "$HOME/.zshrc" ] && ! grep -q 'zshrc.d/dots-hyprland.zsh' "$HOME/.zshrc"; then
  printf '\n# end-4 (illogical-impulse): terminal colours follow the wallpaper\n[ -f ~/.config/zshrc.d/dots-hyprland.zsh ] && source ~/.config/zshrc.d/dots-hyprland.zsh\n' >> "$HOME/.zshrc"
fi

# GTK / GNOME settings read by GTK apps under Hyprland
if command -v gsettings >/dev/null; then
  gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface font-name 'Google Sans Flex Medium 11 @opsz=11,wght=500'
  gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
  gsettings set org.gnome.desktop.interface cursor-size 24
  gsettings set org.gnome.desktop.interface icon-theme 'breeze-dark'
fi

[ -d "$BACKUP" ] && echo "ℹ️  Replaced files were backed up to $BACKUP"
echo "✅ Dotfiles installed!"
