# Quickshell Configuration

## Official Quickshell Source

This configuration uses **Quickshell** built from the official source:

- **Repository:** https://github.com/quickshell-mirror/quickshell
- **Latest Commit:** `d99d87d5` (June 10, 2026)
- **Version:** 0.3.0
- **Build Method:** Compiled from source with CMake/Ninja

### Build Instructions

```bash
git clone --depth 1 https://github.com/quickshell-mirror/quickshell.git
cd quickshell
cmake -GNinja -B build -DCMAKE_BUILD_TYPE=Release \
  -DDISTRIBUTOR="Omarchy (built from source)" \
  -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j$(nproc)
sudo cmake --install build
```

### Features Enabled

- Wayland / Wlroots Layer-Shell
- Hyprland Integration (IPC, Global Shortcuts, Focus Grab)
- System Tray (StatusNotifier)
- MPRIS Media Controls
- PipeWire
- X11 Support
- Session Lock
- Notifications
- UPower
- Bluetooth
- Network
- PAM / Polkit

## Font

- **Font Family:** `3270 Nerd Font` (regular, proportional)
- **Font Size:** 14px
- **Package:** `ttf-3270-nerd` (AUR)

The regular (non-mono) variant provides better icon proportions for Nerd Font glyphs while maintaining readability.

## Files

- `shell.qml` — Main bar configuration
- `scripts/quickshell_network.sh` — Network detection script
- `scripts/quickshell_icon.sh` — Window icon mapping script

## Bar Features

- Workspaces (1-8, Hyprland)
- Active window icon + title
- Cava audio visualizer
- MPRIS music controls
- Clock with calendar popup
- Weather (wttrbar)
- System tray with expand/collapse
- Idle inhibitor toggle
- Network status
- Disk / Memory / GPU / CPU / Volume stats with tooltips
