#!/usr/bin/env python3
"""
ComfyUI EZi Launcher v3.23.0 — macOS/Linux port of the Windows launcher UI.
PyWebView + HTML/CSS/JS single-file application.
Part of ComfyUI-Easy-Install by Pixaroma / VenimK.
"""

import os
import sys
import json
import shutil
import subprocess
import platform
import webbrowser
import base64
from pathlib import Path

EZI_VERSION = "3.23.0"

# ---------------------------------------------------------------------------
# Paths and constants
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
ICON_PATH = SCRIPT_DIR / "comfyui_icon.png"
WINDOW_STATE_FILE = SCRIPT_DIR / ".comfyui_ezi_launcher_state.json"

# ---------------------------------------------------------------------------
# Platform helpers
# ---------------------------------------------------------------------------
def _get_platform():
    system = platform.system()
    machine = platform.machine()
    if system == "Darwin":
        if machine == "arm64":
            return "macos_mps"
        return "macos_intel"
    return "linux"

PLATFORM = _get_platform()
IS_MAC = platform.system() == "Darwin"
IS_LINUX = platform.system() == "Linux"

# ---------------------------------------------------------------------------
# Installation detection
# ---------------------------------------------------------------------------
def is_valid_install_dir(path: Path) -> bool:
    return (path / "ComfyUI").is_dir() and (path / "python_embeded").is_dir()

INSTALL_DIR = SCRIPT_DIR if is_valid_install_dir(SCRIPT_DIR) else None

# ---------------------------------------------------------------------------
# Python binary detection
# ---------------------------------------------------------------------------
def find_python() -> str:
    candidates = [
        SCRIPT_DIR / "python_embeded" / "python",
        SCRIPT_DIR / "python_embeded" / "bin" / "python3",
        SCRIPT_DIR / "python_embeded_3.12" / "bin" / "python3",
        SCRIPT_DIR / "python_embeded_3.11" / "bin" / "python3",
    ]
    for c in candidates:
        if c.exists() and os.access(c, os.X_OK):
            return str(c)
    return sys.executable

PYTHON_EXEC = find_python()

# ---------------------------------------------------------------------------
# Script / asset discovery
# ---------------------------------------------------------------------------
def script_exists(name: str) -> bool:
    return (SCRIPT_DIR / name).exists()

def is_addon_installed(name: str) -> bool:
    """Check whether an add-on marker or folder exists in ComfyUI/custom_nodes."""
    custom_nodes = SCRIPT_DIR / "ComfyUI" / "custom_nodes"
    if not custom_nodes.is_dir():
        return False
    markers = {
        "sageattention": ["ComfyUI-SageAttention", "sageattention"],
        "flashattention": ["ComfyUI-FlashAttention", "flash_attn"],
        "kitchenattention": ["ComfyUI-KitchenAttention", "kitchen_attention"],
    }
    for item in custom_nodes.iterdir():
        if not item.is_dir():
            continue
        for marker in markers.get(name.lower(), []):
            if marker.lower() in item.name.lower():
                return True
    return False

def attention_flag(name: str) -> str:
    return {
        "sageattention": "--use-sage-attention",
        "flashattention": "--use-flash-attention",
        "kitchenattention": "--use-kitchen-attention",
    }.get(name.lower(), "")

