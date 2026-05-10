# Setup Guide — Complete Omarchy Synthwave '84

This guide walks through setting up this configuration on a fresh Omarchy install.

## Prerequisites

- Omarchy installed and running
- Hyprland as the compositor
- Git installed

## 1. Install Required Packages

```bash
# Fonts
sudo pacman -Syu nerd-fonts-git

# Phinger Cursors (mouse theme)
yay -S phinger-cursor-themes

# Candy Icons (icon pack)
yay -S candy-icons-git

# Optional: if you want btop themed
yay -S btop
```

## 2. Install Fonts

The themes use **3270 Nerd Font** as the terminal font. Install via:

```bash
# From AUR (Arch)
yay -S nerd-fonts-git

# Or via omarchy font command
omarchy font set 3270\ Nerd\ Font
```

Refresh font cache:
```bash
fc-cache -f
```

## 3. Set Up Cursor Theme

```bash
# Add to ~/.config/hypr/autostart.conf (if not already present)
exec-once = hyprctl setcursor phinger-cursors-dark 24
```

Set environment variables in `~/.config/hypr/envs.conf`:
```
env = XCURSOR_THEME,phinger-cursors-dark
env = XCURSOR_SIZE,24
```

## 4. Install Themes

### Option A: Per-Theme Installation (Recommended)

Copy theme files to your Omarchy themes directory:

```bash
# Synthwave '84
cp -r themes/synthwave84 ~/.config/omarchy/themes/

# Archwave
cp -r themes/archwave ~/.config/omarchy/themes/

# Apply theme
omarchy theme set synthwave84
# or
omarchy theme set archwave
```

### Option B: Copy Individual Configs

```bash
# Hyprland configs
cp config/hypr/*.conf ~/.config/hypr/

# Waybar
cp config/waybar/* ~/.config/waybar/
omarchy restart waybar

# Terminals
cp config/ghostty/config ~/.config/ghostty/
cp config/kitty/kitty.conf ~/.config/kitty/
cp config/alacritty/alacritty.toml ~/.config/alacritty/
omarchy restart terminal
```

## 5. Install SDDM Theme

```bash
# Copy SDDM theme
sudo cp -r sddm/synthwave84 /usr/share/sddm/themes/

# Configure SDDM
sudoedit /etc/sddm.conf
```

Add/edit:
```
[Theme]
Current=synthwave84
```

Or use the GUI:
```bash
omarchy menu  # or Super+Alt+Space
# Navigate to Style → Theme → SDDM
```

## 6. Install Plymouth Theme (Boot Splash)

```bash
# Copy Plymouth theme
sudo cp -r plymouth/synthwave84 /usr/share/plymouth/themes/

# Update plymouth config
sudoedit /etc/plymouth/plymouthd.conf
```

Set:
```
[Daemon]
Theme=synthwave84
```

Rebuild initramfs:
```bash
sudo mkinitcpio -P
```

## 7. Neovim Colorscheme

Copy the neovim.lua to your Lazy.nvim plugins:

```bash
mkdir -p ~/.config/nvim/lua/plugins/
cp themes/synthwave84/neovim.lua ~/.config/nvim/lua/plugins/synthwave84.lua
```

Or for Archwave:
```bash
cp themes/archwave/neovim.lua ~/.config/nvim/lua/plugins/archwave.lua
```

Restart Neovim to apply.

## 8. Fastfetch

```bash
cp config/fastfetch/config.jsonc ~/.config/fastfetch/
```

## 9. Starship Prompt

```bash
cp config/starship.toml ~/.config/
```

## 10. Icons Theme (Archwave only)

```bash
gsettings set org.gnome.desktop.interface icon-theme "Yaru-magenta"
# Or for GTK:
# Add to ~/.config/gtk-3.0/settings.ini:
# gtk-icon-theme-name=Yaru-magenta
```

## Troubleshooting

### Waybar doesn't restart
```bash
omarchy restart waybar
```

### Hyprland config error
```bash
hyprctl reload
hyprctl configerrors
```

### Font not found
```bash
fc-list | grep 3270
fc-cache -f
```

### Cursor theme not applied
```bash
hyprctl setcursor phinger-cursors-dark 24
```

## Customization

### Changing Theme Colors

Edit the CSS/INI/TOML files in the theme directories:
- `hyprland.conf` — window borders
- `waybar.css` — status bar colors
- `mako.ini` — notifications
- `alacritty.toml` — terminal colors

### Creating Your Own Theme

1. Copy an existing theme:
   ```bash
   cp -r ~/.config/omarchy/themes/synthwave84 ~/.config/omarchy/themes/my-theme
   ```
2. Edit all the color files
3. Add backgrounds to `backgrounds/`
4. Apply:
   ```bash
   omarchy theme set my-theme
   ```

## Keybindings

See `config/hypr/bindings.conf` for custom keybindings. Default Omarchy bindings are in `~/.local/share/omarchy/default/hypr/bindings/`.

Common bindings in this setup:
| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + Shift + Return` | Browser |
| `Super + Shift + F` | File Manager |
| `Super + Shift + M` | Music (Spotify) |
| `Super + Shift + O` | Obsidian |
| `Super + Shift + E` | Email (Hey) |
| `Super + Shift + Y` | YouTube |
| `Super + Shift + X` | X (Twitter) |

## Resources

- [Omarchy Wiki](https://omarchy.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Phinger Cursors](https://github.com/Philogag/PhingerCursors)
- [Candy Icons](https://github.com/Elena-atanuka/Candy-icons)
