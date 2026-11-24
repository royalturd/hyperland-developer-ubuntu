# 🌀 Hyprland Ubuntu Setup

Scripts that rebuild my **Hyprland** desktop on **Ubuntu 26.04+**: Hyprland from the Ubuntu archive plus an Ubuntu port of [end-4's illogical-impulse](https://github.com/end-4/dots-hyprland) shell running on Quickshell. The configuration in `dots/` is a snapshot of the live system, so a fresh install looks and behaves the same.

---

## 📦 What gets installed

| Script | What it does |
| --- | --- |
| `scripts/01-dependencies.sh` | apt packages: Wayland tools, apps used by the keybinds, fonts, Quickshell build dependencies and the QML modules the shell needs |
| `scripts/02-hyperland.sh` | `hyprland`, `xdg-desktop-portal-hyprland`, `hyprland-qtutils`, `hyprpolkitagent`, `hyprlock`, `hypridle`, `hyprpicker` |
| `scripts/03-quickshell.sh` | Builds Quickshell at revision `7511545` into `~/.local` (skipped if already installed) |
| `scripts/04-tools.sh` | matugen 4.1.0, hyprshot, the shell's Python venv (`~/.local/state/quickshell/.venv` via uv), Material Symbols / Google Sans Flex / Rubik / Readex Pro / Space Grotesk / JetBrainsMono Nerd fonts, Bibata cursor, adw-gtk3 theme, Firefox Nightly (Mozilla apt repo), `video`/`i2c`/`input` groups |
| `scripts/05-dotfiles.sh` | Copies `dots/` into `~/.config`, `~/.local` and `~/Pictures/Wallpapers`, hooks terminal colours into `~/.zshrc`, applies GTK settings. Existing files are backed up to `~/.config-backup-hyprland-<date>` |
| `scripts/06-post-setup.sh` | Final notes |

### 🗂️ Config in `dots/`

`hypr`, `quickshell/ii`, `illogical-impulse` (shell settings), `fish`, `fuzzel`, `kitty`, `foot`, `alacritty`, `btop`, `cava`, `matugen`, `wlogout`, `xdg-desktop-portal`, `fontconfig`, `kde-material-you-colors`, `Kvantum`, `zshrc.d`, `gtk-3.0`, `gtk-4.0`, `starship.toml`, `kdeglobals`, the generated wallpaper colours, and the desktop and lock-screen wallpapers.

Personal changes on top of end-4 live in `dots/config/hypr/custom/` (keybinds, animations, env).

### ⌨️ Personal keybinds

| Keys | Action |
| --- | --- |
| `SUPER+Q` | Terminal (alacritty) |
| `SUPER+X` / `SUPER+C` | Close window |
| `SUPER+R` | Search / app launcher (Quickshell) |
| `SUPER+1` | Rofi app launcher |
| `SUPER+W` | Firefox Nightly |
| `SUPER+E` | Nautilus |
| `SUPER+SHIFT+V` | Clipboard history |
| `CTRL+SUPER+T` | Wallpaper selector |
| `CTRL+SUPER+/` | Edit shell config |

Everything else follows end-4's defaults; press `SUPER+/` for the cheatsheet.

---

## 🚀 How to Use

### 📥 One-liner Install

```bash
wget -qO- https://raw.githubusercontent.com/royalturd/hyperland-developer-ubuntu/main/install.sh | bash
```

Or clone the repo and run `./setup.sh`. Then log out and pick **Hyprland** on the login screen.

### 🔄 Updating the snapshot

After changing your setup, capture it again and commit:

```bash
./snapshot.sh
git add dots && git commit -s -m "chore: refresh dotfiles snapshot"
```

`snapshot.sh` stores your home path as `@HOME@`; `05-dotfiles.sh` puts the real one back.