# ---------------------------------------------------------------------------
# Launch helpers
# ---------------------------------------------------------------------------
def _run_in_terminal(cmd: list, cwd: str = None):
    """Try to run a shell command in a visible terminal so interactive prompts work."""
    if IS_MAC:
        # osascript to open a new Terminal window
        script = ' '.join(
            '\\"' + c.replace('\\', '\\\\').replace('"', '\\\\"') + '\\"'
            for c in cmd
        )
        apple_script = (
            f'tell application "Terminal" to do script "cd {cwd or str(SCRIPT_DIR)}; {script}"'
        )
        return subprocess.Popen(["osascript", "-e", apple_script])

    # Linux: try common terminal emulators
    term_cmd = None
    for term in ["gnome-terminal", "konsole", "xfce4-terminal", "alacritty", "kitty", "xterm"]:
        if shutil.which(term):
            term_cmd = term
            break

    if term_cmd == "gnome-terminal":
        return subprocess.Popen([term_cmd, "--", "bash", "-c", f"cd '{cwd or str(SCRIPT_DIR)}' && {' '.join(cmd)}; exec bash"])
    elif term_cmd == "konsole":
        return subprocess.Popen([term_cmd, "-e", f"bash -c \"cd '{cwd or str(SCRIPT_DIR)}' && {' '.join(cmd)}; exec bash\""])
    elif term_cmd == "xfce4-terminal":
        return subprocess.Popen([term_cmd, "-e", f"bash -c \"cd '{cwd or str(SCRIPT_DIR)}' && {' '.join(cmd)}; exec bash\""])
    elif term_cmd:
        return subprocess.Popen([term_cmd, "-e", f"cd '{cwd or str(SCRIPT_DIR)}' && {' '.join(cmd)}; exec bash"])

    # Fallback: run in background subprocess, stdout/stdin detached
    return subprocess.Popen(cmd, cwd=cwd or SCRIPT_DIR, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def launch_platform_script(mode: str, attention: str = ""):
    """Launch the platform-appropriate run script."""
    if not INSTALL_DIR:
        return {"ok": False, "error": "Not a valid ComfyUI-Easy-Install directory."}

    script_map = {
        "macos_mps": "run_mac_mps.sh",
        "macos_intel": "run_mac_intel.sh",
        "linux": "run_nvidia_gpu.sh",
    }
    script = script_map.get(PLATFORM)
    if not script or not script_exists(script):
        return {"ok": False, "error": f"Platform script not found: {script}"}

    cmd = [f"./{script}"]
    if attention:
        flag = attention_flag(attention)
        if flag:
            cmd.append(flag)

    if mode == "desktop":
        # Desktop mode uses the desktop wrapper regardless of attention
        cmd = ["./run_comfyui_desktop.sh"]
    elif mode == "hybrid":
        # Hybrid: start server in terminal and open browser
        _run_in_terminal(cmd)
        url = f"http://127.0.0.1:8188"
        try:
            webbrowser.open(url)
        except Exception:
            pass
        return {"ok": True}

    _run_in_terminal(cmd)
    return {"ok": True}


def run_update_script(script: str) -> dict:
    if not INSTALL_DIR:
        return {"ok": False, "error": "Not a valid ComfyUI-Easy-Install directory."}
    if not script_exists(script):
        return {"ok": False, "error": f"Update script not found: {script}"}
    _run_in_terminal([f"./{script}"])
    return {"ok": True}


def open_folder(name: str) -> dict:
    folder = SCRIPT_DIR / name
    if not folder.is_dir():
        try:
            folder.mkdir(parents=True, exist_ok=True)
        except Exception as e:
            return {"ok": False, "error": str(e)}
    if IS_MAC:
        subprocess.Popen(["open", str(folder)])
    elif IS_LINUX:
        subprocess.Popen(["xdg-open", str(folder)])
    else:
        webbrowser.open(folder.as_uri())
    return {"ok": True}

# ---------------------------------------------------------------------------
# Window state
# ---------------------------------------------------------------------------
def load_state() -> dict:
    try:
        if WINDOW_STATE_FILE.exists():
            with open(WINDOW_STATE_FILE, "r") as f:
                return json.load(f)
    except Exception:
        pass
    return {"mode": "desktop"}


def save_state(state: dict):
    try:
        with open(WINDOW_STATE_FILE, "w") as f:
            json.dump(state, f)
    except Exception:
        pass

# ---------------------------------------------------------------------------
# PyWebView API
# ---------------------------------------------------------------------------
class LauncherApi:
    def __init__(self, window):
        self.window = window

    def get_state(self):
        state = load_state()
        mode = state.get("mode", "desktop")
        return {
            "version": EZI_VERSION,
            "platform": PLATFORM,
            "valid_dir": INSTALL_DIR is not None,
            "mode": mode,
            "python": PYTHON_EXEC,
            "items": [
                {
                    "id": "comfyui",
                    "name": "ComfyUI",
                    "status": "Default",
                    "status_color": "ready",
                    "attention": "",
                    "icon": "comfyui",
                },
                {
                    "id": "kitchenattention",
                    "name": "Kitchen Attention",
                    "status": "Ready",
                    "status_color": "ready",
                    "attention": "kitchenattention",
                    "icon": "grid",
                },
                {
                    "id": "sageattention",
                    "name": "Sage Attention",
                    "status": "Ready" if is_addon_installed("sageattention") else "Not installed",
                    "status_color": "ready" if is_addon_installed("sageattention") else "missing",
                    "attention": "sageattention",
                    "icon": "leaf",
                },
                {
                    "id": "flashattention",
                    "name": "Flash Attention",
                    "status": "Ready" if is_addon_installed("flashattention") else "Not installed",
                    "status_color": "ready" if is_addon_installed("flashattention") else "missing",
                    "attention": "flashattention",
                    "icon": "bolt",
                },
            ],
            "updates": [
                {"id": "easy", "name": "Easy-Install", "subtitle": "EZi and Add-ons", "script": "Update_Easy-Install.sh"},
                {"id": "stable", "name": "ComfyUI Stable", "subtitle": "Latest stable release", "script": "Update_Comfy_and_RUN.sh"},
                {"id": "latest", "name": "ComfyUI Latest", "subtitle": "Latest development version", "script": "Update_All_and_RUN.sh"},
                {"id": "nodes", "name": "ComfyUI + Nodes", "subtitle": "Stable + all custom nodes", "script": "Update_All_and_RUN.sh"},
            ],
            "folders": [
                {"id": "output", "name": "Output", "path": "Output"},
                {"id": "input", "name": "Input", "path": "Input"},
                {"id": "workflows", "name": "Workflows", "path": "ComfyUI/user/default/workflows"},
                {"id": "models", "name": "Models", "path": "Models"},
            ],
        }

    def set_mode(self, mode: str):
        state = load_state()
        state["mode"] = mode
        save_state(state)
        return {"ok": True}

    def launch(self, item_id: str, attention: str = ""):
        state = load_state()
        mode = state.get("mode", "desktop")
        return launch_platform_script(mode, attention or item_id)

    def update(self, script: str):
        return run_update_script(script)

    def open_folder(self, path: str):
        return open_folder(path)

    def open_url(self, url: str):
        try:
            webbrowser.open(url)
        except Exception:
            pass
        return {"ok": True}

    def close(self):
        try:
            self.window.destroy()
        except Exception:
            pass

# ---------------------------------------------------------------------------
# HTML / CSS / UI
# ---------------------------------------------------------------------------
_ICON_B64 = ""
if ICON_PATH.is_file():
    try:
        _ICON_B64 = base64.b64encode(ICON_PATH.read_bytes()).decode("ascii")
    except Exception:
        pass

HTML = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ComfyUI EZi Launcher</title>
<style>
:root {
  --bg: #1a1f2e;
  --bg-light: #232a3d;
  --bg-lighter: #2d3650;
  --accent: #7ee8d3;
  --accent-hover: #5fd4bd;
  --text: #e6edf7;
  --text-muted: #8b9bb4;
  --ready: #7ee8d3;
  --missing: #ff9f43;
  --border: rgba(255,255,255,0.08);
  --shadow: 0 8px 32px rgba(0,0,0,0.35);
}
* { box-sizing: border-box; }
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  background: linear-gradient(135deg, #151925 0%, #1e2333 100%);
  color: var(--text);
  height: 100vh;
  overflow: hidden;
  user-select: none;
}
#app {
  display: flex;
  flex-direction: column;
  height: 100vh;
  border-radius: 12px;
  overflow: hidden;
}
/* Title bar */
.titlebar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 18px;
  background: rgba(21, 25, 37, 0.85);
  border-bottom: 1px solid var(--border);
  -webkit-app-region: drag;
}
.title-left {
  display: flex;
  align-items: center;
  gap: 12px;
}
.logo {
  width: 32px; height: 32px;
  border-radius: 8px;
  background: var(--bg-lighter);
  display: flex; align-items: center; justify-content: center;
  font-size: 18px;
  color: var(--accent);
}
.logo img { width: 24px; height: 24px; object-fit: contain; }
.title-text h1 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  letter-spacing: -0.3px;
}
.title-text span {
  font-size: 13px;
  color: var(--text-muted);
  margin-left: 10px;
}
.version {
  font-size: 13px;
  color: var(--accent);
  margin-right: auto;
  margin-left: 16px;
}
.close-btn {
  width: 28px; height: 28px;
  border-radius: 6px;
  border: none;
  background: transparent;
  color: var(--text-muted);
  font-size: 20px;
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  transition: 0.2s;
  -webkit-app-region: no-drag;
}
.close-btn:hover { background: rgba(255,255,255,0.1); color: #fff; }
/* Main layout */
.main {
  display: flex;
  flex: 1;
  padding: 18px;
  gap: 18px;
  overflow: hidden;
}
.left-panel {
  flex: 1.3;
  display: flex;
  flex-direction: column;
  gap: 16px;
  min-width: 0;
}
.right-panel {
  flex: 0.9;
  min-width: 240px;
  max-width: 320px;
  display: flex;
  flex-direction: column;
}
/* Mode tabs */
.tabs {
  display: flex;
  gap: 10px;
}
.tab {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px 14px;
  border-radius: 10px;
  background: var(--bg-light);
  border: 1px solid var(--border);
  color: var(--text-muted);
  font-size: 14px;
  cursor: pointer;
  transition: 0.2s;
}
.tab:hover { background: var(--bg-lighter); color: var(--text); }
.tab.active {
  background: var(--accent);
  color: #0f1620;
  font-weight: 600;
  border-color: var(--accent);
}
.tab svg { width: 18px; height: 18px; }
/* Cards */
.card {
  background: var(--bg-light);
  border: 1px solid var(--border);
  border-radius: 14px;
  padding: 14px;
  box-shadow: var(--shadow);
}
.item-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  flex: 1;
  overflow-y: auto;
}
.item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 12px 14px;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 12px;
  transition: 0.2s;
}
.item:hover { background: rgba(255,255,255,0.03); }
.item-icon {
  width: 40px; height: 40px;
  border-radius: 10px;
  background: var(--bg-lighter);
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.item-icon svg { width: 22px; height: 22px; color: var(--accent); }
.item-info { flex: 1; min-width: 0; }
.item-name { font-size: 15px; font-weight: 600; margin-bottom: 3px; }
.item-status {
  font-size: 12px;
  display: flex; align-items: center;
  gap: 6px;
  color: var(--text-muted);
}
.status-dot {
  width: 7px; height: 7px;
  border-radius: 50%;
  background: var(--missing);
}
.status-dot.ready { background: var(--ready); }
.item-actions { display: flex; gap: 8px; }
.btn {
  padding: 7px 16px;
  border-radius: 8px;
  border: none;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: 0.2s;
  display: inline-flex; align-items: center; gap: 6px;
}
.btn-primary {
  background: var(--accent);
  color: #0f1620;
}
.btn-primary:hover { background: var(--accent-hover); }
.btn-ghost {
  background: transparent;
  color: var(--text-muted);
  border: 1px solid var(--border);
}
.btn-ghost:hover { background: rgba(255,255,255,0.05); color: var(--text); }
.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
/* Update panel */
.update-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 14px;
  font-size: 16px;
  font-weight: 600;
}
.update-header svg { width: 20px; height: 20px; color: var(--accent); }
.update-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  flex: 1;
}
.update-card {
  padding: 14px;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 12px;
  cursor: pointer;
  transition: 0.2s;
}
.update-card:hover { background: rgba(255,255,255,0.04); border-color: rgba(126,232,211,0.25); }
.update-name { font-size: 14px; font-weight: 600; margin-bottom: 3px; }
.update-sub { font-size: 11px; color: var(--text-muted); }
/* Folder bar */
.folder-bar {
  display: flex;
  gap: 10px;
  padding-top: 4px;
}
.folder-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px;
  background: var(--bg-light);
  border: 1px solid var(--border);
  border-radius: 10px;
  color: var(--text);
  font-size: 13px;
  cursor: pointer;
  transition: 0.2s;
}
.folder-btn:hover { background: var(--bg-lighter); }
.folder-btn svg { width: 16px; height: 16px; color: var(--accent); }
/* Toast / error */
#toast {
  position: fixed;
  bottom: 20px; left: 50%;
  transform: translateX(-50%);
  background: var(--bg-lighter);
  color: var(--text);
  padding: 10px 18px;
  border-radius: 8px;
  font-size: 13px;
  border: 1px solid var(--border);
  opacity: 0;
  pointer-events: none;
  transition: 0.3s;
  z-index: 100;
}
#toast.show { opacity: 1; }
.invalid {
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  height: 100%; text-align: center; padding: 30px; gap: 12px;
  color: var(--text-muted);
}
.invalid h2 { color: var(--text); margin: 0; }
::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-thumb { background: var(--bg-lighter); border-radius: 3px; }
</style>
</head>
<body>
<div id="app">
  <div class="titlebar">
    <div class="title-left">
      <div class="logo" id="logo">🎨</div>
      <div class="title-text">
        <h1>ComfyUI EZi <span>Launcher</span></h1>
      </div>
    </div>
    <div class="version" id="version">v""" + EZI_VERSION + r"""</div>
    <button class="close-btn" onclick="pywebview.api.close()">×</button>
  </div>

  <div class="main" id="main">
    <div class="left-panel">
      <div class="tabs">
        <button class="tab active" data-mode="desktop" onclick="setMode('desktop')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
          Desktop
        </button>
        <button class="tab" data-mode="browser" onclick="setMode('browser')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>
          Browser
        </button>
        <button class="tab" data-mode="hybrid" onclick="setMode('hybrid')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path></svg>
          Hybrid
        </button>
      </div>
      <div class="item-list" id="item-list"></div>
      <div class="folder-bar" id="folder-bar"></div>
    </div>

    <div class="right-panel">
      <div class="card" style="height:100%; display:flex; flex-direction:column;">
        <div class="update-header">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.3"/></svg>
          Update
        </div>
        <div class="update-list" id="update-list"></div>
      </div>
    </div>
  </div>
