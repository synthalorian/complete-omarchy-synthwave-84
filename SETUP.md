# Setup Guide — Complete Omarchy Synthwave '84

## One-Command Install (One-Liner)

```bash
curl -sL https://raw.githubusercontent.com/synthalorian/complete-omarchy-synthwave-84/master/install.sh | bash
```

Or clone and run locally:
```bash
git clone https://github.com/synthalorian/complete-omarchy-synthwave-84.git ~/.complete-omarchy-synthwave-84 && ~/.complete-omarchy-synthwave-84/install.sh
```

---

## Manual Setup

### Prerequisites

- Omarchy installed and running
- Hyprland as the compositor
- Git installed
- yay/paru for AUR packages

### 1. Install Required Packages

```bash
# Fonts
yay -S nerd-fonts-git

# Candy Icons (icon pack)
yay -S candy-icons-git

# Optional: btop for themed system monitor
yay -S btop
```

Refresh font cache:
```bash
fc-cache -f
```

### 2. Install Theme

```bash
# Clone repo
git clone https://github.com/synthalorian/complete-omarchy-synthwave-84.git ~/dotfiles

# Copy theme
cp -r ~/dotfiles/themes/synthwave84 ~/.config/omarchy/themes/

# Apply
omarchy theme set synthwave84
```

### 3. Apply Configs

```bash
# Hyprland
cp ~/dotfiles/config/hypr/*.conf ~/.config/hypr/
hyprctl reload

# Waybar
cp ~/dotfiles/config/waybar/* ~/.config/waybar/
omarchy restart waybar

# Terminals
cp ~/dotfiles/config/ghostty/config ~/.config/ghostty/
cp ~/dotfiles/config/kitty/kitty.conf ~/.config/kitty/
cp ~/dotfiles/config/alacritty/alacritty.toml ~/.config/alacritty/
omarchy restart terminal

# Fastfetch
cp ~/dotfiles/config/fastfetch/config.jsonc ~/.config/fastfetch/

# Starship
cp ~/dotfiles/config/starship/starship.toml ~/.config/
```

### 4. Cursor Theme

```bash
# Install cursor theme
cp -r ~/dotfiles/cursors/synthwave-night ~/.local/share/icons/

# Set active cursor
hyprctl setcursor synthwave-night 24
```

Add to `~/.config/hypr/looknfeel.conf`:
```hyprlang
exec-once = hyprctl setcursor synthwave-night 24
env = XCURSOR_THEME,synthwave-night
env = XCURSOR_SIZE,24
```

### 5. SDDM Theme

```bash
sudo cp -r ~/dotfiles/sddm/synthwave84 /usr/share/sddm/themes/
echo -e "[Theme]\nCurrent=synthwave84" | sudo tee /etc/sddm.conf
```

### 6. Plymouth Boot Splash

```bash
sudo cp -r ~/dotfiles/plymouth/synthwave84 /usr/share/plymouth/themes/
# Edit /etc/plymouth/plymouthd.conf and set Theme=synthwave84
sudo mkinitcpio -P
```

### 7. Neovim Colorscheme

```bash
mkdir -p ~/.config/nvim/lua/plugins
cp ~/dotfiles/themes/synthwave84/neovim.lua ~/.config/nvim/lua/plugins/synthwave84.lua
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Waybar won't restart | `omarchy restart waybar` |
| Config errors | `hyprctl reload && hyprctl configerrors` |
| Font not found | `fc-list \| grep 3270 && fc-cache -f` |
| Cursor not applied | `hyprctl setcursor synthwave-night 24` |
| Duplicate waybar on boot | Check `~/.config/hypr/autostart.conf` — only add overrides, don't copy defaults |

---

## Customization

Edit theme files in `~/.config/omarchy/themes/synthwave84/`:
- `hyprland.conf` — window borders
- `waybar.css` — status bar colors
- `mako.ini` — notifications
- `alacritty.toml` — terminal colors

## Resources

- [Omarchy](https://omarchy.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Synthwave Night Cursors](https://www.rw-designer.com/cursor-set/synthwave-night)
- [Candy Icons](https://github.com/Elena-atanuka/Candy-icons)
