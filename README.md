# Complete Omarchy Synthwave '84 🎹🦈🌆

A fully realized synthwave-inspired Omarchy Linux theme featuring deep purples, electric magentas, and hot pinks. Born from the VHS tracking static of 1984.

## One-Command Install (One-Liner)

```bash
curl -sL https://raw.githubusercontent.com/synthalorian/complete-omarchy-synthwave-84/master/install.sh | bash
```

Or clone and run:
```bash
git clone https://github.com/synthalorian/complete-omarchy-synthwave-84.git ~/.complete-omarchy-synthwave-84 && ~/.complete-omarchy-synthwave-84/install.sh
```

## One-Command Uninstall

```bash
curl -sL https://raw.githubusercontent.com/synthalorian/complete-omarchy-synthwave-84/master/uninstall.sh | bash
```

Or run locally:
```bash
~/.complete-omarchy-synthwave-84/uninstall.sh
```

The uninstaller will:
- Back up your current configs to `~/.config/omarchy-backup-<timestamp>/`
- Reset Omarchy theme to default
- Remove all Synthwave '84 user configs (Hyprland, Quickshell, terminals, etc.)
- Remove the Synthwave Night cursor theme
- Revert SDDM and Plymouth themes to Omarchy defaults
- Reload Hyprland and restart Quickshell

**Note:** SDDM, Plymouth, and Limine themes installed to system directories (`/usr/share/...`, `/boot/...`) require manual removal with `sudo` — the uninstaller will warn you if they're still present.

---

## What's Included

### Theme: Synthwave '84

| Role | Hex | Description |
|------|-----|-------------|
| Background | `#240036` | Deepest background / scaffold |
| Surface | `#8F00FF` | Electric purple — card/module backgrounds |
| Primary | `#240037` | Deep purple — main text color |
| Secondary | `#FF00FF` | Hot pink — complementary accent |
| Accent/cyan | `#03EDF9` | Data streams, tertiary |
| Text | `#8F00FF` | Electric purple text |
| Success | `#00FF41` | Lime green |
| Warning | `#FFFF66` | Yellow |
| Error | `#FF0040` | Red |

### Components Themed

- **Hyprland** — window manager (borders, colors, active border glow)
- **Quickshell** — status bar (3270 Nerd Font, custom QML styling, true-center clock/weather, cava audio viz, GPU monitor, MPRIS, network speed, weather, system tray with custom menu)
- **SDDM** — login screen (deep purple bg `#240036`, electric purple frame `#8F00FF`, electric purple logo `#8F00FF`)
- **Plymouth** — boot splash theme (deep purple background, recolored assets)
- **Limine** — bootloader (deep purple terminal bg, electric purple text, Synthwave '84 branding)
- **Mako** — notification daemon
- **SwayOSD** — on-screen display
- **Walker** — app launcher
- **Ghostty** — default terminal
- **Kitty** — terminal
- **Alacritty** — terminal
- **Foot** — terminal (Wayland native)
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
- **Phinger Cursors** — mouse pointer (dark variant)
- **Cyberpunk Technotronic Rebuilt** — icon pack (rebuilt from dreifacherspass's original with fixed SVG dimensions, 64px support, and corrected symlinks)

## Directory Structure

```
.
├── install.sh          # One-command installer
├── uninstall.sh        # One-command uninstaller
├── README.md
├── SETUP.md
├── limine/             # Limine bootloader config template
│   └── limine.conf.template
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
│       └── walker.css
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
│   │   └── looknfeel.conf
│   ├── quickshell/    # Quickshell bar config
│   │   ├── shell.qml
│   │   └── scripts/
│   │       ├── quickshell_icon.sh
│   │       └── quickshell_network.sh
│   ├── ghostty/
│   ├── kitty/
│   ├── alacritty/
│   ├── foot/
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
- Quickshell (installed via `omarchy install quickshell` or AUR)

## Quickshell Features

The included Quickshell config replaces Waybar entirely and provides:

- **Left**: Omarchy menu (click/right-click), workspace pills (1-8, persistent), active window with icon, cava audio visualizer, MPRIS music controls with playerctl fallback
- **Center**: Clock (true screen-center), calendar popup on click, weather widget with detail popup
- **Right**: System tray expander with custom styled menu, idle inhibitor toggle, network with speed tooltip, disk usage tooltip, memory tooltip, GPU usage tooltip (AMD), CPU tooltip, volume control

All styled with synthwave84 color variables and hover effects. Waybar is disabled via `~/.local/state/omarchy/toggles/waybar-off`.

## Default Terminal: Ghostty

Ghostty is configured as the default terminal with:
- 3270 Nerd Font at size 9
- Block cursor, no blink
- Dynamic theme colors from Omarchy
- Window padding 14px
- Epoll async backend for Hyprland performance

## Important: Autostart Config

Your user `~/.config/hypr/autostart.conf` should **only contain overrides**, not copies of the default autostart. The default autostart at `~/.local/share/omarchy/default/hypr/autostart.conf` already launches mako, hypridle, swaybg, etc. Duplicating these entries causes double instances of every service.

The included `config/hypr/autostart.conf` in this repo contains only the cursor theme override and Quickshell launch as examples.

## Screenshots

See `themes/synthwave84/README.md`.

## Credits

- [Omarchy](https://omarchy.org/)
- [omacom-io/omarchy-synthwave84-theme](https://github.com/omacom-io/omarchy-synthwave84-theme) — Original Omarchy synthwave theme that inspired this project
- [Phinger Cursors](https://github.com/Philogag/PhingerCursors)
- [Cyberpunk Technotronic](https://store.kde.org/p/1333537/) — Original icon theme by [dreifacherspass](https://www.pling.com/u/dreifacherspass/)
- **synthalorian** — Rebuilt the icon theme with proper SVG dimensions, 64px size directories, fixed broken symlinks, and corrected tiny icon paths
- [Synthwave Night Cursors](https://www.rw-designer.com/cursor-set/synthwave-night) by 4DCube — Converted to Linux XCursor format for this theme
- 3270 Nerd Font (via `nerd-fonts`)

**Quickshell bar config, Limine bootloader theming, Plymouth/SDDM recoloring, cursor conversion, and full Omarchy integration by synth (synthalorian).**

---

*Write the future in the present while preserving the past.* 🎹🦈🌆
