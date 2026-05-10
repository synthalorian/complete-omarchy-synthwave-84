#!/usr/bin/env bash

ROCM_SMI="/opt/rocm/bin/rocm-smi"

if [ -x "$ROCM_SMI" ]; then
    # Parse rocm-smi output for device 0 (dGPU)
    # Format: Device Node IDs... VRAM% GPU%
    line=$("$ROCM_SMI" 2>/dev/null | grep -E '^0\s+[0-9]' | head -1)

    if [ -n "$line" ]; then
        gpu_name="RX 9070 XT"
        temp=$(echo "$line" | grep -oP '\d+\.\d+°C' | head -1)
        vram_pct=$(echo "$line" | awk '{print $(NF-1)}')
        gpu_pct=$(echo "$line" | awk '{print $NF}')

        # Clean up
        temp=${temp/°C/}
        [ -z "$gpu_pct" ] && gpu_pct="0"
        [ -z "$temp" ] && temp="N/A"

        # VRAM in MB from sysfs for actual values
        mem=$(cat /sys/class/drm/card1/device/mem_info_vram_used 2>/dev/null || echo "0")
        mem_total=$(cat /sys/class/drm/card1/device/mem_info_vram_total 2>/dev/null || echo "0")
        if [ "$mem" -gt 0 ] 2>/dev/null && [ "$mem_total" -gt 0 ] 2>/dev/null; then
            mem_mb=$((mem / 1024 / 1024))
            mem_total_mb=$((mem_total / 1024 / 1024))
            mem_str="${mem_mb}MB / ${mem_total_mb}MB"
        else
            mem_str="${vram_pct}% used"
        fi

        printf '{"text":"%s","tooltip":"GPU: %s\\nUsage: %s\\nTemperature: %sC\\nVRAM: %s"}\n' "󰓹 ${gpu_pct}" "$gpu_name" "${gpu_pct}" "$temp" "$mem_str"
    else
        echo '{"text":"N/A","tooltip":"rocm-smi: No GPU detected"}'
    fi
else
    # Sysfs fallback
    gpu_card=""
    max_vram=0
    for card in /sys/class/drm/card[0-9]*; do
        [ -d "$card/device" ] || continue
        vram=$(cat "$card/device/mem_info_vram_total" 2>/dev/null || echo "0")
        if [ "$vram" -gt "$max_vram" ] 2>/dev/null; then
            max_vram="$vram"
            gpu_card="$card"
        fi
    done

    if [ -z "$gpu_card" ]; then
        echo '{"text":"N/A","tooltip":"No AMD GPU detected"}'
        exit 0
    fi

    util=$(cat "$gpu_card/device/gpu_busy_percent" 2>/dev/null || echo "0")
    temp_raw=$(find "$gpu_card/device/hwmon" -name "temp1_input" 2>/dev/null | head -1 | xargs cat 2>/dev/null || echo "")

    if [ -n "$temp_raw" ] && [ "$temp_raw" -gt 0 ] 2>/dev/null; then
        temp=$((temp_raw / 1000))
    else
        temp="N/A"
    fi

    mem=$(cat "$gpu_card/device/mem_info_vram_used" 2>/dev/null || echo "0")
    mem_total=$(cat "$gpu_card/device/mem_info_vram_total" 2>/dev/null || echo "0")

    if [ "$mem" -gt 0 ] 2>/dev/null && [ "$mem_total" -gt 0 ] 2>/dev/null; then
        mem_mb=$((mem / 1024 / 1024))
        mem_total_mb=$((mem_total / 1024 / 1024))
        mem_str="${mem_mb}MB / ${mem_total_mb}MB"
    else
        mem_str="N/A"
    fi

    gpu_id=$(cat "$gpu_card/device/device" 2>/dev/null)
    case "$gpu_id" in
        0x7550) gpu_name="RX 9070 XT" ;;
        *) gpu_name="AMD GPU ($(basename "$gpu_card"))" ;;
    esac

    printf '{"text":"%s","tooltip":"GPU: %s\\nUsage: %s%%\\nTemperature: %sC\\nVRAM: %s"}\n' "󰓹 ${util}%" "$gpu_name" "$util" "$temp" "$mem_str"
fi
