# Complete Omarchy Synthwave '84 🎹🦈🌆

A fully realized synthwave-inspired Omarchy Linux theme featuring deep purples, electric magentas, and hot pinks. Born from the VHS tracking static of 1984.

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

| Role | Hex | Description |
|------|-----|-------------|
| Background | `#0D0221` | Deepest background / scaffold |
| Surface | `#240037` | Card backgrounds, base surface |
| Primary | `#8F00FF` | Electric purple — main accent |
| Secondary | `#FF00FF` | Hot pink — complementary accent |
| Accent/cyan | `#00FFFF` | Data streams, tertiary |
| Text | `#FFFFFF` | White text |
| Success | `#00FF41` | Lime green |
| Warning | `#FFFF66` | Yellow |
| Error | `#FF0040` | Red |

### Components Themed

- **Hyprland** — window manager (borders, colors, active border glow)
- **Waybar** — status bar (3270 Nerd Font, custom styling, magenta/yellow accent, cava audio viz, GPU monitor, MPRIS, network speed, weather)
- **SDDM** — login screen (purple bg, magenta frame, dark purple logo)
- **Plymouth** — boot splash theme
- **Mako** — notification daemon
- **SwayOSD** — on-screen display
- **Walker** — app launcher
- **Alacritty** — terminal
- **Foot** — terminal (Wayland native)
- **Ghostty** — terminal
- **Kitty** — terminal
- **btop** — system monitor
- **Helix** — editor colorscheme
- **Neovim** — editor colorscheme
- **Obsidian** — note-taking app theme
- **Gum** — charmbracelet gum styling

### Fonts & Cursors

- **3270 Nerd Font** — terminal font
- **Phinger Cursors** — mouse pointer (dark variant)
- **Cyberpunk Technotronic Rebuilt** — icon pack (rebuilt from dreifacherspass's original with fixed SVG dimensions, 64px support, and corrected symlinks)

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
│       ├── colors.toml
│       ├── foot.ini
│       ├── ghostty.conf
│       ├── gum.env.conf
│       ├── helix.toml
│       ├── hyprland.conf
│       ├── hyprland-preview-share-picker.css
│       ├── hyprlock.conf
│       ├── keyboard.rgb
│       ├── kitty.conf
│       ├── mako.ini
│       ├── neovim.lua
│       ├── obsidian.css
│       ├── swayosd.css
│       ├── walker.css
│       └── waybar.css
├── config/
│   ├── hypr/          # User Hyprland overrides
│   │   ├── autostart.conf
│   │   ├── bindings.conf
│   │   ├── envs.conf
│   │   ├── hypridle.conf
│   │   ├── hyprland.conf
│   │   ├── hyprlock.conf
│   │   ├── hyprsunset.conf
│   │   ├── input.conf
│   │   ├── looknfeel.conf
│   │   └── monitors.conf (user-specific, not in repo)
│   ├── waybar/        # Waybar config
│   │   ├── config.jsonc
│   │   ├── style.css
│   │   ├── cava.sh
│   │   ├── net_speed.sh
│   │   ├── waybar-gpu.sh
│   │   └── modules/
│   ├── ghostty/
│   ├── kitty/
│   ├── alacritty/
│   ├── fastfetch/
│   └── starship/
├── icons/             # Rebuilt cyberpunk-technotronic icon theme
│   ├── build-icon-theme.sh
│   └── README.md
├── sddm/              # SDDM theme
└── plymouth/          # Plymouth boot splash
```

## Requirements

- **Omarchy Linux** — https://omarchy.org/
- Arch Linux based
- Hyprland window manager

## Waybar Features

The included Waybar config is feature-rich:

- **Left**: Omarchy menu, workspace pills, active window, cava audio visualizer, MPRIS media player
- **Center**: Clock, calendar launcher, weather (wttrbar), network speed, update notifier
- **Right**: Tray expander, idle inhibitor, temperature, network, disk, memory, GPU, CPU, wireplumber volume, battery

All modules styled with synthwave84 color variables and hover effects.

## Screenshots

See `themes/synthwave84/README.md`.

## Credits

- [Omarchy](https://omarchy.org/)
- [omacom-io/omarchy-synthwave84-theme](https://github.com/omacom-io/omarchy-synthwave84-theme) — Original Omarchy synthwave theme that inspired this project
- [Phinger Cursors](https://github.com/Philogag/PhingerCursors)
- [Cyberpunk Technotronic](https://store.kde.org/p/1333537/) — Original icon theme by [dreifacherspass](https://www.pling.com/u/dreifacherspass/)
- **synthalorian** — Rebuilt the icon theme with proper SVG dimensions, 64px size directories, fixed broken symlinks, and corrected tiny icon paths
- 3270 Nerd Font (via `nerd-fonts`)

---

*Write the future in the present while preserving the past.* 🎹🦈🌆
