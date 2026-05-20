# Complete Omarchy Synthwave '84

My personal Omarchy Linux setup featuring the **Synthwave '84** theme — deep purples, electric magentas, and hot pinks straight out of a neon-soaked 1984 that never was.

## One-Command Install

```bash
curl -sL https://raw.githubusercontent.com/synthalorian/complete-omarchy-synthwave-84/master/install.sh | bash
```

Or clone and run:
```bash
git clone https://github.com/synthalorian/complete-omarchy-synthwave-84.git ~/.complete-omarchy-synthwave-84 && ~/.complete-omarchy-synthwave-84/install.sh
```

---

## What's Included

### Theme: Synthwave '84

- Deep purple background (#240037)
- Electric purple borders (#8f00ff)
- Hot pink highlights (#ff007f)
- Neon yellow accents (#ffff66)
- Cyan accents (#00ffff)

### Components Themed

- **Hyprland** — window manager (borders, colors)
- **Waybar** — status bar (3270 Nerd Font, custom styling, purple/yellow accent)
- **SDDM** — login screen (purple bg, yellow frame, dark purple logo)
- **Plymouth** — boot splash theme
- **Mako** — notification daemon
- **SwayOSD** — on-screen display
- **Walker** — app launcher
- **Alacritty** — terminal
- **Foot** — terminal (Wayland native)
- **Ghostty** — terminal
- **Kitty** — terminal
- **btop** — system monitor
- **Neovim** — editor colorscheme

### Fonts & Cursors

- **3270 Nerd Font** — terminal font
- **Phinger Cursors** — mouse pointer (dark variant)
- **Candy Icons** — icon pack

## Directory Structure

```
.
├── install.sh          # One-command installer
├── README.md
├── SETUP.md
├── themes/
│   └── synthwave84/    # Main theme
│       ├── backgrounds/
│       ├── alacritty.toml
│       ├── btop.theme
│       ├── hyprland.conf
│       ├── hyprlock.conf
│       ├── mako.ini
│       ├── neovim.lua
│       ├── swayosd.css
│       ├── walker.css
│       └── waybar.css
├── config/
│   ├── hypr/          # User Hyprland overrides
│   ├── waybar/        # Waybar config
│   ├── ghostty/
│   ├── kitty/
│   ├── alacritty/
│   ├── fastfetch/
│   └── starship/
├── sddm/              # SDDM theme
└── plymouth/          # Plymouth boot splash
```

## Requirements

- **Omarchy Linux** — https://omarchy.org/
- Arch Linux based
- Hyprland window manager

## Screenshots

See `themes/synthwave84/README.md`.

## Credits

- [Omarchy](https://omarchy.org/)
- [Phinger Cursors](https://github.com/Philogag/PhingerCursors)
- [Candy Icons](https://github.com/Elena-atanuka/Candy-icons)
- 3270 Nerd Font (via `nerd-fonts`)

---

*Write the future in the present while preserving the past.*
