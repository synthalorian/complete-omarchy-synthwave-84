#!/usr/bin/env bash
set -e

REPO="https://github.com/synthalorian/complete-omarchy-synthwave-84.git"
DIR="${HOME}/.complete-omarchy-synthwave-84"
THEME_NAME="synthwave84"

echo "═══════════════════════════════════════════════"
echo "  Complete Omarchy Synthwave '84 Installer"
echo "═══════════════════════════════════════════════"

# Clone or pull
if [ -d "$DIR/.git" ]; then
    echo "[*] Repo found, pulling latest..."
    cd "$DIR" && git pull
else
    echo "[*] Cloning repo..."
    git clone "$REPO" "$DIR"
fi

cd "$DIR"

# Install packages
echo "[*] Installing packages..."
yay -Sy --noconfirm nerd-fonts-git phinger-cursor-themes candy-icons-git btop 2>/dev/null || sudo pacman -S --noconfirm btop

# Refresh font cache
fc-cache -f

# Apply themes
echo "[*] Installing Synthwave '84 theme..."
mkdir -p "${HOME}/.config/omarchy/themes"
cp -r "themes/${THEME_NAME}" "${HOME}/.config/omarchy/themes/"

# Apply Omarchy theme
omarchy theme set "$THEME_NAME" 2>/dev/null || echo "[!] Run 'omarchy theme set synthwave84' manually"

# Apply Hyprland config
echo "[*] Applying Hyprland config..."
mkdir -p "${HOME}/.config/hypr"
cp -r config/hypr/*.conf "${HOME}/.config/hypr/"

# Apply Waybar
echo "[*] Applying Waybar config..."
mkdir -p "${HOME}/.config/waybar"
cp config/waybar/config.jsonc "${HOME}/.config/waybar/"
cp config/waybar/style.css "${HOME}/.config/waybar/"
cp -r config/waybar/modules "${HOME}/.config/waybar/"
[ -f config/waybar/cava.sh ] && cp config/waybar/cava.sh "${HOME}/.config/waybar/"
[ -f config/waybar/net_speed.sh ] && cp config/waybar/net_speed.sh "${HOME}/.config/waybar/"
[ -f config/waybar/waybar-gpu.sh ] && cp config/waybar/waybar-gpu.sh "${HOME}/.config/waybar/"
omarchy restart waybar 2>/dev/null || echo "[!] Run 'omarchy restart waybar' manually"

# Apply terminal configs
echo "[*] Applying terminal configs..."
mkdir -p "${HOME}/.config/ghostty"
cp config/ghostty/config "${HOME}/.config/ghostty/"

mkdir -p "${HOME}/.config/kitty"
cp config/kitty/kitty.conf "${HOME}/.config/kitty/"

mkdir -p "${HOME}/.config/alacritty"
cp config/alacritty/alacritty.toml "${HOME}/.config/alacritty/"

omarchy restart terminal 2>/dev/null || echo "[!] Run 'omarchy restart terminal' manually"

# Apply Fastfetch
echo "[*] Applying Fastfetch config..."
mkdir -p "${HOME}/.config/fastfetch"
cp config/fastfetch/config.jsonc "${HOME}/.config/fastfetch/"

# Apply Starship
echo "[*] Applying Starship config..."
cp config/starship/starship.toml "${HOME}/.config/"

# Apply Neovim colorscheme
echo "[*] Applying Neovim colorscheme..."
mkdir -p "${HOME}/.config/nvim/lua/plugins"
cp "themes/${THEME_NAME}/neovim.lua" "${HOME}/.config/nvim/lua/plugins/synthwave84.lua"

# Set cursor theme
echo "[*] Setting cursor theme..."
hyprctl setcursor phinger-cursors-dark 24 2>/dev/null || echo "[!] Run 'hyprctl setcursor phinger-cursors-dark 24' manually"

# Set SDDM theme
echo "[*] Setting up SDDM theme..."
if [ -d "sddm/${THEME_NAME}" ]; then
    sudo cp -r "sddm/${THEME_NAME}" /usr/share/sddm/themes/
    if [ -f /etc/sddm.conf ]; then
        grep -q "^Current=" /etc/sddm.conf && sudo sed -i "s/^Current=.*/Current=${THEME_NAME}/" /etc/sddm.conf || echo "Current=${THEME_NAME}" | sudo tee -a /etc/sddm.conf
    else
        echo "[Theme]
Current=${THEME_NAME}" | sudo tee /etc/sddm.conf
    fi
    echo "[*] SDDM theme applied"
fi

# Set Plymouth theme
echo "[*] Setting up Plymouth theme..."
if [ -d "plymouth/${THEME_NAME}" ]; then
    sudo cp -r "plymouth/${THEME_NAME}" /usr/share/plymouth/themes/
    if [ -f /etc/plymouth/plymouthd.conf ]; then
        sudo sed -i "s/^Theme=.*/Theme=${THEME_NAME}/" /etc/plymouth/plymouthd.conf 2>/dev/null || true
    fi
    echo "[*] Plymouth theme installed (rebuild initramfs with 'sudo mkinitcpio -P' to apply)"
fi

# Reload Hyprland config
hyprctl reload 2>/dev/null || echo "[!] Run 'hyprctl reload' manually"

echo ""
echo "═══════════════════════════════════════════════"
echo "  Installation complete!"
echo "═══════════════════════════════════════════════"
echo ""
echo "Run 'hyprctl reload' to apply Hyprland changes."
echo "Run 'omarchy restart waybar' to apply Waybar changes."
echo "Run 'sudo mkinitcpio -P' to apply Plymouth boot splash."
echo "Restart to see SDDM theme."
