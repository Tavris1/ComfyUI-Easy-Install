#!/bin/bash
# ComfyUI EZi Launcher — graphical launcher for macOS/Linux
# Part of ComfyUI-Easy-Install by Pixaroma / VenimK

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PYTHON_CMD="$SCRIPT_DIR/python_embeded/python"
DESKTOP_VENV="$SCRIPT_DIR/.desktop_venv"

# Colors
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
RESET='\033[0m'

# Verify Python
if [ ! -x "$PYTHON_CMD" ]; then
    if [ -x "$SCRIPT_DIR/python_embeded/bin/python3" ]; then
        PYTHON_CMD="$SCRIPT_DIR/python_embeded/bin/python3"
    elif [ -x "$DESKTOP_VENV/bin/python3" ]; then
        PYTHON_CMD="$DESKTOP_VENV/bin/python3"
    elif command -v python3 >/dev/null 2>&1; then
        echo -e "${YELLOW}No embedded Python found. Creating desktop venv...${RESET}"
        python3 -m venv "$DESKTOP_VENV"
        "$DESKTOP_VENV/bin/python3" -m pip install pywebview -q
        PYTHON_CMD="$DESKTOP_VENV/bin/python3"
        echo -e "${GREEN}Desktop venv ready.${RESET}"
    else
        echo -e "${RED}ERROR: Python not found. Install Python 3.12+ first.${RESET}"
        exit 1
    fi
fi

# ─── LINUX: Check and install GTK/Qt backend for pywebview ───
if [[ "$(uname -s)" == "Linux" ]]; then
    HAS_GTK_BACKEND=0
    HAS_QT_BACKEND=0

    "$PYTHON_CMD" -c "import gi" 2>/dev/null && HAS_GTK_BACKEND=1
    "$PYTHON_CMD" -c "import qtpy; from qtpy import QtWebEngineCore" 2>/dev/null && HAS_QT_BACKEND=1

    if [ "$HAS_GTK_BACKEND" -eq 0 ] && [ "$HAS_QT_BACKEND" -eq 0 ]; then
        echo -e "${YELLOW}No pywebview GUI backend found. Attempting to fix...${RESET}"

        echo -e "${YELLOW}Trying Qt backend (PyQt6 + qtpy + PyQt6-WebEngine)...${RESET}"
        if "$PYTHON_CMD" -m pip install PyQt6 qtpy PyQt6-WebEngine -q 2>/dev/null; then
            "$PYTHON_CMD" -c "import qtpy; from qtpy import QtWebEngineCore" 2>/dev/null && HAS_QT_BACKEND=1 && \
                echo -e "${GREEN}Qt backend installed via pip.${RESET}"
        fi

        if [ "$HAS_QT_BACKEND" -eq 0 ]; then
            echo -e "${YELLOW}Trying GTK backend (PyGObject)...${RESET}"
            if "$PYTHON_CMD" -m pip install PyGObject -q 2>/dev/null; then
                "$PYTHON_CMD" -c "import gi" 2>/dev/null && HAS_GTK_BACKEND=1 && \
                    echo -e "${GREEN}GTK backend installed via pip.${RESET}"
            fi
        fi

        if [ "$HAS_GTK_BACKEND" -eq 0 ] && [ "$HAS_QT_BACKEND" -eq 0 ]; then
            echo -e "${RED}Could not install a pywebview GUI backend automatically.${RESET}"
            echo -e "${YELLOW}Manual fix (GTK, recommended for Ubuntu/Debian):${RESET}"
            echo -e "  sudo apt-get install python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.1"
            echo -e "  SYS_GI=\$(python3 -c \"import gi,os; print(os.path.dirname(gi.__file__))\")"
            echo -e "  ln -s \$SYS_GI \$(./python_embeded/python -c \"import site; print(site.getsitepackages()[0])\")/gi"
            exit 1
        fi
    fi

    if [ "$HAS_GTK_BACKEND" -eq 1 ] && [ "$HAS_QT_BACKEND" -eq 0 ]; then
        export GDK_BACKEND=x11
    fi
fi

# Check if pywebview is available
HAS_WEBVIEW=0
"$PYTHON_CMD" -c "import webview" 2>/dev/null && HAS_WEBVIEW=1

if [ "$HAS_WEBVIEW" -eq 0 ]; then
    echo -e "${YELLOW}pywebview not found — attempting to install...${RESET}"
    if "$PYTHON_CMD" -m pip install pywebview -q 2>/dev/null; then
        "$PYTHON_CMD" -c "import webview" 2>/dev/null && HAS_WEBVIEW=1
    fi
    if [ "$HAS_WEBVIEW" -eq 0 ] && [ -x "$DESKTOP_VENV/bin/python3" ]; then
        echo -e "${YELLOW}Installing pywebview into desktop venv...${RESET}"
        "$DESKTOP_VENV/bin/python3" -m pip install pywebview -q && HAS_WEBVIEW=1
    fi
    if [ "$HAS_WEBVIEW" -eq 0 ]; then
        echo -e "${RED}Could not install pywebview. Please install it manually.${RESET}"
        exit 1
    fi
fi

echo -e "${GREEN}Launching ComfyUI EZi Launcher...${RESET}"
cd "$SCRIPT_DIR"
exec "$PYTHON_CMD" "$SCRIPT_DIR/comfyui_ezi_launcher.py"
