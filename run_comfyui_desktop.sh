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

# Check if pywebview is available
HAS_WEBVIEW=0
$PYTHON_CMD -c "import webview" 2>/dev/null && HAS_WEBVIEW=1

if [ "$HAS_WEBVIEW" -eq 0 ]; then
    # Try to install pywebview into the desktop venv
    if [ -x "$DESKTOP_VENV/bin/python3" ]; then
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
    jobs -p | xargs -r kill 2>/dev/null || true
    echo -e "${GREEN}ComfyUI stopped.${RESET}"
}
trap cleanup EXIT INT TERM

# Start ComfyUI server in the background
echo -e "${GREEN}Starting ComfyUI server on port ${PORT}...${RESET}"
$PYTHON_CMD -W ignore::FutureWarning "$COMFYUI_DIR/main.py" \
    --port "$PORT" \
    --listen 127.0.0.1 \
    "${EXTRA_ARGS[@]}" &
SERVER_PID=$!
echo "$SERVER_PID" > "$PID_FILE"

# Launch desktop wrapper (it waits for server, then opens window or browser)
export COMFYUI_HOST="$HOST"
export COMFYUI_PORT="$PORT"
export COMFYUI_REMOTE=0
echo -e "${GREEN}Launching ComfyUI Desktop...${RESET}"
$PYTHON_CMD "$SCRIPT_DIR/comfyui_desktop.py"

# If pywebview window was closed, server will be killed by cleanup trap
# If running in browser mode, wait for the server process
if [ "$HAS_WEBVIEW" -eq 0 ]; then
    echo -e "${YELLOW}ComfyUI is running at http://127.0.0.1:${PORT}${RESET}"
    echo -e "${YELLOW}Press Ctrl+C to stop${RESET}"
    wait "$SERVER_PID" 2>/dev/null || true
fi
