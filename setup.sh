#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "🔧 Starting full Hyprland setup on Ubuntu..."
for script in scripts/*.sh; do
  echo "🚀 Running $script"
  bash "$script"
done
echo "✅ Installation completed successfully! Log out and select 'Hyprland' on the login screen."
