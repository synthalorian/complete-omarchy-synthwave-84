#!/bin/bash
# Check if wifi interface exists and is connected
WIFI_IFACE=$(iw dev 2>/dev/null | grep Interface | awk '{print $2}' | head -1)
if [ -n "$WIFI_IFACE" ]; then
    SSID=$(iw dev "$WIFI_IFACE" link 2>/dev/null | grep SSID | sed 's/.*SSID: //')
    if [ -n "$SSID" ]; then
        SIGNAL=$(iw dev "$WIFI_IFACE" link 2>/dev/null | grep signal | awk '{print $2}')
        echo "wifi|$SSID|$SIGNAL"
        exit 0
    fi
fi

# Check ethernet interfaces
for ETH in enp8s0 eth0 eno1; do
    if [ -d "/sys/class/net/$ETH" ]; then
        STATE=$(cat "/sys/class/net/$ETH/operstate" 2>/dev/null)
        if [ "$STATE" = "up" ]; then
            echo "eth|Connected|0"
            exit 0
        fi
    fi
done

echo "none|Disconnected|0"
