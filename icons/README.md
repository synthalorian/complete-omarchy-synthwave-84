# Cyberpunk Technotronic Rebuilt Icon Theme

A rebuilt version of the [cyberpunk technotronic icon theme](https://store.kde.org/p/1333537/) with proper SVG dimensions for crisp rendering at all sizes.

## Original Theme

- **Original author**: [dreifacherspass](https://www.pling.com/u/dreifacherspass/) / [GitHub](https://github.com/dreifacherspass)
- **Original theme**: [cyberpunk technotronic](https://store.kde.org/p/1333537/) on KDE Store
- **License**: CC BY-SA 4.0

## Rebuild by

- **synthalorian** — Rebuilt SVGs with proper width/height attributes, fixed broken symlinks, corrected tiny icon paths, added 64px size directories

## What Was Fixed

The original theme had several issues that caused blurry or tiny icons:

1. **Missing SVG dimensions** — Original SVGs had `viewBox` but no `width`/`height`, causing blurry upscaling
2. **Broken symlinks** — `system-file-manager.svg` pointed to a 16px panel icon, making file manager icons tiny
3. **Corrupted icon paths** — `Alacritty.svg` had microscopic path data (coordinates < 1.0)
4. **Missing size directories** — No `64/` directories in `index.theme`, causing fallback to smaller sizes
5. **Invalid XML** — Missing spaces between SVG attributes (`viewBox="..."xmlns="..."`)

## Build Instructions

```bash
cd icons/
# Extract the original cyberpunk-technotronic-icon-theme to this directory
# Then run:
./build-icon-theme.sh
```

## Installation

```bash
cp -r cyberpunk-technotronic-rebuilt ~/.icons/
gtk-update-icon-cache -f ~/.icons/cyberpunk-technotronic-rebuilt
gsettings set org.gnome.desktop.interface icon-theme 'cyberpunk-technotronic-rebuilt'
```

## Included in Complete Omarchy Synthwave '84

This rebuilt icon theme is the default icon pack for the [Complete Omarchy Synthwave '84](https://github.com/synthalorian/complete-omarchy-synthwave-84) desktop theme.
