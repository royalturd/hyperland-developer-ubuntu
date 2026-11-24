#!/bin/bash
set -e
# Quickshell runs the illogical-impulse shell (bar, sidebars, launcher,
# notifications, lock screen). Ubuntu does not package it, so build the
# revision the shell config was written against and install it under ~/.local.

QS_REPO="https://git.outfoxxed.me/quickshell/quickshell"
QS_REV="7511545ee20664e3b8b8d3322c0ffe7567c56f7a"

if "$HOME/.local/bin/quickshell" --version 2>/dev/null | grep -q "$QS_REV"; then
  echo "ℹ️  Quickshell ${QS_REV:0:7} already installed, skipping build."
  exit 0
fi

echo "🧱 Building Quickshell ${QS_REV:0:7} (takes a while)..."
BUILD_DIR=$(mktemp -d)
trap 'rm -rf "$BUILD_DIR"' EXIT

git clone -q "$QS_REPO" "$BUILD_DIR/quickshell"
cd "$BUILD_DIR/quickshell"
git checkout -q "$QS_REV"

cmake -GNinja -B build \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
  -DINSTALL_QML_PREFIX=lib/qt6/qml \
  -DDISTRIBUTOR="manual (end-4 port, Ubuntu)" \
  -DDISTRIBUTOR_DEBUGINFO_AVAILABLE=NO \
  -DCRASH_HANDLER=OFF
cmake --build build -j"$(nproc)"
cmake --install build

echo "✅ Quickshell installed to ~/.local/bin/quickshell"
