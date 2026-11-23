#!/bin/bash
set -e
echo "🚀 Configuring Hypr tools autostart..."

HYPR_DIR=~/.config/hypr
mkdir -p "$HYPR_DIR"

# Start the tools from Hyprland itself. The packaged systemd user units only
# start when graphical-session.target is active, which a plain Hyprland
# session does not reach.
cat > "$HYPR_DIR/autostart.conf" <<'EOF'
# Managed by hyperland-developer-ubuntu (scripts/03-hypr-tools.sh)
exec-once = /usr/libexec/hyprpolkitagent
exec-once = hyprpaper
exec-once = hypridle
exec-once = waybar
exec-once = dunst
exec-once = nm-applet --indicator
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store

# Lock screen
bind = SUPER, L, exec, loginctl lock-session

# Fullscreen
bind = SUPER, F, fullscreen, 0

# Screenshots: region / whole screen, copied to the clipboard
bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
bind = SHIFT, Print, exec, grim - | wl-copy

# Clipboard history
bind = SUPER SHIFT, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

# Move windows with SUPER+SHIFT+arrows
bind = SUPER SHIFT, left, movewindow, l
bind = SUPER SHIFT, right, movewindow, r
bind = SUPER SHIFT, up, movewindow, u
bind = SUPER SHIFT, down, movewindow, d
EOF

if ! grep -qE '^\s*source\s*=\s*~/.config/hypr/autostart.conf' "$HYPR_DIR/hyprland.conf"; then
  printf '\n# Hypr tools autostart\nsource = ~/.config/hypr/autostart.conf\n' >> "$HYPR_DIR/hyprland.conf"
fi

# Wallpaper: reuse the current GNOME wallpaper, fall back to an Ubuntu default.
if [ ! -f "$HYPR_DIR/hyprpaper.conf" ]; then
  WALLPAPER=""
  if command -v gsettings >/dev/null 2>&1; then
    URI=$(gsettings get org.gnome.desktop.background picture-uri-dark 2>/dev/null | tr -d "'")
    WALLPAPER="${URI#file://}"
  fi
  if [ ! -f "$WALLPAPER" ]; then
    WALLPAPER=$(find /usr/share/backgrounds -maxdepth 1 -type f \( -name '*.png' -o -name '*.jpg' \) 2>/dev/null | sort | head -n 1)
  fi
  if [ -n "$WALLPAPER" ]; then
    cat > "$HYPR_DIR/hyprpaper.conf" <<EOF
wallpaper {
    monitor =
    path = $WALLPAPER
    fit_mode = cover
}

splash = false
EOF
  else
    echo "⚠️  No wallpaper found, skipping hyprpaper.conf."
  fi
else
  echo "ℹ️  $HYPR_DIR/hyprpaper.conf already exists, leaving it untouched."
fi

# Lock screen: start from the packaged sample config.
if [ ! -f "$HYPR_DIR/hyprlock.conf" ]; then
  cp /usr/share/hypr/hyprlock.conf "$HYPR_DIR/hyprlock.conf"
else
  echo "ℹ️  $HYPR_DIR/hyprlock.conf already exists, leaving it untouched."
fi

# Idle: lock after 5 min, screen off after 5.5 min, suspend after 30 min.
if [ ! -f "$HYPR_DIR/hypridle.conf" ]; then
  cat > "$HYPR_DIR/hypridle.conf" <<'EOF'
general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = 300
    on-timeout = loginctl lock-session
}

listener {
    timeout = 330
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}

listener {
    timeout = 1800
    on-timeout = systemctl suspend
}
EOF
else
  echo "ℹ️  $HYPR_DIR/hypridle.conf already exists, leaving it untouched."
fi

echo "✅ Hypr tools configured!"
