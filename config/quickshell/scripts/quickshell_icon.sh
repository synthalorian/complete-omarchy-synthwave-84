#!/bin/bash
# Map window class to icon path
CLASS="$1"
CLASS_LOWER=$(echo "$CLASS" | tr '[:upper:]' '[:lower:]')

# Map class to icon name
 case "$CLASS_LOWER" in
    kitty) ICON_NAME="kitty" ;;
    brave-browser) ICON_NAME="brave-desktop" ;;
    vesktop) ICON_NAME="vesktop" ;;
    firefox|firefox-esr) ICON_NAME="firefox" ;;
    chromium|chromium-browser) ICON_NAME="chromium" ;;
    code|code-oss) ICON_NAME="code" ;;
    vscodium) ICON_NAME="vscodium" ;;
    thunar) ICON_NAME="Thunar" ;;
    gimp) ICON_NAME="gimp" ;;
    steam) ICON_NAME="steam" ;;
    telegramdesktop|telegram-desktop) ICON_NAME="telegram" ;;
    alacritty) ICON_NAME="Alacritty" ;;
    ghostty) ICON_NAME="com.mitchellh.ghostty" ;;
    walker) ICON_NAME="walker" ;;
    obs) ICON_NAME="com.obsproject.Studio" ;;
    spotify) ICON_NAME="spotify-client" ;;
    discord) ICON_NAME="discord" ;;
    net.lutris.lutris) ICON_NAME="lutris" ;;
    bolt) ICON_NAME="bolt-launcher" ;;
    *) ICON_NAME="$CLASS_LOWER" ;;
esac

# Find icon path
for THEME in cyberpunk-technotronic-rebuilt cyberpunk-technotronic-icon-theme candy-icons breeze Adwaita hicolor; do
    for ICON_BASE in "$HOME/.icons" "/usr/share/icons"; do
        [ -d "$ICON_BASE/$THEME" ] || continue
        # Try sized icons first (largest to smallest)
        for SIZE in 64 48 32 24 22 16; do
            for EXT in png svg; do
                for DIR in apps categories devices; do
                    PATH="$ICON_BASE/$THEME/$DIR/$SIZE/${ICON_NAME}.$EXT"
                    if [ -f "$PATH" ]; then
                        echo "$PATH"
                        exit 0
                    fi
                    # Try legacy size format (e.g., 48x48)
                    PATH="$ICON_BASE/$THEME/$DIR/${SIZE}x${SIZE}/${ICON_NAME}.$EXT"
                    if [ -f "$PATH" ]; then
                        echo "$PATH"
                        exit 0
                    fi
                done
            done
        done
        # Fallback to scalable
        for DIR in apps/scalable categories/scalable devices/scalable; do
            for EXT in png svg; do
                PATH="$ICON_BASE/$THEME/$DIR/${ICON_NAME}.$EXT"
                if [ -f "$PATH" ]; then
                    echo "$PATH"
                    exit 0
                fi
            done
        done
    done
done

# Fallback: try to find from desktop files
DESKTOP=$(grep -rl "StartupWMClass=$CLASS" /usr/share/applications/ ~/.local/share/applications/ 2>/dev/null | head -1)
if [ -n "$DESKTOP" ]; then
    ICON=$(grep "^Icon=" "$DESKTOP" | head -1 | cut -d= -f2)
    if [ -n "$ICON" ] && [ -f "$ICON" ]; then
        echo "$ICON"
        exit 0
    fi
fi

echo ""
