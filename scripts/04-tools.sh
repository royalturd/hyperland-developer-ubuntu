#!/bin/bash
set -e
# Tools, fonts and themes that are not in the Ubuntu archive.
# Every download is pinned to a version or commit and checked against a
# SHA-256 hash, so a changed or tampered file stops the install.

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$HOME/.local/bin"
FONTS="$HOME/.local/share/fonts/illogical-impulse"
ICONS="$HOME/.local/share/icons"
THEMES="$HOME/.local/share/themes"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$BIN" "$FONTS" "$ICONS" "$THEMES"

# fetch URL DEST SHA256: download, verify, keep only on a match
fetch() {
  local url="$1" dest="$2" sum="$3"
  curl -fsSL -o "$dest.part" "$url"
  if ! echo "$sum  $dest.part" | sha256sum -c --quiet - >/dev/null 2>&1; then
    rm -f "$dest.part"
    echo "❌ Checksum mismatch for $url" >&2
    exit 1
  fi
  mv "$dest.part" "$dest"
}

# --- matugen: Material You colours from the wallpaper ---
MATUGEN_VER="4.1.0"
if ! "$BIN/matugen" --version 2>/dev/null | grep -q "$MATUGEN_VER"; then
  echo "🎨 Installing matugen $MATUGEN_VER..."
  fetch "https://github.com/InioX/matugen/releases/download/v$MATUGEN_VER/matugen-$MATUGEN_VER-x86_64.tar.gz" \
    "$TMP/matugen.tgz" ba46c324d578c782d42644f526df559be81d53352926f5bb2826c98d1340beb0
  tar xzf "$TMP/matugen.tgz" -C "$TMP"
  install -m755 "$(find "$TMP" -type f -name matugen | head -n 1)" "$BIN/matugen"
fi

# --- hyprshot: screenshots ---
HYPRSHOT_COMMIT="f95068db7765b85a2bbae0f083e29074d7bee027"
if [ ! -x "$BIN/hyprshot" ] && ! command -v hyprshot >/dev/null; then
  echo "📸 Installing hyprshot..."
  fetch "https://raw.githubusercontent.com/Gustash/Hyprshot/$HYPRSHOT_COMMIT/hyprshot" \
    "$BIN/hyprshot" bded5ab3588ae5e5eb965faeadb1b5d6b9bd4688f7b6147311c835a406b7795b
  chmod 755 "$BIN/hyprshot"
fi

# --- Python venv for the shell's colour scripts ---
# Python 3.12 because the pinned numpy/opencv wheels in requirements.txt
# don't exist for newer versions. If the system has no 3.12, uv downloads
# one and checks it against the hashes built into uv.
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
MDI="https://github.com/google/material-design-icons/raw/10ecc14790612ca8fd164e3f4ffe9c16fc50d5b7/variablefont"
GFONTS="https://github.com/google/fonts/raw/06bfe0d62a98375cb09c942fa18e68bd32cff057/ofl"
GSF="https://github.com/end-4/google-sans-flex/raw/251aa5abd30496368f634e54ce2a508fe5a2fdfa"
font() { # file-name url sha256
  [ -f "$FONTS/$1" ] || fetch "$2" "$FONTS/$1" "$3"
}
font MaterialSymbolsRounded.ttf "$MDI/MaterialSymbolsRounded%5BFILL,GRAD,opsz,wght%5D.ttf" \
  7e74e36533ccee12c2b81e75bfcf3ccf123d3bb7e7e46d65d94445f23db0c97c
font MaterialSymbolsOutlined.ttf "$MDI/MaterialSymbolsOutlined%5BFILL,GRAD,opsz,wght%5D.ttf" \
  f7837ba8573d9a7a74931618ced8307bc81f96d49af296bf6c8052c772ed5282
font 'ReadexPro[HEXP,wght].ttf' "$GFONTS/readexpro/ReadexPro%5BHEXP%2Cwght%5D.ttf" \
  268bba7e1e8f3b14d798b3fb0e40ebaa3fc39308c9ac0020e2faf6df181cc30e
