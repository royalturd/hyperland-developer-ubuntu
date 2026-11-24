#!/bin/bash
set -e
# Tools, fonts and themes that are not in the Ubuntu archive.

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$HOME/.local/bin"
FONTS="$HOME/.local/share/fonts/illogical-impulse"
ICONS="$HOME/.local/share/icons"
THEMES="$HOME/.local/share/themes"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$BIN" "$FONTS" "$ICONS" "$THEMES"

# --- matugen: Material You colours from the wallpaper ---
MATUGEN_VER="4.1.0"
if ! "$BIN/matugen" --version 2>/dev/null | grep -q "$MATUGEN_VER"; then
  echo "🎨 Installing matugen $MATUGEN_VER..."
  curl -fsSL -o "$TMP/matugen.tgz" \
    "https://github.com/InioX/matugen/releases/download/v$MATUGEN_VER/matugen-$MATUGEN_VER-x86_64.tar.gz"
  tar xzf "$TMP/matugen.tgz" -C "$TMP"
  install -m755 "$(find "$TMP" -type f -name matugen | head -n 1)" "$BIN/matugen"
fi

# --- hyprshot: screenshots ---
if [ ! -x "$BIN/hyprshot" ] && ! command -v hyprshot >/dev/null; then
  echo "📸 Installing hyprshot..."
  curl -fsSL -o "$BIN/hyprshot" https://raw.githubusercontent.com/Gustash/Hyprshot/main/hyprshot
  chmod 755 "$BIN/hyprshot"
fi

# --- Python venv for the shell's colour scripts ---
VENV="$HOME/.local/state/quickshell/.venv"
echo "🐍 Setting up the Quickshell Python venv..."
pipx install uv >/dev/null 2>&1 || pipx upgrade uv >/dev/null 2>&1 || true
UV="$BIN/uv"
export UV_NO_MODIFY_PATH=1
if [ ! -x "$VENV/bin/python" ]; then
  mkdir -p "$(dirname "$VENV")"
  "$UV" venv --prompt .venv "$VENV" -p 3.12
fi
"$UV" pip install --python "$VENV/bin/python" -r "$REPO_DIR/dots/requirements.txt"

# --- Fonts used by the shell ---
echo "🔤 Installing fonts..."
if [ ! -f "$FONTS/MaterialSymbolsRounded.ttf" ]; then
  curl -fsSL -o "$FONTS/MaterialSymbolsRounded.ttf" \
    'https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL,GRAD,opsz,wght%5D.ttf'
  curl -fsSL -o "$FONTS/MaterialSymbolsOutlined.ttf" \
    'https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsOutlined%5BFILL,GRAD,opsz,wght%5D.ttf'
fi
gfont() { # family-dir file-name
  [ -f "$FONTS/$2" ] && return
  local enc
  enc=$(printf '%s' "$2" | sed 's/\[/%5B/g;s/\]/%5D/g;s/,/%2C/g')
  curl -fsSL -o "$FONTS/$2" "https://github.com/google/fonts/raw/main/ofl/$1/$enc"
}
gfont readexpro 'ReadexPro[HEXP,wght].ttf'
gfont spacegrotesk 'SpaceGrotesk[wght].ttf'
gfont rubik 'Rubik[wght].ttf'
gfont rubik 'Rubik-Italic[wght].ttf'
if ! ls "$FONTS"/GoogleSansFlex* >/dev/null 2>&1; then
  git clone -q --depth 1 https://github.com/end-4/google-sans-flex "$TMP/gsf"
  find "$TMP/gsf" -iname '*.ttf' -exec cp {} "$FONTS/" \;
fi
if ! fc-list | grep -q 'JetBrainsMono Nerd Font'; then
  curl -fsSL -o "$TMP/jbm.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -oq "$TMP/jbm.zip" '*.ttf' -d "$HOME/.local/share/fonts"
fi
fc-cache -f >/dev/null

# --- Cursor and GTK theme ---
if [ ! -d "$ICONS/Bibata-Modern-Classic" ]; then
  echo "🖱️  Installing Bibata cursor..."
  curl -fsSL -o "$TMP/bibata.tar.xz" \
    https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz
  tar xJf "$TMP/bibata.tar.xz" -C "$ICONS"
fi
if [ ! -d "$THEMES/adw-gtk3-dark" ] && [ ! -d /usr/share/themes/adw-gtk3-dark ]; then
  echo "🎨 Installing adw-gtk3 theme..."
  URL=$(curl -fsSL https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest \
    | jq -r '.assets[] | select(.name|endswith(".tar.xz")) | .browser_download_url' | head -n 1)
  curl -fsSL -o "$TMP/adw.tar.xz" "$URL"
  tar xJf "$TMP/adw.tar.xz" -C "$THEMES"
fi

# --- Firefox Nightly (Super+W) from Mozilla's apt repository ---
if ! command -v firefox-nightly >/dev/null; then
  echo "🦊 Installing Firefox Nightly..."
  sudo install -d -m 0755 /etc/apt/keyrings
  curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg \
    | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc >/dev/null
  sudo tee /etc/apt/sources.list.d/mozilla.sources >/dev/null <<'EOF'
Types: deb
URIs: https://packages.mozilla.org/apt/
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF
  sudo apt update
  sudo apt install -y firefox-nightly
fi

# --- Groups for brightness (ddcutil) and ydotool ---
getent group i2c >/dev/null || sudo groupadd i2c
sudo usermod -aG video,i2c,input "$USER"
echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf >/dev/null

echo "✅ Tools, fonts and themes installed!"