</div>
<div id="toast"></div>

<script>
const ICONS = {
  comfyui: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5z"></path><path d="M2 17l10 5 10-5"></path><path d="M2 12l10 5 10-5"></path></svg>',
  grid: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>',
  leaf: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 20A7 7 0 0 1 9.8 9.6C15.5 6.5 20 2 20 2s-4.5 4.5-7.6 10.2A7 7 0 0 1 11 20Z"></path><path d="M13 22a7 7 0 0 1-1.2-10.4C17.5 8.5 22 4 22 4s-4.5 4.5-7.6 10.2A7 7 0 0 1 13 22Z" opacity="0.5"></path></svg>',
  bolt: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>',
  folder: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>',
};

let state = {};
let currentMode = 'desktop';

function showToast(msg) {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 2500);
}

async function call(name, ...args) {
  try {
    return await pywebview.api[name](...args);
  } catch (e) {
    console.error(e);
    showToast('Error: ' + e.message);
    return {ok: false, error: e.message};
  }
}

function setMode(mode) {
  currentMode = mode;
  document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.mode === mode));
  call('set_mode', mode);
}

async function doLaunch(id, attention) {
  const res = await call('launch', id, attention || '');
  if (res && res.ok) {
    showToast('Launching...');
  } else if (res && res.error) {
    showToast(res.error);
  }
}

