# Hyprland Dotfiles

![260621-164954](https://raw.githubusercontent.com/berthosefin/dots/main/previews/2026-06-21_16-49-54.png)

Personal dotfiles for a customized [Hyprland](https://github.com/hyprwm/Hyprland) setup, focused on simplicity, aesthetics, and efficiency.

> 🖌️ This configuration uses [matugen](https://github.com/InioX/matugen) for dynamic Material You (MD3) color theming generated from your wallpaper.

## 📦 Dependencies

Make sure you have the following packages installed:

- [Hyprland](https://wiki.hyprland.org/)
- `kitty` (terminal)
- `rofi` (app launcher)
- `dunst` (notifications)
- `awww` (wallpaper manager)
- `hypridle` (idle manager)
- `hyprlock` (screen locker)
- `satty` (screenshot tool)
- `cliphist` (clipboard manager)
- `xfce4-terminal` (alternative terminal)
- `thunar` (file manager)
- `zathura` (pdf reader)
- `viewnior` (image viewer)
- `firefox` (web browser)
- `pamixer` (volume control)
- `brightnessctl` (brightness control)
- `playerctl` (media control)
- `wireplumber` (pipewire session manager)
- `matugen` (dynamic colors)
- `jq` (JSON processor, for zoom bindings)
- `xdg-user-dirs` (screenshot path)
- `nvim` (optional)
- `pavucontrol` (optional, volume mixer GUI)
- `yazi` (optional, file manager) + `ffmpeg` `7zip` `jq` `poppler` `fd` `ripgrep` `fzf` `zoxide` `resvg` `imagemagick`
- `pywalfox` (optional, Firefox theming)
- `stow` (dotfiles manager)
- `papirus-icon-theme`

### 📦 Install dependencies on Arch (with `yay`)

```bash
yay -S hyprland kitty rofi dunst awww hypridle hyprlock satty xfce4-terminal thunar zathura viewnior firefox pamixer brightnessctl playerctl wireplumber matugen jq xdg-user-dirs stow nvim papirus-icon-theme  cliphist pavucontrol yazi ffmpeg 7zip poppler fd ripgrep fzf zoxide resvg imagemagick ttf-jetbrains-mono-nerd
```

---

## 🧷 Installation

1. Clone this repo into your dotfiles directory:

```bash
git clone --depth=1 https://github.com/berthosefin/dots.git
cd dots
```

1. Deploy the Hyprland configuration using [GNU Stow](https://www.gnu.org/software/stow/):

```bash
chmod +x install.sh
sh install.sh
```

This will symlink the configuration files into your `~/.config` directory.

---

## 🎨 Theming

Colors are dynamically generated from your wallpaper using **matugen** (HCT/CAM16 MD3 color tokens). To apply a new theme:

```bash
matugen image /path/to/wallpaper.jpg
```

This automatically updates: Hyprland, Hyprlock, Waybar, Rofi, Kitty, Dunst, GTK3/4, xfce4-terminal, Neovim, Kvantum, Zathura, BTOP, OpenCode, VSCode, Zed, Tmux, Yazi, Firefox (via pywalfox), and Papirus-folders.

### Icons

- **Icon theme**: [Papirus-Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- **Folder colors**: dynamically set via `papirus-folders` based on the wallpaper's primary MD3 color (requires a NOPASSWD sudoers rule for the `papirus-folders` command)

### Cursor

- **Cursor theme**: [Banana](https://github.com/ful1e5/Banana-cursor)

---

## ⌨️ Keybindings Overview

| Keybinding               | Action                    |
| ------------------------ | ------------------------- |
| `SUPER + Return`         | Launch kitty              |
| `SUPER + Shift + Return` | Launch xfce4-terminal     |
| `SUPER + D`              | Launch Rofi               |
| `SUPER + Q`              | Close active window       |
| `SUPER + Shift + Q`      | Exit Hyprland             |
| `SUPER + E`              | Powermenu                 |
| `SUPER + F`              | Toggle fullscreen         |
| `SUPER + G`              | Group/Ungroup windows     |
| `Alt + >` / `Alt + <`    | Switch grouped window     |
| `Print`                  | Screenshot                |
| `SUPER + [1–10]`         | Switch workspace          |
| `SUPER + Shift + [1–10]` | Move window to workspace  |
| `SUPER + S`              | Toggle special workspace  |
| `SUPER + Shift + S`      | Move to special workspace |
| `SUPER + LMB / RMB`      | Move / Resize window      |
| `XF86...`                | Multimedia shortcuts      |

---

## 🛠 Tips

- Keybindings are defined in `home/.config/hypr/hyprland.lua`.
- To restrict Papirus-folders color changes to your user without a password prompt, add a sudoers rule:

  ```
  youruser ALL=(ALL) NOPASSWD: /usr/sbin/papirus-folders
  ```

  Make sure the filename sorts after any `ALL=(ALL) ALL` rule (e.g. `zz_papirus-folders`).
