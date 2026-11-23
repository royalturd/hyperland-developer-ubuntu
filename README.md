# 🌀 Hyprland Ubuntu Setup

Setup scripts that install and configure a **Hyprland** environment on **Ubuntu 26.04+**, using the `hyprland` package from the Ubuntu archive.

---

## 📦 What’s Included

### 🔧 Core Setup

- Installs **Hyprland**, `xdg-desktop-portal-hyprland` and `hyprland-qtutils` (Hyprland GUI dialogs) from apt
- Installs Hypr ecosystem tools: `hyprpolkitagent` (auth prompts), `hyprpaper` (wallpaper), `hyprlock` (lock screen), `hypridle` (idle daemon)
- Autostarts `hyprpolkitagent`, `hyprpaper`, `hypridle`, `waybar`, `dunst`, `nm-applet` and the `cliphist` clipboard watcher via `~/.config/hypr/autostart.conf` (sourced from `hyprland.conf`)
- Writes `hyprpaper.conf` (current GNOME wallpaper), `hyprlock.conf` and `hypridle.conf` (lock at 5 min, screen off at 5.5 min, suspend at 30 min) if they don't exist yet
- Points the stock config at installed apps: `alacritty` (terminal), `nautilus` (file manager), `wofi` (launcher)
- Login session comes from the package: pick **Hyprland** at the login screen
- Copies the default config to `~/.config/hypr/hyprland.conf` if you don't have one yet
- Installs base tools: `waybar`, `wofi`, `alacritty`, `dunst`, `swaybg`, `wl-clipboard`, `xwayland`, Qt Wayland support, `grim` + `slurp` (screenshots), `cliphist` (clipboard history), `brightnessctl` + `playerctl` (media keys), `pavucontrol`, `nm-applet`

### ⌨️ Keybinds

| Keys | Action |
| --- | --- |
| `SUPER+Q` | Terminal (alacritty) |
| `SUPER+R` | App launcher (wofi) |
| `SUPER+E` | File manager (nautilus) |
| `SUPER+C` | Close window |
| `SUPER+M` | Exit Hyprland |
| `SUPER+V` | Toggle floating |
| `SUPER+F` | Fullscreen |
| `SUPER+L` | Lock screen |
| `SUPER+arrows` | Move focus |
| `SUPER+SHIFT+arrows` | Move window |
| `SUPER+1..0` | Switch workspace |
| `SUPER+SHIFT+1..0` | Move window to workspace |
| `SUPER+S` / `SUPER+SHIFT+S` | Scratchpad / move window to scratchpad |
| `SUPER+SHIFT+V` | Clipboard history |
| `Print` / `SHIFT+Print` | Screenshot region / full screen to clipboard |
| `SUPER+drag` (left/right mouse) | Move / resize window |
| Media, volume, brightness keys | Work out of the box |

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