async function doUpdate(script) {
  const res = await call('update', script);
  if (res && res.ok) {
    showToast('Update started in terminal');
  } else if (res && res.error) {
    showToast(res.error);
  }
}

async function doOpenFolder(path) {
  const res = await call('open_folder', path);
  if (res && !res.ok && res.error) showToast(res.error);
}

function renderItems() {
  const list = document.getElementById('item-list');
  list.innerHTML = state.items.map(item => {
    const isComfyUI = item.id === 'comfyui';
    const canLaunch = isComfyUI || item.status_color === 'ready';
    return `
      <div class="item">
        <div class="item-icon">${ICONS[item.icon] || ICONS.comfyui}</div>
        <div class="item-info">
          <div class="item-name">${escapeHtml(item.name)}</div>
          <div class="item-status">
            <span class="status-dot ${item.status_color}"></span>
            ${escapeHtml(item.status)}
          </div>
        </div>
        <div class="item-actions">
          <button class="btn btn-primary" ${canLaunch ? '' : 'disabled'} onclick="doLaunch('${item.id}', '${item.attention || ''}')">Launch</button>
          ${!isComfyUI ? `<button class="btn btn-ghost" onclick="doOpenFolder('ComfyUI/custom_nodes')">Install</button>` : ''}
        </div>
      </div>
    `;
  }).join('');
}

