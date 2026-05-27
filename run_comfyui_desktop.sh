#!/bin/bash
# ComfyUI Desktop Launcher — opens ComfyUI in a native window via pywebview
# Part of ComfyUI-Easy-Install by Pixaroma / VenimK
#
# Usage:
#   Local mode:  ./run_comfyui_desktop.sh [--port PORT] [extra ComfyUI args...]
#   Remote mode: ./run_comfyui_desktop.sh --remote HOST[:PORT]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMFYUI_DIR="$SCRIPT_DIR/ComfyUI"
PYTHON_CMD="$SCRIPT_DIR/python_embeded/python"
PID_FILE="$SCRIPT_DIR/.comfyui_server.pid"
HOST="127.0.0.1"
PORT=8188
REMOTE_MODE=0

# Colors
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
RESET='\033[0m'

# Parse arguments
EXTRA_ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --remote)
            if [ -z "$2" ] || [[ "$2" == --* ]]; then
                echo -e "${RED}ERROR: --remote requires a HOST[:PORT] argument${RESET}"
                exit 1
            fi
            REMOTE_MODE=1
            REMOTE_ADDR="$2"
            # Parse HOST:PORT or just HOST
            if echo "$REMOTE_ADDR" | grep -q ':'; then
                HOST="${REMOTE_ADDR%%:*}"
                PORT="${REMOTE_ADDR##*:}"
            else
                HOST="$REMOTE_ADDR"
            fi
            shift 2
            ;;
        --port)
            if [ -z "$2" ] || [[ "$2" == --* ]]; then
                echo -e "${RED}ERROR: --port requires a PORT number${RESET}"
                exit 1
            fi
            PORT="$2"
            shift 2
            ;;
        *)
            EXTRA_ARGS+=("$1")
            shift
            ;;
    esac
done

# Verify Python
DESKTOP_VENV="$SCRIPT_DIR/.desktop_venv"

if [ ! -x "$PYTHON_CMD" ]; then
    # Fallback: try bin/python3 inside python_embeded
    if [ -x "$SCRIPT_DIR/python_embeded/bin/python3" ]; then
        PYTHON_CMD="$SCRIPT_DIR/python_embeded/bin/python3"
    elif [ -x "$DESKTOP_VENV/bin/python3" ]; then
        # Use existing desktop venv
        PYTHON_CMD="$DESKTOP_VENV/bin/python3"
    elif command -v python3 >/dev/null 2>&1; then
        # No embedded python — create a lightweight venv for desktop mode
        echo -e "${YELLOW}No embedded Python found. Creating desktop venv...${RESET}"
        python3 -m venv "$DESKTOP_VENV"
        "$DESKTOP_VENV/bin/python3" -m pip install pywebview -q
        PYTHON_CMD="$DESKTOP_VENV/bin/python3"
        echo -e "${GREEN}Desktop venv ready at ${DESKTOP_VENV}${RESET}"
    else
        echo -e "${RED}ERROR: Python not found. Install Python 3.12+ first.${RESET}"
        exit 1
    fi
fi

# ─── LINUX: Check and install GTK/Qt backend for pywebview ───
if [[ "$(uname -s)" == "Linux" ]]; then
    HAS_GTK_BACKEND=0
    HAS_QT_BACKEND=0

    $PYTHON_CMD -c "import gi" 2>/dev/null && HAS_GTK_BACKEND=1
    $PYTHON_CMD -c "import qtpy" 2>/dev/null && HAS_QT_BACKEND=1

    if [ "$HAS_GTK_BACKEND" -eq 0 ] && [ "$HAS_QT_BACKEND" -eq 0 ]; then
        echo -e "${YELLOW}No pywebview GUI backend found. Attempting to fix...${RESET}"

        # Try pip install of PyGObject first (works if system libgirepository is present)
        if $PYTHON_CMD -m pip install PyGObject -q 2>/dev/null; then
            $PYTHON_CMD -c "import gi" 2>/dev/null && HAS_GTK_BACKEND=1 && \
                echo -e "${GREEN}GTK backend installed via pip.${RESET}"
        fi

        # If pip failed, install system package and symlink into embedded python
        if [ "$HAS_GTK_BACKEND" -eq 0 ]; then
            echo -e "${YELLOW}Trying system package (requires sudo)...${RESET}"
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get install -y python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.1 2>/dev/null || \
                sudo apt-get install -y python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.0 2>/dev/null || true
                SYS_GI=$(python3 -c "import gi; import os; print(os.path.dirname(gi.__file__))" 2>/dev/null)
                EMBED_SITE=$($PYTHON_CMD -c "import site; print(site.getsitepackages()[0])" 2>/dev/null)
                if [ -n "$SYS_GI" ] && [ -n "$EMBED_SITE" ]; then
                    ln -sf "$SYS_GI" "$EMBED_SITE/gi" 2>/dev/null || true
                    $PYTHON_CMD -c "import gi" 2>/dev/null && HAS_GTK_BACKEND=1 && \
                        echo -e "${GREEN}GTK backend linked from system Python.${RESET}"
                fi
            fi
        fi

        # Fallback: Qt backend via pip
        if [ "$HAS_GTK_BACKEND" -eq 0 ] && [ "$HAS_QT_BACKEND" -eq 0 ]; then
            echo -e "${YELLOW}Trying Qt backend (PyQt6 + qtpy)...${RESET}"
            if $PYTHON_CMD -m pip install PyQt6 qtpy -q 2>/dev/null; then
                $PYTHON_CMD -c "import qtpy" 2>/dev/null && HAS_QT_BACKEND=1 && \
                    echo -e "${GREEN}Qt backend installed via pip.${RESET}"
            fi
        fi

        if [ "$HAS_GTK_BACKEND" -eq 0 ] && [ "$HAS_QT_BACKEND" -eq 0 ]; then
            echo -e "${RED}Could not install a pywebview GUI backend automatically.${RESET}"
            echo -e "${YELLOW}Manual fix — Option 1 (GTK, recommended for Ubuntu/Pop!_OS/Debian):${RESET}"
            echo -e "  sudo apt-get install python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.1"
            echo -e "  SYS_GI=\$(python3 -c \"import gi,os; print(os.path.dirname(gi.__file__))\")"
            echo -e "  ln -s \$SYS_GI \$(./python_embeded/python -c \"import site; print(site.getsitepackages()[0])\")/gi"
            echo -e "${YELLOW}Manual fix — Option 2 (Qt, no sudo needed):${RESET}"
            echo -e "  ./python_embeded/python -m pip install PyQt6 qtpy"
            echo -e "${YELLOW}ComfyUI will open in your browser for now.${RESET}"
        fi
    fi
