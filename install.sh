#!/bin/bash
set -e

REPO_URL="https://github.com/royalturd/hyperland-developer-ubuntu.git"
DIR="hyperland-developer-ubuntu"

if [ -d "$DIR/.git" ]; then
  echo "🔄 Existing copy found, updating it..."
  git -C "$DIR" pull --ff-only
else
  echo "🔄 Cloning Hyprland setup repo..."
  git clone "$REPO_URL" "$DIR"
fi
cd "$DIR"

echo "🔧 Starting full setup..."
chmod +x setup.sh
./setup.sh
