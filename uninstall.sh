#!/usr/bin/env bash
set -e

THEME_NAME="synthwave84"
BACKUP_DIR="${HOME}/.config/omarchy-backup-$(date +%Y%m%d-%H%M%S)"

echo "═══════════════════════════════════════════════"
echo "  Complete Omarchy Synthwave '84 Uninstaller"
echo "═══════════════════════════════════════════════"
echo ""
echo "This will revert all Synthwave '84 changes and"
echo "restore Omarchy defaults. A backup will be made at:"
echo "  ${BACKUP_DIR}"
echo ""
read -p "Are you sure? [y/N] " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

mkdir -p "$BACKUP_DIR"

# ─── Backup current configs ───
echo "[*] Backing up current configs..."
[ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$BACKUP_DIR/"
[ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$BACKUP_DIR/"
[ -d ~/.config/omarchy/themes ] && cp -r ~/.config/omarchy/themes "$BACKUP_DIR/"
[ -d ~/.local/share/icons/synthwave-night ] && cp -r ~/.local/share/icons/synthwave-night "$BACKUP_DIR/"

# ─── Reset Omarchy theme to default ───
echo "[*] Resetting Omarchy theme to default..."
omarchy theme set default 2>/dev/null || echo "[!] Run 'omarchy theme set default' manually"

# ─── Remove Synthwave '84 theme files ───
echo "[*] Removing Synthwave '84 theme..."
rm -rf "${HOME}/.config/omarchy/themes/${THEME_NAME}"

# ─── Reset Hyprland config to Omarchy defaults ───
echo "[*] Resetting Hyprland config..."
# These are user overrides — removing them lets Omarchy defaults take over
rm -f ~/.config/hypr/autostart.conf
rm -f ~/.config/hypr/bindings.conf
rm -f ~/.config/hypr/envs.conf
rm -f ~/.config/hypr/hypridle.conf
rm -f ~/.config/hypr/hyprland.conf
rm -f ~/.config/hypr/hyprlock.conf
rm -f ~/.config/hypr/hyprsunset.conf
rm -f ~/.config/hypr/input.conf
rm -f ~/.config/hypr/looknfeel.conf
# monitors.conf is user-specific, keep it

# ─── Reset Waybar to Omarchy defaults ───
echo "[*] Resetting Waybar config..."
rm -rf ~/.config/waybar/*
omarchy refresh waybar 2>/dev/null || echo "[!] Run 'omarchy refresh waybar' manually"

# ─── Reset terminal configs to Omarchy defaults ───
echo "[*] Resetting terminal configs..."
rm -f ~/.config/ghostty/config
rm -f ~/.config/kitty/kitty.conf
rm -f ~/.config/alacritty/alacritty.toml
rm -f ~/.config/foot/foot.ini
omarchy refresh terminal 2>/dev/null || echo "[!] Run 'omarchy refresh terminal' manually"

# ─── Remove cursor theme ───
echo "[*] Removing Synthwave Night cursor theme..."
rm -rf ~/.local/share/icons/synthwave-night

# ─── Reset cursor to Omarchy default ───
echo "[*] Resetting cursor to default..."
hyprctl setcursor phinger-cursors-dark 24 2>/dev/null || true

# ─── Remove Neovim colorscheme ───
echo "[*] Removing Neovim colorscheme..."
rm -f ~/.config/nvim/lua/plugins/synthwave84.lua

# ─── Remove Fastfetch config ───
echo "[*] Removing Fastfetch config..."
rm -f ~/.config/fastfetch/config.jsonc

# ─── Remove Starship config ───
echo "[*] Removing Starship config..."
rm -f ~/.config/starship.toml

# ─── Revert SDDM to Omarchy default ───
echo "[*] Reverting SDDM theme..."
if [ -f /etc/sddm.conf ]; then
    sudo sed -i "s/^Current=.*/Current=omarchy/" /etc/sddm.conf 2>/dev/null || true
fi
if [ -d /usr/share/sddm/themes/${THEME_NAME} ]; then
    echo "[!] SDDM theme still installed at /usr/share/sddm/themes/${THEME_NAME}"
    echo "    Remove manually: sudo rm -rf /usr/share/sddm/themes/${THEME_NAME}"
fi

# ─── Revert Plymouth to Omarchy default ───
echo "[*] Reverting Plymouth theme..."
if [ -f /etc/plymouth/plymouthd.conf ]; then
    sudo sed -i "s/^Theme=.*/Theme=omarchy/" /etc/plymouth/plymouthd.conf 2>/dev/null || true
fi
if [ -d /usr/share/plymouth/themes/${THEME_NAME} ]; then
    echo "[!] Plymouth theme still installed at /usr/share/plymouth/themes/${THEME_NAME}"
    echo "    Remove manually: sudo rm -rf /usr/share/plymouth/themes/${THEME_NAME}"
    echo "    Then rebuild initramfs: sudo mkinitcpio -P"
fi

# ─── Reload Hyprland ───
echo "[*] Reloading Hyprland..."
hyprctl reload 2>/dev/null || echo "[!] Run 'hyprctl reload' manually"

# ─── Restart Waybar ───
echo "[*] Restarting Waybar..."
omarchy restart waybar 2>/dev/null || echo "[!] Run 'omarchy restart waybar' manually"

echo ""
echo "═══════════════════════════════════════════════"
echo "  Uninstallation complete!"
echo "═══════════════════════════════════════════════"
echo ""
echo "Backup saved to: ${BACKUP_DIR}"
echo ""
echo "Manual steps may be needed:"
echo "  - Remove SDDM theme: sudo rm -rf /usr/share/sddm/themes/${THEME_NAME}"
echo "  - Remove Plymouth theme: sudo rm -rf /usr/share/plymouth/themes/${THEME_NAME}"
echo "  - Rebuild initramfs: sudo mkinitcpio -P"
echo "  - Reboot to see SDDM/Plymouth changes"
echo ""
echo "Your original configs are backed up at:"
echo "  ${BACKUP_DIR}"