fi

# Check if pywebview is available
HAS_WEBVIEW=0
$PYTHON_CMD -c "import webview" 2>/dev/null && HAS_WEBVIEW=1

if [ "$HAS_WEBVIEW" -eq 0 ]; then
    # Try to install pywebview into the embedded Python first
    echo -e "${YELLOW}pywebview not found — attempting to install...${RESET}"
    if $PYTHON_CMD -m pip install pywebview -q 2>/dev/null; then
        $PYTHON_CMD -c "import webview" 2>/dev/null && HAS_WEBVIEW=1
    fi
    # Fallback: try the desktop venv
    if [ "$HAS_WEBVIEW" -eq 0 ] && [ -x "$DESKTOP_VENV/bin/python3" ]; then
        echo -e "${YELLOW}Installing pywebview into desktop venv...${RESET}"
        "$DESKTOP_VENV/bin/python3" -m pip install pywebview -q && HAS_WEBVIEW=1
    fi
    if [ "$HAS_WEBVIEW" -eq 0 ]; then
        echo -e "${YELLOW}pywebview not installed — ComfyUI will open in your browser${RESET}"
    fi
fi

# ─── REMOTE MODE ───
if [ "$REMOTE_MODE" -eq 1 ]; then
    echo -e "${GREEN}Connecting to remote ComfyUI at ${YELLOW}${HOST}:${PORT}${RESET}"
    export COMFYUI_HOST="$HOST"
    export COMFYUI_PORT="$PORT"
    export COMFYUI_REMOTE=1
    $PYTHON_CMD "$SCRIPT_DIR/comfyui_desktop.py"
    exit 0
fi

# ─── LOCAL MODE ───

# Verify ComfyUI
if [ ! -f "$COMFYUI_DIR/main.py" ]; then
    echo -e "${RED}ERROR: ComfyUI not found at $COMFYUI_DIR${RESET}"
    exit 1
fi

# Cleanup function
cleanup() {
    echo ""
    echo -e "${YELLOW}Shutting down ComfyUI...${RESET}"
    if [ -f "$PID_FILE" ]; then
        SERVER_PID=$(cat "$PID_FILE")
        kill "$SERVER_PID" 2>/dev/null || true
        rm -f "$PID_FILE"
    fi
    # Kill any remaining child processes
    for pid in $(jobs -p 2>/dev/null); do kill "$pid" 2>/dev/null; done || true
    echo -e "${GREEN}ComfyUI stopped.${RESET}"
}
trap cleanup EXIT INT TERM

# Load saved extra launch args from desktop state file
SAVED_ARGS=()
STATE_FILE="$SCRIPT_DIR/.comfyui_desktop_state.json"
if [ -f "$STATE_FILE" ]; then
    SAVED_ARGS_STR=$($PYTHON_CMD -c "
import json, sys
try:
    d = json.load(open('$STATE_FILE'))
    print(d.get('launch_args',''))
except: pass
" 2>/dev/null)
    if [ -n "$SAVED_ARGS_STR" ]; then
        read -ra SAVED_ARGS <<< "$SAVED_ARGS_STR"
        echo -e "${YELLOW}Extra launch args: ${SAVED_ARGS_STR}${RESET}"
    fi
fi

# Start ComfyUI server in the background
echo -e "${GREEN}Starting ComfyUI server on port ${PORT}...${RESET}"
$PYTHON_CMD -W ignore::FutureWarning "$COMFYUI_DIR/main.py" \
    --port "$PORT" \
    --listen 127.0.0.1 \
    "${EXTRA_ARGS[@]}" "${SAVED_ARGS[@]}" &
SERVER_PID=$!
echo "$SERVER_PID" > "$PID_FILE"

# Launch desktop wrapper (it waits for server, then opens window or browser)
export COMFYUI_HOST="$HOST"
export COMFYUI_PORT="$PORT"
export COMFYUI_REMOTE=0
echo -e "${GREEN}Launching EZi Desktop ...${RESET}"
$PYTHON_CMD "$SCRIPT_DIR/comfyui_desktop.py"

# If pywebview window was closed, server will be killed by cleanup trap
# If running in browser mode, wait for the server process
if [ "$HAS_WEBVIEW" -eq 0 ]; then
    echo -e "${YELLOW}ComfyUI is running at http://127.0.0.1:${PORT}${RESET}"
    echo -e "${YELLOW}Press Ctrl+C to stop${RESET}"
    wait "$SERVER_PID" 2>/dev/null || true
fi