function renderUpdates() {
  const list = document.getElementById('update-list');
  list.innerHTML = state.updates.map(u => `
    <div class="update-card" onclick="doUpdate('${escapeHtml(u.script)}')">
      <div class="update-name">${escapeHtml(u.name)}</div>
      <div class="update-sub">${escapeHtml(u.subtitle)}</div>
    </div>
  `).join('');
}

function renderFolders() {
  const bar = document.getElementById('folder-bar');
  bar.innerHTML = state.folders.map(f => `
    <button class="folder-btn" onclick="doOpenFolder('${escapeHtml(f.path)}')">
      ${ICONS.folder}
      ${escapeHtml(f.name)}
    </button>
  `).join('');
}

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]));
}

async function init() {
  state = await call('get_state');
  if (!state.valid_dir) {
    document.getElementById('main').innerHTML = `
      <div class="invalid">
        <h2>Not a ComfyUI-Easy-Install directory</h2>
        <p>This launcher must be run from inside an installed ComfyUI-Easy-Install folder.</p>
        <p>Expected to find <code>ComfyUI/</code> and <code>python_embeded/</code> next to this script.</p>
      </div>`;
    return;
  }
  currentMode = state.mode || 'desktop';
  document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.mode === currentMode));
  document.getElementById('version').textContent = 'v' + state.version;
  document.getElementById('logo').innerHTML = '""" + (('<img src="data:image/png;base64,' + _ICON_B64 + '">') if _ICON_B64 else '🎨') + r"""';
  renderItems();
  renderUpdates();
  renderFolders();
}

window.addEventListener('pywebviewready', init);
</script>
</body>
</html>
"""

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    try:
        import webview
    except ImportError:
        print("pywebview is required. Install it with:", file=sys.stderr)
        print(f"  {PYTHON_EXEC} -m pip install pywebview", file=sys.stderr)
        sys.exit(1)

    api = LauncherApi(None)

    window = webview.create_window(
        title=f"ComfyUI EZi Launcher v{EZI_VERSION}",
        html=HTML,
        js_api=api,
        width=880,
        height=520,
        resizable=False,
        on_top=False,
        confirm_close=False,
    )

    api.window = window
    webview.start(debug=False, http_server=False)


if __name__ == "__main__":
    main()
