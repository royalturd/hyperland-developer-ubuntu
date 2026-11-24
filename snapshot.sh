#!/bin/bash
# Copy the live desktop configuration into dots/ so the install scripts can
# reproduce it on another machine. Run this after changing your setup, then
# commit the result.
#
# Paths under your home directory are stored as @HOME@ and turned back into
# the real home directory by scripts/05-dotfiles.sh.
set -e

cd "$(dirname "$0")"
DOTS="$PWD/dots"

# ~/.config entries that make up the desktop
CONFIGS=(
  hypr quickshell illogical-impulse
  fish fuzzel kitty foot alacritty btop cava
  matugen wlogout xdg-desktop-portal fontconfig
  kde-material-you-colors Kvantum zshrc.d
  gtk-3.0 gtk-4.0
  starship.toml kdeglobals
)

EXCLUDES=(
  --exclude '*.bak' --exclude '*.bak-*' --exclude '*.bak~' --exclude '*.[0-9]*.bak'
  --exclude '.git' --exclude 'btop.log' --exclude 'gtk-3.0/bookmarks'
)

rm -rf "$DOTS/config"
mkdir -p "$DOTS/config"
for c in "${CONFIGS[@]}"; do
  if [ -e "$HOME/.config/$c" ]; then
    rsync -a "${EXCLUDES[@]}" "$HOME/.config/$c" "$DOTS/config/"
  else
    echo "⚠️  ~/.config/$c not found, skipped"
  fi
done

# Colours generated from the wallpaper, so the first login already matches
rm -rf "$DOTS/state"
mkdir -p "$DOTS/state/quickshell/user"
rsync -a "$HOME/.local/state/quickshell/user/generated" "$DOTS/state/quickshell/user/"

# Shell icon and the FluentWinUI3 stub QML module (Ubuntu's Qt lacks it)
mkdir -p "$DOTS/local/share/icons" "$DOTS/local/lib/qt6/qml/QtQuick/Controls"
cp "$HOME/.local/share/icons/illogical-impulse.svg" "$DOTS/local/share/icons/"
rsync -a "$HOME/.local/lib/qt6/qml/QtQuick/Controls/FluentWinUI3" "$DOTS/local/lib/qt6/qml/QtQuick/Controls/"

# Wallpapers (desktop + lock screen)
mkdir -p "$DOTS/wallpapers"
for w in current.jpg lock.png; do
  [ -f "$HOME/Pictures/Wallpapers/$w" ] && cp "$HOME/Pictures/Wallpapers/$w" "$DOTS/wallpapers/"
done

# Python packages used by the shell's colour scripts
VENV="$HOME/.local/state/quickshell/.venv"
if [ -x "$HOME/.local/bin/uv" ] && [ -x "$VENV/bin/python" ]; then
  "$HOME/.local/bin/uv" pip freeze --python "$VENV/bin/python" 2>/dev/null > "$DOTS/requirements.txt"
fi

# Replace the absolute home path with a placeholder
grep -rlI --null -- "$HOME" "$DOTS" | xargs -0 -r sed -i "s|$HOME|@HOME@|g"

echo "✅ Snapshot written to $DOTS"
