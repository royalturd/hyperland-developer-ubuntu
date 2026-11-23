# 🌀 Hyprland Ubuntu Setup

Setup scripts that install and configure a **Hyprland** environment on **Ubuntu 26.04+**, using the `hyprland` package from the Ubuntu archive.

---

## 📦 What’s Included

### 🔧 Core Setup

- Installs **Hyprland** and `xdg-desktop-portal-hyprland` from apt
- Login session comes from the package: pick **Hyprland** at the login screen
- Copies the default config to `~/.config/hypr/hyprland.conf` if you don't have one yet
- Installs base tools: `waybar`, `wofi`, `alacritty`, `dunst`, `swaybg`, `wl-clipboard`, `xwayland`

---

### 🎨 Theming and UI

Writes GTK3 and GTK4 `settings.ini` with the same look as the existing GNOME setup:

- **GTK Theme:** material-gnome-theme (dark)
- **Icon Pack:** Yaru-prussiangreen-dark
- **Font:** Ubuntu Nerd Font 11
- **Cursor:** DMZ-Black, size 24

These must already be installed; the scripts do not install them.

---

## 🚀 How to Use

### 📥 One-liner Install (Recommended)

You can install everything with a single terminal command:

```bash
wget -qO- https://raw.githubusercontent.com/grassiricardo/hyperland-developer-ubuntu/main/install.sh | bash
```
