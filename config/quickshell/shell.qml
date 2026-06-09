//@ pragma UseQApplication
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Qt.labs.platform

ShellRoot {
    id: shell

    // Anchor item references for popup positioning
    property Item calendarAnchorItem: null
    property Item weatherAnchorItem: null
    property Item netAnchorItem: null
    property Item memAnchorItem: null
    property Item diskAnchorItem: null
    property Item gpuAnchorItem: null
    property Item cpuAnchorItem: null
    property var activeBarWindow: null

    // Colors from synthwave84 theme
    property color bgColor: "#0D0221"
    property color surfaceColor: "#240037"
    property color fgColor: "#8F00FF"
    property color accentColor: "#FF00FF"
    property color cyanColor: "#03EDF9"
    property color goldColor: "#F3E70F"
    property color darkBg: "#0A011A"
    property color errorColor: "#FF0040"
    property color successColor: "#00FF41"
    property color textColor: "#FFFFFF"

    // Font
    property string fontFamily: "3270 Nerd Font"
    property int fontSize: 13

    // Stats properties
    property string cpuText: "0%"
    property string memText: "0%"
    property string diskText: "0%"
    property string gpuText: "0%"
    property string volText: "42%"
    property string netText: ""
    property string netIcon: ""
    property string cavaText: ""
    property string weatherText: "--"
    property string windowTitleText: ""
    property string windowIconPath: ""
    property bool idleInhibited: false
    property bool trayExpanded: false

    // Playerctl fallback for browsers that Quickshell Mpris misses
    property string playerctlTitle: ""
    property string playerctlArtist: ""
    property string playerctlStatus: ""
    property bool playerctlActive: false

    // CPU tracking for delta calculation
    property int lastCpuTotal: 0
    property int lastCpuIdle: 0

    // ============================================
    // DETAILED INFO PROPERTIES
    // ============================================
    property string netDownSpeed: "0 KB/s"
    property string netUpSpeed: "0 KB/s"
    property string netInterface: ""
    property string netIpAddr: ""

    property string memUsedGb: "0"
    property string memTotalGb: "0"
    property string memCachedGb: "0"
    property string memBuffersGb: "0"

    property string diskUsedGb: "0"
    property string diskTotalGb: "0"
    property string diskFreeGb: "0"

    property string gpuVramUsed: ""
    property string gpuVramTotal: ""
    property string gpuTemp: ""
    property string gpuModel: ""

    property string cpuCoresText: ""
    property string cpuLoadAvg: ""
    property string cpuModelName: ""

    property string weatherDetailText: ""

    // Popup visibility states
    property bool calendarVisible: false
    property bool weatherDetailVisible: false
    property bool netTooltipVisible: false
    property bool memTooltipVisible: false
    property bool diskTooltipVisible: false
    property bool gpuTooltipVisible: false
    property bool cpuTooltipVisible: false



    // ============================================
    // DATA GATHERING PROCESSES
    // ============================================

    // CPU Process
    Process {
        id: cpuProc
        command: ["sh", "-c", "cat /proc/stat | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                if (line.startsWith('cpu ')) {
                    const parts = line.split(/\s+/).map(Number);
                    const idle = parts[4];
                    const total = parts.slice(1).reduce((a, b) => a + b, 0);
                    if (shell.lastCpuTotal > 0) {
                        const totalDelta = total - shell.lastCpuTotal;
                        const idleDelta = idle - shell.lastCpuIdle;
                        if (totalDelta > 0) {
                            const usage = Math.round(100 * (1 - idleDelta / totalDelta));
                            shell.cpuText = usage + "%";
                        }
                    }
                    shell.lastCpuTotal = total;
                    shell.lastCpuIdle = idle;
                }
            }
        }
    }

    // Memory Process
    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem | awk '{print int($3/$2 * 100)}'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const val = parseInt(data.trim());
                if (!isNaN(val)) {
                    shell.memText = val + "%";
                }
            }
        }
    }

    // Detailed Memory Process
    Process {
        id: memDetailProc
        command: ["sh", "-c", "free -m | grep Mem | awk '{printf \"%.1f|%.1f|%.1f|%.1f\", $3/1024,$2/1024,$7/1024,$6/1024}'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split('|');
                if (parts.length >= 4) {
                    shell.memUsedGb = parts[0];
                    shell.memTotalGb = parts[1];
                    shell.memCachedGb = parts[2];
                    shell.memBuffersGb = parts[3];
                }
            }
        }
    }

    // Disk Process
    Process {
        id: diskProc
        command: ["sh", "-c", "df -h / | tail -1 | awk '{print $5}' | sed 's/%//'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const val = parseInt(data.trim());
                if (!isNaN(val)) {
                    shell.diskText = val + "%";
                }
            }
        }
    }

    // Detailed Disk Process
    Process {
        id: diskDetailProc
        command: ["sh", "-c", "df -BG / | tail -1 | awk '{print $3+0\"|\"$2+0\"|\"$4+0}'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split('|');
                if (parts.length >= 3) {
                    shell.diskUsedGb = parts[0];
                    shell.diskTotalGb = parts[1];
                    shell.diskFreeGb = parts[2];
                }
            }
        }
    }

    // GPU Process - reads from card1 (RX 9070 XT)
    Process {
        id: gpuProc
        command: ["sh", "-c", "cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const val = parseInt(data.trim());
                if (!isNaN(val)) {
                    shell.gpuText = val + "%";
                }
            }
        }
    }

    // Detailed GPU Process
    Process {
        id: gpuDetailProc
        command: ["sh", "-c", "echo 'Sapphire Pulse RX 9070 XT'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                shell.gpuModel = data.trim();
            }
        }
    }

    // GPU Temperature Process - reads from card1 (RX 9070 XT)
    Process {
        id: gpuTempProc
        command: ["sh", "-c", "cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1 | awk '{print int($1/1000)}' || echo ''"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const val = data.trim();
                shell.gpuTemp = val ? val + "°C" : "";
            }
        }
    }

    // GPU VRAM Process - reads from card1 (RX 9070 XT)
    Process {
        id: gpuVramProc
        command: ["sh", "-c", "cat /sys/class/drm/card1/device/mem_info_vram_used 2>/dev/null | awk '{printf \"%.0f\", $1/1048576}' || echo ''"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const val = data.trim();
                shell.gpuVramUsed = val ? val + " MB" : "";
            }
        }
    }

    // GPU VRAM Total Process - reads from card1 (RX 9070 XT)
    Process {
        id: gpuVramTotalProc
        command: ["sh", "-c", "cat /sys/class/drm/card1/device/mem_info_vram_total 2>/dev/null | awk '{printf \"%.0f\", $1/1048576}' || echo ''"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const val = data.trim();
                shell.gpuVramTotal = val ? val + " MB" : "";
            }
        }
    }

    // Volume Process
    Process {
        id: volProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o '[0-9.]*' | head -1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const val = parseFloat(data.trim());
                if (!isNaN(val)) {
                    shell.volText = Math.round(val * 100) + "%";
                }
            }
        }
    }

    // Network Process
    Process {
        id: netProc
        command: ["/home/synth/.config/quickshell/scripts/quickshell_network.sh"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split('|');
                if (parts.length >= 3) {
                    const type = parts[0];
                    const name = parts[1];
                    const signal = parts[2];
                    if (type === "wifi") {
                        shell.netIcon = "\uf1eb";
                        shell.netText = name;
                    } else if (type === "eth") {
                        shell.netIcon = "\uf0e8";
                        shell.netText = "Eth";
                    } else {
                        shell.netIcon = "\uf071";
                        shell.netText = "Off";
                    }
                }
            }
        }
    }

    // Network Speed Process
    Process {
        id: netSpeedProc
        command: ["sh", "-c", "iface=$(ip route | grep default | awk '{print $5}' | head -1); if [ -z \"$iface\" ]; then echo \"0|0|No interface|\"; exit; fi; rx1=$(cat /sys/class/net/$iface/statistics/rx_bytes 2>/dev/null || echo 0); tx1=$(cat /sys/class/net/$iface/statistics/tx_bytes 2>/dev/null || echo 0); sleep 1; rx2=$(cat /sys/class/net/$iface/statistics/rx_bytes 2>/dev/null || echo 0); tx2=$(cat /sys/class/net/$iface/statistics/tx_bytes 2>/dev/null || echo 0); rx=$(( ($rx2 - $rx1) / 1024 )); tx=$(( ($tx2 - $tx1) / 1024 )); ip=$(ip addr show $iface 2>/dev/null | grep 'inet ' | awk '{print $2}' | head -1 | cut -d/ -f1); echo \"$rx|$tx|$iface|$ip\""]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split('|');
                if (parts.length >= 4) {
                    const rx = parseInt(parts[0]);
                    const tx = parseInt(parts[1]);
                    shell.netDownSpeed = rx >= 1024 ? (rx/1024).toFixed(1) + " MB/s" : rx + " KB/s";
                    shell.netUpSpeed = tx >= 1024 ? (tx/1024).toFixed(1) + " MB/s" : tx + " KB/s";
                    shell.netInterface = parts[2];
                    shell.netIpAddr = parts[3];
                }
            }
        }
    }

    // CPU Detail Process
    Process {
        id: cpuDetailProc
        command: ["sh", "-c", "load=$(cat /proc/loadavg | awk '{print $1\"|\"$2\"|\"$3}'); model=$(grep 'model name' /proc/cpuinfo | head -1 | sed 's/.*: //' | sed 's/(R)//g' | sed 's/(TM)//g' | sed 's/CPU //g' | sed 's/ @.*//'); cores=$(nproc); echo \"$load|$model|$cores\""]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split('|');
                if (parts.length >= 5) {
                    shell.cpuLoadAvg = parts[0] + " / " + parts[1] + " / " + parts[2];
                    shell.cpuModelName = parts[3];
                    shell.cpuCoresText = parts[4];
                }
            }
        }
    }

    // Idle inhibitor check process
    Process {
        id: idleCheckProc
        command: ["sh", "-c", "pgrep -x hypridle > /dev/null && echo active || echo inactive"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                shell.idleInhibited = data.trim() !== "active";
            }
        }
    }

    // Window title process
    Process {
        id: titleProc
        command: ["sh", "-c", "hyprctl activewindow | grep class: | sed 's/^[^:]*: //'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const cls = data.trim();
                shell.windowTitleText = cls;
                iconProc.command = ["/home/synth/.config/quickshell/scripts/quickshell_icon.sh", cls];
                iconProc.running = true;
            }
        }
    }

    // Window icon process
    Process {
        id: iconProc
        command: ["echo", ""]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const path = data.trim();
                if (path && path.startsWith("/")) {
                    shell.windowIconPath = "file://" + path;
                } else {
                    shell.windowIconPath = "";
                }
            }
        }
    }

    // Cava process
    Process {
        id: cavaProc
        command: ["sh", "-c", "config_file=/tmp/quickshell_cava_config; cat > $config_file <<'EOF'
[general]
bars = 16
framerate = 30
autosens = 1
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF
cava -p $config_file"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const bars = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"];
                const nums = data.split(';').map(n => parseInt(n) || 0);
                let out = "";
                for (const n of nums) {
                    const idx = Math.max(0, Math.min(7, n));
                    out += bars[idx];
                }
                shell.cavaText = out;
            }
        }
    }

    // Weather process
    Process {
        id: weatherProc
        command: ["sh", "-c", "wttrbar --nerd --fahrenheit --location 'Mulberry,Florida' 2>/dev/null | head -1 || echo '{\"text\":\"--\"}'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    const json = JSON.parse(data);
                    shell.weatherText = json.text || "--";
                } catch (e) {
                    shell.weatherText = data.trim() || "--";
                }
            }
        }
    }

    // Weather detail process
    Process {
        id: weatherDetailProc
        command: ["sh", "-c", "curl -s 'wttr.in/Mulberry,Florida?format=%l:+%c+%t+%w+%h+%p+%P\\n' 2>/dev/null || echo 'Weather unavailable'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                shell.weatherDetailText = data.trim();
            }
        }
    }

    // Calendar data computed inline in QML — no process needed
    property var calendarWeeks: {
        const now = new Date();
        const year = now.getFullYear();
        const month = now.getMonth();
        const firstDay = new Date(year, month, 1).getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        const weeks = [];
        let week = [];
        // Monday-start: shift Sunday (0) to 6, others back by 1
        const start = firstDay === 0 ? 6 : firstDay - 1;
        for (let i = 0; i < start; i++) week.push(0);
        for (let d = 1; d <= daysInMonth; d++) {
            week.push(d);
            if (week.length === 7) {
                weeks.push(week);
                week = [];
            }
        }
        while (week.length > 0 && week.length < 7) week.push(0);
        if (week.length > 0) weeks.push(week);
        return weeks;
    }
    property int calendarToday: new Date().getDate()

    // Playerctl fallback process - polls for browser MPRIS that Quickshell misses
    Process {
        id: playerctlProc
        command: ["sh", "-c", "playerctl metadata --format '{{title}}|{{artist}}|{{status}}' 2>/dev/null || echo '||'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split('|');
                if (parts.length >= 3) {
                    shell.playerctlTitle = parts[0] || "";
                    shell.playerctlArtist = parts[1] || "";
                    shell.playerctlStatus = parts[2] || "";
                    shell.playerctlActive = parts[0] !== "";
                } else {
                    shell.playerctlActive = false;
                }
            }
        }
    }

    // MPRIS - Direct QML property bindings
    property var firstPlayer: {
        if (Mpris.players.length === 0) return null;
        for (let i = 0; i < Mpris.players.length; i++) {
            const p = Mpris.players[i];
            if (p.trackTitle && p.trackTitle !== "") return p;
        }
        return Mpris.players[0];
    }

    property string trackTitle: firstPlayer ? (firstPlayer.trackTitle || "") : shell.playerctlTitle
    property string trackArtist: firstPlayer ? (firstPlayer.trackArtist || "") : shell.playerctlArtist
    property bool isPlaying: {
        if (firstPlayer && firstPlayer.playbackState !== undefined) {
            return firstPlayer.playbackState === MprisPlaybackState.Playing;
        }
        return shell.playerctlStatus === "Playing";
    }
    property bool hasMusic: trackTitle !== "" || shell.playerctlTitle !== ""
    property int currentWorkspaceId: 0

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            if (Hyprland.focusedWorkspace) {
                shell.currentWorkspaceId = Hyprland.focusedWorkspace.id;
            }
        }
    }

    // Hyprland event handler for window title and workspace focus
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activewindow" || event.name === "activewindowv2") {
                titleProc.running = true;
            }
            if (event.name === "workspace" || event.name === "workspacev2") {
                if (Hyprland.focusedWorkspace) {
                    shell.currentWorkspaceId = Hyprland.focusedWorkspace.id;
                }
            }
        }
    }

    // Stats refresh timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            diskProc.running = true;
            gpuProc.running = true;
            volProc.running = true;
            netProc.running = true;
            idleCheckProc.running = true;
            playerctlProc.running = true;
        }
    }

    Timer {
        interval: 300000
        running: true
        repeat: true
        onTriggered: weatherProc.running = true
    }



    // ============================================
    // CALENDAR POPUP
    // ============================================
    PopupWindow {
        id: calendarPopup
        visible: shell.calendarVisible && shell.activeBarWindow !== null && shell.calendarAnchorItem !== null
        implicitWidth: 320
        implicitHeight: calendarCol.implicitHeight + 24

        anchor {
            item: shell.calendarAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: shell.darkBg
            border.color: shell.fgColor
            border.width: 1

            MouseArea {
                anchors.fill: parent
                onClicked: mouse => mouse.accepted = true
                onPressed: mouse => mouse.accepted = true
            }

            Column {
                id: calendarCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: Qt.formatDateTime(new Date(), "MMMM yyyy")
                    font.family: shell.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                    color: shell.accentColor
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: shell.surfaceColor
                }

                // Day-of-week headers
                Row {
                    spacing: 0
                    Repeater {
                        model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                        Text {
                            text: modelData
                            width: 40
                            horizontalAlignment: Text.AlignHCenter
                            font.family: shell.fontFamily
                            font.pixelSize: 11
                            font.bold: true
                            color: shell.fgColor
                        }
                    }
                }

                // Calendar grid
                Column {
                    spacing: 2
                    Repeater {
                        model: shell.calendarWeeks
                        Row {
                            spacing: 0
                            Repeater {
                                model: modelData
                                Rectangle {
                                    width: 40
                                    height: 28
                                    radius: 3
                                    color: modelData === shell.calendarToday ? shell.fgColor : "transparent"
                                    visible: modelData !== 0
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        font.family: shell.fontFamily
                                        font.pixelSize: 12
                                        color: modelData === shell.calendarToday ? shell.darkBg : shell.textColor
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ============================================
    // WEATHER DETAIL POPUP
    // ============================================
    PopupWindow {
        id: weatherDetailPopup
        visible: shell.weatherDetailVisible && shell.activeBarWindow !== null && shell.weatherAnchorItem !== null
        implicitWidth: 320
        implicitHeight: weatherDetailCol.implicitHeight + 24

        anchor {
            item: shell.weatherAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: shell.darkBg
            border.color: shell.fgColor
            border.width: 1

            MouseArea {
                anchors.fill: parent
                onClicked: mouse => mouse.accepted = true
                onPressed: mouse => mouse.accepted = true
            }

            Column {
                id: weatherDetailCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "Weather — Mulberry, FL"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.accentColor
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: shell.surfaceColor
                }

                Text {
                    text: shell.weatherDetailText
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.textColor
                    wrapMode: Text.Wrap
                    width: parent.width
                }
            }
        }
    }

    // ============================================
    // NETWORK TOOLTIP POPUP
    // ============================================
    PopupWindow {
        id: netTooltipPopup
        visible: shell.netTooltipVisible && shell.activeBarWindow !== null && shell.netAnchorItem !== null
        implicitWidth: 220
        implicitHeight: netTooltipCol.implicitHeight + 24

        anchor {
            item: shell.netAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: shell.darkBg
            border.color: shell.fgColor
            border.width: 1

            Column {
                id: netTooltipCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Text {
                    text: "Network"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.accentColor
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: shell.surfaceColor
                }

                Row {
                    spacing: 8
                    Text {
                        text: "\uf019"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        color: shell.cyanColor
                    }
                    Text {
                        text: "Down: " + shell.netDownSpeed
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        color: shell.textColor
                    }
                }

                Row {
                    spacing: 8
                    Text {
                        text: "\uf093"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        color: shell.accentColor
                    }
                    Text {
                        text: "Up: " + shell.netUpSpeed
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        color: shell.textColor
                    }
                }

                Text {
                    text: "Interface: " + shell.netInterface
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                    visible: shell.netInterface !== ""
                }

                Text {
                    text: "IP: " + shell.netIpAddr
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                    visible: shell.netIpAddr !== ""
                }
            }
        }
    }

    // ============================================
    // MEMORY TOOLTIP POPUP
    // ============================================
    PopupWindow {
        id: memTooltipPopup
        visible: shell.memTooltipVisible && shell.activeBarWindow !== null && shell.memAnchorItem !== null
        implicitWidth: 200
        implicitHeight: memTooltipCol.implicitHeight + 24

        anchor {
            item: shell.memAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: shell.darkBg
            border.color: shell.fgColor
            border.width: 1

            Column {
                id: memTooltipCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Text {
                    text: "Memory"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.accentColor
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: shell.surfaceColor
                }

                Text {
                    text: "Used: " + shell.memUsedGb + " / " + shell.memTotalGb + " GB"
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.textColor
                }

                Text {
                    text: "Usage: " + shell.memText
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.fgColor
                }

                Text {
                    text: "Cached: " + shell.memCachedGb + " GB"
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                }

                Text {
                    text: "Buffers: " + shell.memBuffersGb + " GB"
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                }
            }
        }
    }

    // ============================================
    // DISK TOOLTIP POPUP
    // ============================================
    PopupWindow {
        id: diskTooltipPopup
        visible: shell.diskTooltipVisible && shell.activeBarWindow !== null && shell.diskAnchorItem !== null
        implicitWidth: 200
        implicitHeight: diskTooltipCol.implicitHeight + 24

        anchor {
            item: shell.diskAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: shell.darkBg
            border.color: shell.fgColor
            border.width: 1

            Column {
                id: diskTooltipCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Text {
                    text: "Storage"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.accentColor
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: shell.surfaceColor
                }

                Text {
                    text: "Used: " + shell.diskUsedGb + " / " + shell.diskTotalGb + " GB"
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.textColor
                }

                Text {
                    text: "Free: " + shell.diskFreeGb + " GB"
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.successColor
                }

                Text {
                    text: "Usage: " + shell.diskText
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.fgColor
                }
            }
        }
    }

    // ============================================
    // GPU TOOLTIP POPUP
    // ============================================
    PopupWindow {
        id: gpuTooltipPopup
        visible: shell.gpuTooltipVisible && shell.activeBarWindow !== null && shell.gpuAnchorItem !== null
        implicitWidth: 220
        implicitHeight: gpuTooltipCol.implicitHeight + 24

        anchor {
            item: shell.gpuAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: shell.darkBg
            border.color: shell.fgColor
            border.width: 1

            Column {
                id: gpuTooltipCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Text {
                    text: "GPU"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.accentColor
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: shell.surfaceColor
                }

                Text {
                    text: shell.gpuModel
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                    wrapMode: Text.Wrap
                    width: parent.width
                    visible: shell.gpuModel !== ""
                }

                Text {
                    text: "Usage: " + shell.gpuText
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.textColor
                }

                Text {
                    text: "VRAM: " + shell.gpuVramUsed + (shell.gpuVramTotal !== "" ? " / " + shell.gpuVramTotal : "")
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                    visible: shell.gpuVramUsed !== ""
                }

                Text {
                    text: "Temp: " + shell.gpuTemp
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.gpuTemp !== "" && parseInt(shell.gpuTemp) > 80 ? shell.errorColor : shell.fgColor
                    visible: shell.gpuTemp !== ""
                }
            }
        }
    }

    // ============================================
    // CPU TOOLTIP POPUP
    // ============================================
    PopupWindow {
        id: cpuTooltipPopup
        visible: shell.cpuTooltipVisible && shell.activeBarWindow !== null && shell.cpuAnchorItem !== null
        implicitWidth: 260
        implicitHeight: cpuTooltipCol.implicitHeight + 24

        anchor {
            item: shell.cpuAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            anchors.fill: parent
            radius: 4
            color: shell.darkBg
            border.color: shell.fgColor
            border.width: 1

            Column {
                id: cpuTooltipCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Text {
                    text: "CPU"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.accentColor
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: shell.surfaceColor
                }

                Text {
                    text: shell.cpuModelName
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                    wrapMode: Text.Wrap
                    width: parent.width
                    visible: shell.cpuModelName !== ""
                }

                Text {
                    text: "Cores: " + shell.cpuCoresText
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                    visible: shell.cpuCoresText !== ""
                }

                Text {
                    text: "Usage: " + shell.cpuText
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.textColor
                }

                Text {
                    text: "Load: " + shell.cpuLoadAvg
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fgColor
                    visible: shell.cpuLoadAvg !== ""
                }
            }
        }
    }

    // ============================================
    // ANCHOR ITEM PROPERTIES (moved to top of ShellRoot)
    // ============================================

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            color: shell.surfaceColor
            implicitHeight: 32

            anchors {
                top: true
                left: true
                right: true
            }

            // Root item with three children: left, center, right
            // Center uses x binding for true screen-center regardless of side widths
            Item {
                anchors.fill: parent

                // ============================================
                // LEFT SECTION
                // ============================================
                RowLayout {
                    id: leftSection
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    spacing: 0

                    // Omarchy logo
                    Rectangle {
                        Layout.preferredWidth: 36
                        Layout.fillHeight: true
                        color: mouseOmarchy.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            anchors.centerIn: parent
                            text: "\ue900"
                            font.family: "omarchy"
                            font.pixelSize: 16
                            color: mouseOmarchy.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: mouseOmarchy
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: event => {
                                if (event.button == Qt.RightButton) {
                                    var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-menu", "system"] }', shell);
                                    proc.running = true;
                                } else {
                                    var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-menu"] }', shell);
                                    proc.running = true;
                                }
                            }
                        }
                    }

                    // Workspaces — exactly 8, always visible
                    RowLayout {
                        spacing: 2

                        Repeater {
                            model: {
                                const all = Array.from(Hyprland.workspaces.values).sort((a, b) => Number(a.id) - Number(b.id));
                                const result = [];
                                for (let i = 1; i <= 8; i++) {
                                    const ws = all.find(w => Number(w.id) === i);
                                    if (ws) {
                                        result.push(ws);
                                    } else {
                                        result.push({id: i, hasWindows: false, dummy: true});
                                    }
                                }
                                return result;
                            }

                            Rectangle {
                                required property var modelData
                                property var ws: modelData || {id: 0, hasWindows: false, dummy: true}
                                property bool isDummy: !ws || ws.dummy === true
                                property bool isFocused: !isDummy && Number(ws.id) === Number(shell.currentWorkspaceId)
                                property bool hasWin: !isDummy && ws.hasWindows

                                Layout.preferredWidth: 28
                                Layout.fillHeight: true
                                color: isFocused ? shell.fgColor : (wsMouse.containsMouse ? shell.fgColor : "#240037")
                                border.color: isFocused ? "#000000" : "transparent"
                                border.width: isFocused ? 1 : 0

                                Text {
                                    anchors.centerIn: parent
                                    text: ws.id
                                    font.family: shell.fontFamily
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: isFocused ? shell.darkBg : (wsMouse.containsMouse ? shell.darkBg : shell.fgColor)
                                }

                                MouseArea {
                                    id: wsMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["hyprctl", "dispatch", "workspace", "' + ws.id + '"] }', shell);
                                        proc.running = true;
                                    }
                                }
                            }
                        }
                    }

                    // Active window icon + title
                    Rectangle {
                        Layout.preferredWidth: activeWindowRow.width + 16
                        Layout.fillHeight: true
                        color: shell.surfaceColor
                        visible: shell.windowTitleText !== ""

                        Row {
                            id: activeWindowRow
                            anchors.centerIn: parent
                            spacing: 6

                            Image {
                                visible: shell.windowIconPath !== ""
                                source: shell.windowIconPath
                                width: 16
                                height: 16
                            }

                            Text {
                                text: shell.windowTitleText
                                font.family: shell.fontFamily
                                font.pixelSize: shell.fontSize
                                color: shell.fgColor
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }
                        }
                    }

                    // Cava visualizer
                    Rectangle {
                        Layout.preferredWidth: cavaTxt.width + 16
                        Layout.fillHeight: true
                        color: shell.surfaceColor
                        visible: shell.cavaText !== ""

                        Text {
                            id: cavaTxt
                            anchors.centerIn: parent
                            text: shell.cavaText
                            font.family: shell.fontFamily
                            font.pixelSize: 11
                            color: shell.fgColor
                        }
                    }

                    // MPRIS Music Controls
                    Rectangle {
                        Layout.preferredWidth: musicRow.width + 20
                        Layout.fillHeight: true
                        color: shell.surfaceColor

                        Row {
                            id: musicRow
                            anchors.centerIn: parent
                            spacing: 8

                            // Previous track
                            Text {
                                text: "\uf049"
                                font.family: shell.fontFamily
                                font.pixelSize: 11
                                color: prevMouse.containsMouse ? shell.accentColor : shell.fgColor

                                MouseArea {
                                    id: prevMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: shell.musicPrevious()
                                }
                            }

                            // Play/Pause
                            Text {
                                text: shell.isPlaying ? "\uf04c" : "\uf04b"
                                font.family: shell.fontFamily
                                font.pixelSize: 11
                                color: playMouse.containsMouse ? shell.accentColor : shell.fgColor

                                MouseArea {
                                    id: playMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: shell.musicPlayPause()
                                }
                            }

                            // Next track
                            Text {
                                text: "\uf050"
                                font.family: shell.fontFamily
                                font.pixelSize: 11
                                color: nextMouse.containsMouse ? shell.accentColor : shell.fgColor

                                MouseArea {
                                    id: nextMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: shell.musicNext()
                                }
                            }

                            // Track info
                            Text {
                                text: (shell.trackArtist ? shell.trackArtist + " - " : "") + shell.trackTitle
                                font.family: shell.fontFamily
                                font.pixelSize: shell.fontSize
                                color: shell.fgColor
                                elide: Text.ElideRight
                                maximumLineCount: 1
                                visible: shell.hasMusic
                            }

                            // No music fallback
                            Text {
                                text: "\uf001 No music"
                                font.family: shell.fontFamily
                                font.pixelSize: shell.fontSize
                                color: shell.fgColor
                                visible: !shell.hasMusic
                            }
                        }
                    }
                }

                // ============================================
                // CENTER SECTION — anchored to true screen center
                // ============================================
                RowLayout {
                    id: centerSection
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    x: (parent.width - width) / 2
                    spacing: 0

                    // Clock
                    Rectangle {
                        Layout.preferredWidth: clockText.width + 20
                        Layout.fillHeight: true
                        color: clockMouseArea.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            id: clockText
                            anchors.centerIn: parent
                            text: Qt.formatDateTime(new Date(), "dddd h:mm AP")
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: clockMouseArea.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: clockMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            z: 10
                            onClicked: {
                                shell.activeBarWindow = bar;
                                shell.calendarAnchorItem = clockMouseArea;
                                shell.calendarVisible = !shell.calendarVisible;
                            }

                        }

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "dddd h:mm AP")
                        }
                    }

                    // Weather
                    Rectangle {
                        Layout.preferredWidth: weatherLabel.width + 16
                        Layout.fillHeight: true
                        color: weatherMouseArea.containsMouse ? shell.fgColor : shell.surfaceColor
                        visible: shell.weatherText !== "--"

                        Text {
                            id: weatherLabel
                            anchors.centerIn: parent
                            text: shell.weatherText
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            color: weatherMouseArea.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: weatherMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            z: 10
                            onClicked: {
                                shell.activeBarWindow = bar;
                                shell.weatherAnchorItem = weatherMouseArea;
                                shell.weatherDetailVisible = !shell.weatherDetailVisible;
                                if (shell.weatherDetailVisible) {
                                    weatherDetailProc.running = true;
                                }
                            }

                        }
                    }
                }

                // ============================================
                // RIGHT SECTION
                // ============================================
                RowLayout {
                    id: rightSection
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    spacing: 0

                    // System Tray
                    Rectangle {
                        Layout.preferredWidth: trayLayout.width
                        Layout.fillHeight: true
                        color: shell.surfaceColor

                        Row {
                            id: trayLayout
                            anchors.centerIn: parent
                            spacing: 0

                            // Expand arrow
                            Rectangle {
                                width: 20
                                height: bar.implicitHeight
                                color: trayArrowMouse.containsMouse ? shell.fgColor : shell.surfaceColor

                                Text {
                                    anchors.centerIn: parent
                                    text: shell.trayExpanded ? "\uf077" : "\uf078"
                                    font.family: shell.fontFamily
                                    font.pixelSize: 10
                                    color: trayArrowMouse.containsMouse ? shell.darkBg : shell.fgColor
                                }

                                MouseArea {
                                    id: trayArrowMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: shell.trayExpanded = !shell.trayExpanded
                                }
                            }

                            // Tray icons container
                            Row {
                                id: trayRow
                                spacing: 2
                                visible: shell.trayExpanded

                                Repeater {
                                    model: ScriptModel {
                                        values: [...SystemTray.items.values]
                                    }

                                    Rectangle {
                                        required property SystemTrayItem modelData
                                        property SystemTrayItem trayItem: modelData

                                        width: 24
                                        height: bar.implicitHeight
                                        color: trayItemMouse.containsMouse ? shell.fgColor : shell.surfaceColor

                                        IconImage {
                                            anchors.centerIn: parent
                                            source: trayItem.icon
                                            implicitSize: 14
                                        }

                                        MouseArea {
                                            id: trayItemMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                                            onClicked: event => {
                                                if (event.button == Qt.LeftButton) {
                                                    trayItem.activate();
                                                } else if (event.button == Qt.MiddleButton) {
                                                    trayItem.secondaryActivate();
                                                } else if (event.button == Qt.RightButton) {
                                                    if (trayItem.hasMenu && trayItem.menu) {
                                                        if (shell.trayMenuVisible && shell.activeMenuAnchorItem === trayItemMouse) {
                                                            shell.trayMenuVisible = false;
                                                        } else {
                                                            shell.activeMenuHandle = trayItem.menu;
                                                            shell.activeMenuAnchorItem = trayItemMouse;
                                                            menuOpener.menu = trayItem.menu;
                                                            shell.trayMenuVisible = true;
                                                        }
                                                    } else {
                                                        trayItem.activate();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Idle Inhibitor
                    Rectangle {
                        Layout.preferredWidth: idleLabel.width + 16
                        Layout.fillHeight: true
                        color: idleMouse.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            id: idleLabel
                            anchors.centerIn: parent
                            text: shell.idleInhibited ? "\uf09c" : "\uf023"
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: idleMouse.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: idleMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-toggle-idle"] }', shell);
                                proc.running = true;
                                idleCheckProc.running = true;
                            }
                        }
                    }

                    // Network
                    Rectangle {
                        Layout.preferredWidth: netLabel.width + 16
                        Layout.fillHeight: true
                        color: netMouseArea.containsMouse ? shell.fgColor : shell.surfaceColor
                        visible: shell.netText !== ""

                        Text {
                            id: netLabel
                            anchors.centerIn: parent
                            text: shell.netIcon + " " + shell.netText
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: netMouseArea.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: netMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                shell.activeBarWindow = bar;
                                shell.netAnchorItem = netMouseArea;
                                shell.netTooltipVisible = true;
                                netSpeedProc.running = true;
                            }
                            onExited: shell.netTooltipVisible = false
                            onClicked: {
                                var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-launch-wifi"] }', shell);
                                proc.running = true;
                            }

                        }
                    }

                    // Disk
                    Rectangle {
                        Layout.preferredWidth: diskLabel.width + 16
                        Layout.fillHeight: true
                        color: diskMouseArea.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            id: diskLabel
                            anchors.centerIn: parent
                            text: "\uf0a0 " + shell.diskText
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: diskMouseArea.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: diskMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                shell.activeBarWindow = bar;
                                shell.diskAnchorItem = diskMouseArea;
                                shell.diskTooltipVisible = true;
                                diskDetailProc.running = true;
                            }
                            onExited: shell.diskTooltipVisible = false
                            onClicked: {
                                var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-launch-or-focus-tui", "btop"] }', shell);
                                proc.running = true;
                            }

                        }
                    }

                    // Memory
                    Rectangle {
                        Layout.preferredWidth: memLabel.width + 16
                        Layout.fillHeight: true
                        color: memMouseArea.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            id: memLabel
                            anchors.centerIn: parent
                            text: "\uefc5 " + shell.memText
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: memMouseArea.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: memMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                shell.activeBarWindow = bar;
                                shell.memAnchorItem = memMouseArea;
                                shell.memTooltipVisible = true;
                                memDetailProc.running = true;
                            }
                            onExited: shell.memTooltipVisible = false
                            onClicked: {
                                var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-launch-or-focus-tui", "btop"] }', shell);
                                proc.running = true;
                            }

                        }
                    }

                    // GPU
                    Rectangle {
                        Layout.preferredWidth: gpuLabel.width + 16
                        Layout.fillHeight: true
                        color: gpuMouseArea.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            id: gpuLabel
                            anchors.centerIn: parent
                            text: "\uf108 " + shell.gpuText
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: gpuMouseArea.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: gpuMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                shell.activeBarWindow = bar;
                                shell.gpuAnchorItem = gpuMouseArea;
                                shell.gpuTooltipVisible = true;
                                gpuDetailProc.running = true;
                                gpuTempProc.running = true;
                                gpuVramProc.running = true;
                                gpuVramTotalProc.running = true;
                            }
                            onExited: shell.gpuTooltipVisible = false
                            onClicked: {
                                var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-launch-or-focus-tui", "btop"] }', shell);
                                proc.running = true;
                            }

                        }
                    }

                    // CPU
                    Rectangle {
                        Layout.preferredWidth: cpuLabel.width + 16
                        Layout.fillHeight: true
                        color: cpuMouseArea.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            id: cpuLabel
                            anchors.centerIn: parent
                            text: "\uf2db " + shell.cpuText
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: cpuMouseArea.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: cpuMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                shell.activeBarWindow = bar;
                                shell.cpuAnchorItem = cpuMouseArea;
                                shell.cpuTooltipVisible = true;
                                cpuDetailProc.running = true;
                            }
                            onExited: shell.cpuTooltipVisible = false
                            onClicked: {
                                var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["omarchy-launch-or-focus-tui", "btop"] }', shell);
                                proc.running = true;
                            }

                        }
                    }

                    // Volume
                    Rectangle {
                        Layout.preferredWidth: volLabel.width + 16
                        Layout.fillHeight: true
                        color: volMouse.containsMouse ? shell.fgColor : shell.surfaceColor

                        Text {
                            id: volLabel
                            anchors.centerIn: parent
                            text: "\uf028 " + shell.volText
                            font.family: shell.fontFamily
                            font.pixelSize: shell.fontSize
                            font.bold: true
                            color: volMouse.containsMouse ? shell.darkBg : shell.fgColor
                        }

                        MouseArea {
                            id: volMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["ghostty", "--class=Wiremix", "-e", "wiremix"] }', shell);
                                proc.running = true;
                            }
                        }
                    }
                }
            }
        }
    }

    // ============================================
    // CUSTOM STYLED TRAY MENU POPUP
    // ============================================
    property var activeMenuHandle: null
    property var activeMenuAnchorItem: null
    property bool trayMenuVisible: false

    // Full-screen invisible overlay that catches clicks outside the menu
    PanelWindow {
        id: menuOverlay
        visible: shell.trayMenuVisible
        color: "transparent"
        anchors { top: true; bottom: true; left: true; right: true }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-traymenu-overlay"

        MouseArea {
            anchors.fill: parent
            onClicked: shell.trayMenuVisible = false
        }
    }

    PopupWindow {
        id: customMenu
        visible: shell.trayMenuVisible && shell.activeMenuAnchorItem !== null
        implicitWidth: 220
        implicitHeight: menuCol.implicitHeight + 16
        color: "transparent"

        anchor {
            item: shell.activeMenuAnchorItem
            edges: Edges.Bottom
            gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipY | PopupAdjustment.SlideX
        }

        Rectangle {
            id: menuCard
            anchors.fill: parent
            radius: 4
            color: "#1a0b2e"
            border.color: shell.fgColor
            border.width: 1

            // Block mouse events from propagating to the overlay
            MouseArea {
                anchors.fill: parent
                onClicked: mouse => mouse.accepted = true
                onPressed: mouse => mouse.accepted = true
            }

            Column {
                id: menuCol
                anchors.fill: parent
                anchors.margins: 8
                spacing: 1

                QsMenuOpener {
                    id: menuOpener
                    menu: shell.activeMenuHandle
                }

                Repeater {
                    model: menuOpener.children.values

                    delegate: Item {
                        id: menuEntry
                        required property var modelData
                        width: menuCol.width
                        height: modelData.isSeparator ? 7 : 26

                        // Separator line
                        Rectangle {
                            visible: menuEntry.modelData.isSeparator
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 1
                            color: shell.surfaceColor
                        }

                        // Menu item row
                        Rectangle {
                            visible: !menuEntry.modelData.isSeparator
                            anchors.fill: parent
                            radius: 3
                            color: entryMouse.containsMouse && menuEntry.modelData.enabled
                                ? Qt.rgba(shell.fgColor.r, shell.fgColor.g, shell.fgColor.b, 0.2)
                                : "transparent"

                            // Check indicator
                            Text {
                                id: checkIndicator
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                anchors.verticalCenter: parent.verticalCenter
                                width: 12
                                text: menuEntry.modelData.checkState === Qt.Checked ? "\uf00c" : ""
                                color: shell.accentColor
                                font.family: shell.fontFamily
                                font.pixelSize: 10
                            }

                            // Icon
                            IconImage {
                                id: entryIconImg
                                anchors.left: checkIndicator.right
                                anchors.leftMargin: 2
                                anchors.verticalCenter: parent.verticalCenter
                                visible: (menuEntry.modelData.icon || "") !== ""
                                source: menuEntry.modelData.icon || ""
                                implicitSize: 14
                                width: visible ? 14 : 0
                                height: 14
                            }

                            // Text
                            Text {
                                anchors.left: entryIconImg.right
                                anchors.leftMargin: 6
                                anchors.right: submenuArrow.left
                                anchors.rightMargin: 4
                                anchors.verticalCenter: parent.verticalCenter
                                text: {
                                    const t = menuEntry.modelData.text || "";
                                    return t.replace(/_([^_])/g, "$1");
                                }
                                color: menuEntry.modelData.enabled ? shell.textColor
                                     : Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.35)
                                font.family: shell.fontFamily
                                font.pixelSize: 12
                                elide: Text.ElideRight
                            }

                            // Submenu arrow
                            Text {
                                id: submenuArrow
                                anchors.right: parent.right
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                                visible: menuEntry.modelData.hasChildren
                                text: "\uf054"
                                color: shell.fgColor
                                font.family: shell.fontFamily
                                font.pixelSize: 9
                            }

                            MouseArea {
                                id: entryMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: menuEntry.modelData.enabled
                                onClicked: {
                                    if (menuEntry.modelData.hasChildren) {
                                        // TODO: submenu support
                                    } else {
                                        menuEntry.modelData.triggered();
                                        shell.trayMenuVisible = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ============================================
    // MUSIC CONTROL FUNCTIONS — MPRIS + playerctl fallback
    // ============================================
    function musicPrevious() {
        if (shell.firstPlayer && shell.firstPlayer.previous) {
            shell.firstPlayer.previous();
        } else {
            var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["playerctl", "previous"] }', shell);
            proc.running = true;
        }
    }

    function musicPlayPause() {
        if (shell.firstPlayer && shell.firstPlayer.playPause) {
            shell.firstPlayer.playPause();
        } else if (shell.firstPlayer && shell.firstPlayer.play) {
            shell.firstPlayer.play();
        } else {
            var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["playerctl", "play-pause"] }', shell);
            proc.running = true;
        }
    }

    function musicNext() {
        if (shell.firstPlayer && shell.firstPlayer.next) {
            shell.firstPlayer.next();
        } else {
            var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["playerctl", "next"] }', shell);
            proc.running = true;
        }
    }
}
