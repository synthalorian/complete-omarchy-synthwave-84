# Complete Omarchy Synthwave '84

My personal Omarchy Linux setup featuring the **Synthwave '84** theme — deep purples, electric magentas, and hot pinks straight out of a neon-soaked 1984 that never was. Also includes the **Archwave** vaporwave theme.

## What's Included

### Custom Themes

| Theme | Description |
|-------|-------------|
| **Synthwave '84** | Neon purple/magenta palette, synthwave aesthetics |
| **Archwave** | Vaporwave pastels — pinks, cyans, dreamy purples |

### Components Themed

- **Hyprland** — window manager (borders, colors)
- **Waybar** — status bar (3270 Nerd Font, custom styling)
- **SDDM** — login screen theme
- **Plymouth** — boot splash theme
- **Mako** — notification daemon
- **SwayOSD** — on-screen display
- **Walker** — app launcher
- **Alacritty** — terminal
- **Ghostty** — terminal
- **Kitty** — terminal
- **btop** — system monitor
- **Neovim** — editor colorscheme

### Fonts

- **3270 Nerd Font** — terminal font (small, crisp)
- **Phinger Cursors** — mouse pointer theme (dark variant)

### Icons

- **Candy Icons** — icon pack (`candy-icons-git`)

## Directory Structure

```
.
├── README.md
├── SETUP.md
├── themes/
│   ├── synthwave84/
│   │   ├── backgrounds/
│   │   ├── alacritty.toml
│   │   ├── btop.theme
│   │   ├── hyprland.conf
│   │   ├── hyprlock.conf
│   │   ├── mako.ini
│   │   ├── neovim.lua
│   │   ├── swayosd.css
│   │   ├── walker.css
│   │   └── waybar.css
│   └── archwave/
│       ├── backgrounds/
│       ├── alacritty.toml
│       ├── ghostty.conf
│       ├── kitty.conf
│       ├── hyprland.conf
│       ├── hyprlock.conf
│       ├── mako.ini
│       ├── btop.theme
│       ├── swayosd.css
│       ├── walker.css
│       ├── waybar.css
│       ├── neovim.lua
│       └── icons.theme
├── config/
│   ├── hypr/
│   │   ├── bindings.conf
│   │   ├── looknfeel.conf
│   │   ├── autostart.conf
│   │   └── envs.conf
│   ├── waybar/
│   │   ├── config.jsonc
│   │   ├── style.css
│   │   └── modules/
│   ├── ghostty/config
│   ├── kitty/kitty.conf
│   ├── alacritty/alacritty.toml
│   ├── fastfetch/config.jsonc
│   └── starship.toml
├── sddm/
│   └── synthwave84/  (logo.png, lock.png, entry.png, etc.)
└── plymouth/
    └── synthwave84/  (logo.png, bullet.png, etc.)
```

## Quick Start

```bash
# Clone the repo
git clone https://github.com/synthalorian/complete-omarchy-synthwave-84.git ~/dotfiles

# Follow SETUP.md for full installation instructions
```

## Requirements

- **Omarchy Linux** — https://omarchy.org/
- **Arch Linux** based
- **Hyprland** as the window manager

## Screenshots

See individual theme READMEs in `themes/synthwave84/` and `themes/archwave/`.

## Credits

- Omarchy: https://omarchy.org/
- Phinger Cursors: https://github.com/Philogag/PhingerCursors
- Candy Icons: https://github.com/Elena-atanuka/Candy-icons
- 3270 Nerd Font: Part of `nerd-fonts`

---

*Write the future in the present while preserving the past.*
