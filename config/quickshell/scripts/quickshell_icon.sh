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
    *) ICON_NAME="$CLASS_LOWER" ;;
esac

# Find icon path
for THEME in candy-icons breeze Adwaita hicolor; do
    for DIR in apps/scalable devices/scalable; do
        for EXT in svg png; do
            PATH="/usr/share/icons/$THEME/$DIR/${ICON_NAME}.$EXT"
            if [ -f "$PATH" ]; then
                echo "$PATH"
                exit 0
            fi
        done
    done
    # Try sized directories
    for SIZE in 256 128 64 48 32 24 22; do
        for EXT in svg png; do
            PATH="/usr/share/icons/$THEME/apps/${SIZE}x${SIZE}/${ICON_NAME}.$EXT"
            if [ -f "$PATH" ]; then
                echo "$PATH"
                exit 0
            fi
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
