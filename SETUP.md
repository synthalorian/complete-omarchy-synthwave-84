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
- Quickshell installed (`yay -S quickshell` or `omarchy install quickshell`)
- Git installed
- yay/paru for AUR packages

### 1. Install Required Packages

```bash
# Fonts
yay -S nerd-fonts-git

# Candy Icons (icon pack)
yay -S candy-icons-git

# Quickshell (replaces Waybar)
yay -S quickshell

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

# Disable Waybar, enable Quickshell
mkdir -p ~/.local/state/omarchy/toggles
touch ~/.local/state/omarchy/toggles/waybar-off

# Quickshell
cp ~/dotfiles/config/quickshell/shell.qml ~/.config/quickshell/
cp ~/dotfiles/config/quickshell/scripts/*.sh ~/.config/quickshell/scripts/
chmod +x ~/.config/quickshell/scripts/*.sh
pkill quickshell 2>/dev/null || true
quickshell &

# Terminals (Ghostty as default)
cp ~/dotfiles/config/ghostty/config ~/.config/ghostty/
cp ~/dotfiles/config/kitty/kitty.conf ~/.config/kitty/
cp ~/dotfiles/config/alacritty/alacritty.toml ~/.config/alacritty/
[ -f ~/dotfiles/config/foot/foot.ini ] && cp ~/dotfiles/config/foot/foot.ini ~/.config/foot/
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
sudo mkdir -p /usr/share/plymouth/themes/synthwave84
sudo cp ~/dotfiles/plymouth/*.{png,script,plymouth} /usr/share/plymouth/themes/synthwave84/
# Edit /etc/plymouth/plymouthd.conf and set Theme=synthwave84
sudo mkinitcpio -P
```

### 7. Limine Bootloader Theme

**Back up your current Limine config first:**
```bash
sudo cp /boot/limine.conf /boot/limine.conf.backup
```

The theme header in `limine/limine.conf.template` contains the Synthwave '84 branding and color palette. Merge these settings into your `/boot/limine.conf`:

```
interface_branding: Synthwave '84
interface_branding_color: 8f00ff
interface_help_color: 8f00ff
interface_help_color_bright: 8f00ff
hash_mismatch_panic: no

term_background: 240036
backdrop: 240036

term_palette: 240036;8f00ff;8f00ff;8f00ff;8f00ff;8f00ff;8f00ff;ffffff
term_palette_bright: 240036;8f00ff;8f00ff;8f00ff;8f00ff;8f00ff;8f00ff;ffffff

term_foreground: 8f00ff
term_foreground_bright: 8f00ff
term_background_bright: 240036
```

**Do NOT** overwrite the auto-generated OS entries — only replace the theme header section.

### 8. Neovim Colorscheme

```bash
mkdir -p ~/.config/nvim/lua/plugins
cp ~/dotfiles/themes/synthwave84/neovim.lua ~/.config/nvim/lua/plugins/synthwave84.lua
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Quickshell won't start | `quickshell` in terminal to see errors; check `~/.config/quickshell/shell.qml` |
| Waybar still shows | `touch ~/.local/state/omarchy/toggles/waybar-off` then `omarchy restart waybar` |
| Config errors | `hyprctl reload && hyprctl configerrors` |
| Font not found | `fc-list \| grep 3270 && fc-cache -f` |
| Cursor not applied | `hyprctl setcursor synthwave-night 24` |
| Quickshell double instance | `pkill quickshell && sleep 1 && quickshell` |

---

## Customization

Edit theme files in `~/.config/omarchy/themes/synthwave84/`:
- `hyprland.conf` — window borders
- `mako.ini` — notifications
- `ghostty.conf` — terminal colors

Edit Quickshell bar in `~/.config/quickshell/shell.qml`:
- Colors are defined at the top of the ShellRoot
- Modules are in the left/center/right RowLayout sections
- Popups (calendar, weather, tooltips) are PopupWindow components

## Resources

- [Omarchy](https://omarchy.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Quickshell Documentation](https://quickshell.org/)
- [Synthwave Night Cursors](https://www.rw-designer.com/cursor-set/synthwave-night)
- [Candy Icons](https://github.com/Elena-atanuka/Candy-icons)