font 'SpaceGrotesk[wght].ttf' "$GFONTS/spacegrotesk/SpaceGrotesk%5Bwght%5D.ttf" \
  acad6de1fc93436f5c0f1f4137751ef04f1aea3063e7036535970ffcfbd79f72
font 'Rubik[wght].ttf' "$GFONTS/rubik/Rubik%5Bwght%5D.ttf" \
  1b3a7437ba2af80e465e773ed60c5036d1ba6ace492d89046dbcf18fb31e4e88
font 'Rubik-Italic[wght].ttf' "$GFONTS/rubik/Rubik-Italic%5Bwght%5D.ttf" \
  08c6c4018a5ada8b517407b46897e46cf6ebb106853fbd3e89addb51d3b59c62
font 'GoogleSansFlex-VariableFont_GRAD,ROND,opsz,slnt,wdth,wght.ttf' \
  "$GSF/GoogleSansFlex-VariableFont_GRAD%2CROND%2Copsz%2Cslnt%2Cwdth%2Cwght.ttf" \
  2510a8b7a24beb1fe8163e9a49813ccfe96b5453444b9443d42665ca4fa320c9
if ! fc-list | grep -q 'JetBrainsMono Nerd Font'; then
  fetch https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/JetBrainsMono.zip \
    "$TMP/jbm.zip" fab782a66f7d3019da64f6572db9fc5d3a4bcb19f9fa13e2d8a62e3693d6396e
  unzip -oq "$TMP/jbm.zip" '*.ttf' -d "$HOME/.local/share/fonts"
fi
fc-cache -f >/dev/null

# --- Cursor and GTK theme ---
if [ ! -d "$ICONS/Bibata-Modern-Classic" ]; then
  echo "🖱️  Installing Bibata cursor..."
  fetch https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz \
    "$TMP/bibata.tar.xz" 4cfe5256374d7a465e05d6590dbc10745dc9d362bf955eaa2ac79b4070b0f3aa
  tar xJf "$TMP/bibata.tar.xz" -C "$ICONS"
fi
if [ ! -d "$THEMES/adw-gtk3-dark" ] && [ ! -d /usr/share/themes/adw-gtk3-dark ]; then
  echo "🎨 Installing adw-gtk3 theme..."
  fetch https://github.com/lassekongo83/adw-gtk3/releases/download/v6.5/adw-gtk3v6.5.tar.xz \
    "$TMP/adw.tar.xz" a81780fadfc432be0fc3d89c4ebb41aa28e4f032d42c36f9789c57dd10cfa41c
  tar xJf "$TMP/adw.tar.xz" -C "$THEMES"
fi

# --- Firefox Nightly (Super+W) from Mozilla's apt repository ---
MOZILLA_FPR="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"
if ! command -v firefox-nightly >/dev/null; then
  echo "🦊 Installing Firefox Nightly..."
  curl -fsSL -o "$TMP/mozilla.asc" https://packages.mozilla.org/apt/repo-signing-key.gpg
  FPR=$(gpg -n -q --import --import-options import-show "$TMP/mozilla.asc" 2>/dev/null \
    | awk '/^pub/{getline; gsub(/ /,""); print; exit}')
  if [ "$FPR" != "$MOZILLA_FPR" ]; then
    echo "❌ Mozilla signing key fingerprint mismatch ($FPR), not adding the repository." >&2
    exit 1
  fi
  sudo install -d -m 0755 /etc/apt/keyrings
  sudo install -m 0644 "$TMP/mozilla.asc" /etc/apt/keyrings/packages.mozilla.org.asc
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

# --- Groups ---
# video + i2c: brightness control (brightnessctl, ddcutil).
# input: needed by ydotool, which the shell uses to paste from clipboard
# history and for the on-screen keyboard. It also lets your programs read
# raw keyboard/mouse events; remove it here if you don't use those features.
getent group i2c >/dev/null || sudo groupadd i2c
sudo usermod -aG video,i2c,input "$USER"
echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf >/dev/null

echo "✅ Tools, fonts and themes installed!"
