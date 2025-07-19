# Hyprland Dotfiles

![PRpOQX87yC](https://raw.githubusercontent.com/berthosefin/dots/main/previews/PRpOQX87yC.png)

Personal dotfiles for a customized [Hyprland](https://github.com/hyprwm/Hyprland) setup, focused on simplicity, aesthetics, and efficiency.

> 🖌️ This configuration is based on [pywal](https://github.com/dylanaraps/pywal) for dynamic color theming.

## 📦 Dependencies

Make sure you have the following packages installed:

- [Hyprland](https://wiki.hyprland.org/)
- `alacritty` (terminal)
- `rofi` (app launcher)
- `dunst` (notifications)
- `hyprpaper` (wallpaper manager)
- `hypridle` (idle manager)
- `hyprlock` (screen locker)
- `hyprshot` (Screenshot)
- `xfce4-terminal` (alternative terminal)
- `thunar` (file manager)
- `zathura` (pdf reader)
- `viewnior` (image viewer)
- `firefox` (web browser)
- `pamixer` (volume control)
- `brightnessctl` (brightness control)
- `playerctl` (media control)
- `wpctl` (pipewire audio)
- `pywal` (dynamic colors)
- `departure` (powermenu)
- `stow` (dotfiles manager)
- `papirus-icon-theme`


### 📦 Install dependencies on Arch (with `yay`):

```bash
yay -S hyprland alacritty rofi dunst hyprpaper hypridle hyprlock hyprshot xfce4-terminal thunar zathura viewnior firefox pamixer brightnessctl playerctl wireplumber python-pywal stow departure papirus-icon-theme
```

---

## 🧷 Installation

1. Clone this repo into your dotfiles directory:

```bash
git clone https://github.com/berthosefin/dots.git
cd dots
```

2. Deploy the Hyprland configuration using [GNU Stow](https://www.gnu.org/software/stow/):

```bash
chmod +x install.sh
sh install.sh
```

This will symlink the configuration files into your `~/.config` directory.

---

## ⌨️ Keybindings Overview

| Keybinding               | Action                    |
| ------------------------ | ------------------------- |
| `SUPER + Return`         | Launch Alacritty          |
| `SUPER + Shift + Return` | Launch xfce4-terminal     |
| `SUPER + D`              | Launch Rofi               |
| `SUPER + Q`              | Close active window       |
| `SUPER + Shift + Q`      | Exit Hyprland             |
| `SUPER + E`              | Powermenu : `departure`   |
| `SUPER + C`              | Switch color scheme       |
| `SUPER + F`              | Toggle fullscreen         |
| `SUPER + G`              | Group/Ungroup windows     |
| `Alt + Tab`              | Switch grouped window     |
| `Print`                  | Screenshot (output)       |
| `Ctrl + Print`           | Screenshot (region)       |
| `SUPER + [1–10]`         | Switch workspace          |
| `SUPER + Shift + [1–10]` | Move window to workspace  |
| `SUPER + S`              | Toggle special workspace  |
| `SUPER + Shift + S`      | Move to special workspace |
| `SUPER + LMB / RMB`      | Move / Resize window      |
| `XF86...`                | Multimedia shortcuts      |

---

## 🛠 Tips

- You can modify any keybindings in `hyprland.conf` to suit your workflow.
- You can add more colorscheme in `~/.config/hypr/scripts/colorschemes`
