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
- **SDDM** — login screen (deep purple bg `#0D0221`, yellow frame `#FFFF66`, electric purple logo `#8F00FF`)
- **Plymouth** — boot splash theme (deep purple background, recolored assets)
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

### Cursor Theme: Synthwave Night

The included **Synthwave Night** cursor theme is a converted Windows cursor set originally by [4DCube](https://www.rw-designer.com/cursor-set/synthwave-night), adapted for Linux XCursor format. It features neon synthwave-styled pointers that match the overall aesthetic.

- Inherits from `phinger-cursors-dark` for any missing cursors
- Install location: `~/.local/share/icons/synthwave-night/`

### Fonts & Icons

- **3270 Nerd Font** — terminal font
- **Candy Icons** — icon pack

## Directory Structure

```
.
├── install.sh          # One-command installer
├── README.md
├── SETUP.md
├── cursors/
│   └── synthwave-night/   # Synthwave Night XCursor theme
│       ├── cursors/
│       └── index.theme
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
├── sddm/              # SDDM login theme
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

## Important: Autostart Config

Your user `~/.config/hypr/autostart.conf` should **only contain overrides**, not copies of the default autostart. The default autostart at `~/.local/share/omarchy/default/hypr/autostart.conf` already launches waybar, mako, hypridle, swaybg, etc. Duplicating these entries causes double instances of every service.

The included `config/hypr/autostart.conf` in this repo contains only the cursor theme override as an example.

## Screenshots

See `themes/synthwave84/README.md`.

## Credits

- [Omarchy](https://omarchy.org/)
- [omacom-io/omarchy-synthwave84-theme](https://github.com/omacom-io/omarchy-synthwave84-theme) — Original Omarchy synthwave theme that inspired this project
- [gupta-akshay/omarchy-waybar-config](https://github.com/gupta-akshay/omarchy-waybar-config) — Waybar config structure and module layout
- [Synthwave Night Cursors](https://www.rw-designer.com/cursor-set/synthwave-night) by 4DCube — Converted to Linux XCursor format for this theme
- [Candy Icons](https://github.com/Elena-atanuka/Candy-icons)
- 3270 Nerd Font (via `nerd-fonts`)

**This theme configuration assembled and maintained by [synthalorian](https://github.com/synthalorian)** — Customized Limine bootloader entries, Plymouth/SDDM recoloring, cursor conversion, and full Omarchy integration.

---

*Write the future in the present while preserving the past.* 🎹🦈🌆
