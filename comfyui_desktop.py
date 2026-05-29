#!/usr/bin/env python3
"""
Desktop EZi v3.6.5 — PyWebView wrapper
Opens ComfyUI in a native desktop window instead of a browser.
Part of ComfyUI-Easy-Install by Pixaroma / VenimK
"""

import os
import sys
import time
import signal
import socket
import threading
import webbrowser
import urllib.request
import urllib.parse
import base64
import json
import subprocess

COMFYUI_HOST = os.environ.get("COMFYUI_HOST", "127.0.0.1")
COMFYUI_PORT = int(os.environ.get("COMFYUI_PORT", 8188))
COMFYUI_REMOTE = os.environ.get("COMFYUI_REMOTE", "0") == "1"
COMFYUI_URL = f"http://{COMFYUI_HOST}:{COMFYUI_PORT}"

if COMFYUI_REMOTE:
    WINDOW_TITLE = f"ComfyUI \u2014 {COMFYUI_HOST}"
else:
    WINDOW_TITLE = "ComfyUI \u2014 Pixaroma"

WINDOW_WIDTH = 1400
WINDOW_HEIGHT = 900

# Path to icon (relative to this script)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ICON_PATH = os.path.join(SCRIPT_DIR, "comfyui_icon.png")
WINDOW_STATE_FILE = os.path.join(SCRIPT_DIR, ".comfyui_desktop_state.json")

# Embed icon as base64 for the loading splash
_ICON_B64 = ""
if os.path.isfile(ICON_PATH):
    with open(ICON_PATH, "rb") as _f:
        _ICON_B64 = base64.b64encode(_f.read()).decode("ascii")


def wait_for_server(host, port, timeout=120):
    """Wait for ComfyUI server to start accepting connections."""
    start = time.time()
    while time.time() - start < timeout:
        try:
            with socket.create_connection((host, port), timeout=2):
                return True
        except (ConnectionRefusedError, OSError, socket.timeout):
            time.sleep(0.5)
    return False


def open_in_browser():
    """Fallback: open ComfyUI in the default browser."""
    print(f"Opening ComfyUI in browser: {COMFYUI_URL}")
    webbrowser.open(COMFYUI_URL)


def is_port_in_use(port, host="127.0.0.1"):
    """Return True if port is already bound."""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(0.5)
            return s.connect_ex((host, port)) == 0
    except Exception:
        return False


def load_window_state():
    """Load saved window geometry. Returns dict or {}."""
    try:
        if os.path.isfile(WINDOW_STATE_FILE):
            with open(WINDOW_STATE_FILE, "r") as f:
                data = json.load(f)
            if isinstance(data, dict):
                return data
    except Exception:
        pass
    return {}


def save_window_state(window):
    """Persist current window size/position to disk."""
    try:
        state = {
            "width":  window.width,
            "height": window.height,
            "x":      window.x,
            "y":      window.y,
        }
        # Filter out None / negative values that pywebview may return on some platforms
        if any(v is None or v < 0 for v in state.values()):
            return
        with open(WINDOW_STATE_FILE, "w") as f:
            json.dump(state, f)
    except Exception:
        pass


def get_system_info():
    """Return a dict with Python, Torch, ComfyUI and platform info."""
    info = {}
    info["platform"] = sys.platform
    info["python"] = sys.version.split()[0]

    # PyTorch
    try:
        import torch
        info["torch"] = torch.__version__
        if sys.platform == "darwin":
            info["mps"] = str(torch.backends.mps.is_available())
            info["gpu"] = "MPS (Apple Silicon)" if torch.backends.mps.is_available() else "CPU"
        elif torch.cuda.is_available():
            info["gpu"] = torch.cuda.get_device_name(0)
            info["cuda"] = torch.version.cuda or "unknown"
        else:
            info["gpu"] = "CPU only"
    except Exception:
        info["torch"] = "not installed"
        info["gpu"] = "unknown"

    # ComfyUI git version (prefer tag, fall back to short rev)
    comfy_dir = os.path.join(SCRIPT_DIR, "ComfyUI")
    try:
        r = subprocess.run(
            ["git", "describe", "--tags", "--exact-match", "HEAD"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=5,
        )
        if r.returncode == 0 and r.stdout.strip():
            info["comfyui_rev"] = r.stdout.strip()  # exact tag match
        else:
            r3 = subprocess.run(
                ["git", "rev-parse", "--short", "HEAD"],
                cwd=comfy_dir, capture_output=True, text=True, timeout=5,
            )
            rev = r3.stdout.strip() if r3.returncode == 0 else "unknown"
            # git describe with abbrev gives "tag-N-gSHA" when not on tag
            r2 = subprocess.run(
                ["git", "describe", "--tags", "--abbrev=4", "HEAD"],
                cwd=comfy_dir, capture_output=True, text=True, timeout=5,
            )
            desc = r2.stdout.strip() if r2.returncode == 0 else ""
            info["comfyui_rev"] = desc if desc else rev
    except Exception:
        info["comfyui_rev"] = "unknown"

    # ComfyUI frontend package version
    try:
        import glob as _glob
        site = os.path.join(SCRIPT_DIR, "python_embeded", "lib",
                            "python3.12", "site-packages")
        if not os.path.isdir(site):
            import site as _site
            site = _site.getsitepackages()[0]
        matches = sorted(_glob.glob(
            os.path.join(site, "comfyui_frontend_package-*.dist-info", "METADATA")
        ), reverse=True)
        info["frontend"] = "not installed"
        for meta in matches:
            with open(meta, "r", errors="replace") as f:
                for line in f:
                    if line.startswith("Version:"):
                        ver = line.split(":", 1)[1].strip()
                        if ver and ver != "0.1.0":
                            info["frontend"] = ver
                        break
            break
    except Exception:
        info["frontend"] = "unknown"

    # Free disk space
    try:
        import shutil
        _, _, free = shutil.disk_usage(SCRIPT_DIR)
        info["disk_free_gb"] = f"{free / 1e9:.1f}"
    except Exception:
        pass

    return info


def get_cache_info():
    """Return sizes (MB) of pip and uv caches."""
    result = {}
    home = os.path.expanduser("~")
    for name, path in [
        ("pip", os.path.join(home, ".cache", "pip")),
        ("uv",  os.path.join(home, ".cache", "uv")),
    ]:
        try:
            total = sum(
                os.path.getsize(os.path.join(dp, f))
                for dp, _, files in os.walk(path)
                for f in files
            )
            result[name] = round(total / 1_048_576, 1)
        except Exception:
            result[name] = 0
    return result


def clear_cache(cache_type):
    """Delete pip or uv cache. cache_type: 'pip' | 'uv' | 'all'"""
    import shutil
    home = os.path.expanduser("~")
    targets = {
        "pip": os.path.join(home, ".cache", "pip"),
        "uv":  os.path.join(home, ".cache", "uv"),
    }
    cleared = []
    for name, path in targets.items():
        if cache_type in (name, "all") and os.path.isdir(path):
            try:
                shutil.rmtree(path)
                os.makedirs(path)
                cleared.append(name)
            except Exception:
                pass
    return cleared


def check_comfyui_update():
    """Fetch git status for ComfyUI. Returns dict with update info."""
    comfy_dir = os.path.join(SCRIPT_DIR, "ComfyUI")
    if not os.path.isdir(os.path.join(comfy_dir, ".git")):
        return {"error": "ComfyUI directory not a git repo"}
    try:
        subprocess.run(
            ["git", "fetch", "--quiet"],
            cwd=comfy_dir, capture_output=True, timeout=10,
        )
        local = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=5,
        ).stdout.strip()
        remote = subprocess.run(
            ["git", "rev-parse", "@{u}"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=5,
        ).stdout.strip()
        behind = subprocess.run(
            ["git", "rev-list", "--count", "HEAD..@{u}"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=5,
        ).stdout.strip()
        return {
            "local": local[:8],
            "remote": remote[:8],
            "up_to_date": local == remote,
            "commits_behind": int(behind) if behind.isdigit() else 0,
        }
    except Exception as e:
        return {"error": str(e)}


def get_frontend_versions():
    """Return recent comfyui_frontend_package versions from PyPI (newest first, max 20)."""
    try:
        import urllib.request as _ur
        with _ur.urlopen(
            "https://pypi.org/pypi/comfyui_frontend_package/json", timeout=8
        ) as r:
            data = json.loads(r.read())
        versions = sorted(data.get("releases", {}).keys(),
                          key=lambda v: [int(x) for x in v.split(".") if x.isdigit()],
                          reverse=True)
        return versions[:20]
    except Exception:
        return []


def install_frontend_version(version):
    """pip-install a specific comfyui_frontend_package version. Returns dict."""
    python = os.path.join(SCRIPT_DIR, "python_embeded", "python")
    if not os.path.isfile(python):
        python = sys.executable
    try:
        r = subprocess.run(
            [python, "-m", "pip", "install",
             f"comfyui_frontend_package=={version}", "--quiet"],
            capture_output=True, text=True, timeout=120,
        )
        if r.returncode == 0:
            return {"ok": True, "version": version}
        return {"error": r.stderr.strip()[-300:]}
    except Exception as e:
        return {"error": str(e)}


def get_frontend_is_nightly():
    """Detect if installed frontend is a nightly/dev build. Returns bool."""
    try:
        import glob as _glob, site as _site, re as _re
        site_dir = _site.getsitepackages()[0]
        pkg_dir = None
        candidates = _glob.glob(os.path.join(site_dir, "comfyui_frontend_package*"))
        for c in candidates:
            if os.path.isdir(c) and "dist-info" not in c:
                pkg_dir = c
                break
        if not pkg_dir:
            return False
        # Check if assets directory contains nightly-specific markers
        assets_dir = os.path.join(pkg_dir, "static", "assets")
        if not os.path.isdir(assets_dir):
            return False
        # Look for version file or check for dev markers
        for root, dirs, files in os.walk(pkg_dir):
            for f in files:
                if f.endswith(".js") or f.endswith(".txt"):
                    try:
                        with open(os.path.join(root, f), "r", errors="replace") as file:
                            content = file.read()
                            if "nightly" in content.lower() or "dev" in content.lower():
                                return True
                    except:
                        pass
        return False
    except Exception:
        return False


def get_comfyui_required_frontend(tag):
    """Read requirements.txt from a ComfyUI git tag to find required frontend version.
    Returns version string or None if not specified."""
    comfy_dir = os.path.join(SCRIPT_DIR, "ComfyUI")
    try:
        # Try to read requirements.txt from the specific tag
        r = subprocess.run(
            ["git", "show", f"{tag}:requirements.txt"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=5,
        )
        if r.returncode == 0:
            for line in r.stdout.splitlines():
                line = line.strip()
                if line.startswith("comfyui-frontend-package"):
                    # Parse version specifier like comfyui-frontend-package==1.2.3
                    if "==" in line:
                        return line.split("==")[1].strip()
                    if ">=" in line:
                        return line.split(">=")[1].strip()
        # Also check pyproject.toml if available
        r2 = subprocess.run(
            ["git", "show", f"{tag}:pyproject.toml"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=5,
        )
        if r2.returncode == 0:
            import re as _re
            for line in r2.stdout.splitlines():
                match = _re.search(r'comfyui-frontend-package\s*[=<>]+\s*["\']?([0-9.]+)', line)
                if match:
                    return match.group(1)
        return None
    except Exception:
        return None


def switch_comfyui_and_frontend(tag, fe_version=None):
    """Switch ComfyUI to a specific tag and optionally/install matching frontend.
    If fe_version is None, auto-detect from requirements.txt."""
    comfy_dir = os.path.join(SCRIPT_DIR, "ComfyUI")
    results = {"comfyui": None, "frontend": None}

    # Step 1: Checkout ComfyUI tag
    try:
        subprocess.run(
            ["git", "fetch", "--tags"], cwd=comfy_dir,
            capture_output=True, timeout=10,
        )
        r = subprocess.run(
            ["git", "checkout", tag], cwd=comfy_dir,
            capture_output=True, text=True, timeout=10,
        )
        if r.returncode != 0:
            return {"error": f"Git checkout failed: {r.stderr}"}
        results["comfyui"] = tag
    except Exception as e:
        return {"error": f"ComfyUI switch failed: {e}"}

    # Step 2: Determine frontend version
    if fe_version is None or fe_version == "auto":
        fe_version = get_comfyui_required_frontend(tag)
        results["auto_detected"] = fe_version

    # Step 3: Install frontend if needed
    if fe_version:
        fe_result = install_frontend_version(fe_version)
        results["frontend"] = fe_result
        if fe_result.get("error"):
            return {"error": f"Frontend install failed: {fe_result['error']}", "partial": results}

    return {"ok": True, "results": results}


def check_installer_update():
    """Check if the local installer is behind the MAC-Linux branch HEAD on GitHub."""
    try:
        import urllib.request as _ur
        # Get remote HEAD SHA of MAC-Linux branch via GitHub API
        req = _ur.Request(
            "https://api.github.com/repos/Tavris1/ComfyUI-Easy-Install/commits/MAC-Linux?per_page=1",
            headers={"User-Agent": "ComfyUI-Desktop-Mac"}
        )
        with _ur.urlopen(req, timeout=8) as r:
            data = json.loads(r.read())
        remote_sha = data.get("sha", "")[:8]
        remote_date = data.get("commit", {}).get("committer", {}).get("date", "")[:10]
        if not remote_sha:
            return {"error": "could not read remote SHA"}

        # Get local git SHA (SCRIPT_DIR is the installer repo root)
        local_sha = ""
        local_date = ""
        try:
            r2 = subprocess.run(
                ["git", "rev-parse", "HEAD"],
                cwd=SCRIPT_DIR, capture_output=True, text=True, timeout=5,
            )
            local_sha = r2.stdout.strip()[:8] if r2.returncode == 0 else ""
            r3 = subprocess.run(
                ["git", "log", "-1", "--format=%ci"],
                cwd=SCRIPT_DIR, capture_output=True, text=True, timeout=5,
            )
            local_date = r3.stdout.strip()[:10] if r3.returncode == 0 else ""
        except Exception:
            pass

        # Count commits behind via GitHub compare API
        commits_behind = 0
        if local_sha:
            try:
                cmp_req = _ur.Request(
                    f"https://api.github.com/repos/Tavris1/ComfyUI-Easy-Install/compare/{local_sha}...MAC-Linux",
                    headers={"User-Agent": "ComfyUI-Desktop-Mac"}
                )
                with _ur.urlopen(cmp_req, timeout=8) as rc:
                    cmp = json.loads(rc.read())
                commits_behind = cmp.get("behind_by", 0)
            except Exception:
                pass

        return {
            "local":          local_sha or "unknown",
            "local_date":     local_date,
            "remote":         remote_sha,
            "remote_date":    remote_date,
            "up_to_date":     local_sha == remote_sha or commits_behind == 0,
            "commits_behind": commits_behind,
            "release_url":    "https://github.com/Tavris1/ComfyUI-Easy-Install/tree/MAC-Linux",
        }
    except Exception as e:
        return {"error": str(e)}


def get_custom_paths():
    """Read --input-directory / --output-directory / --user-directory from saved launch args."""
    state = {}
    try:
        if os.path.isfile(WINDOW_STATE_FILE):
            with open(WINDOW_STATE_FILE) as f:
                state = json.load(f)
    except Exception:
        pass
    args_str = state.get("launch_args", "")
    paths = {"input": "", "output": "", "user": ""}
    param_map = {
        "--input-directory":  "input",
        "--output-directory": "output",
        "--user-directory":   "user",
    }
    tokens = args_str.split()
    for i, tok in enumerate(tokens):
        if tok in param_map and i + 1 < len(tokens):
            paths[param_map[tok]] = tokens[i + 1]
    return paths


def set_custom_paths(input_dir, output_dir, user_dir):
    """Write custom paths into launch_args in the window state file."""
    try:
        state = {}
        if os.path.isfile(WINDOW_STATE_FILE):
            with open(WINDOW_STATE_FILE) as f:
                state = json.load(f)
        args_str = state.get("launch_args", "")
        # Remove existing path flags
        tokens = args_str.split()
        flags = {"--input-directory", "--output-directory", "--user-directory"}
        clean = []
        skip = False
        for tok in tokens:
            if skip:
                skip = False
                continue
            if tok in flags:
                skip = True
                continue
            clean.append(tok)
        # Append new non-empty paths
        pairs = [
            ("--input-directory",  input_dir.strip()),
            ("--output-directory", output_dir.strip()),
            ("--user-directory",   user_dir.strip()),
        ]
        for flag, val in pairs:
            if val:
                clean += [flag, val]
        state["launch_args"] = " ".join(clean)
        with open(WINDOW_STATE_FILE, "w") as f:
            json.dump(state, f)
        return {"ok": True, "launch_args": state["launch_args"]}
    except Exception as e:
        return {"error": str(e)}


_BUILTIN_PALETTES = {
    'dark':      {'bg': '#202020', 'menu_bg': '#171718', 'fg': '#ffffff', 'border': '#4e4e4e', 'input_bg': '#222222', 'accent': '#9a9', 'node_bg': '#353535'},
    'light':     {'bg': '#e9e9e9', 'menu_bg': '#f5f5f5', 'fg': '#222222', 'border': '#bbbbbb', 'input_bg': '#d0d0d0', 'accent': '#4CAF50', 'node_bg': '#f5f5f5'},
    'solarized': {'bg': '#002b36', 'menu_bg': '#073642', 'fg': '#839496', 'border': '#0d525e', 'input_bg': '#003847', 'accent': '#2aa198', 'node_bg': '#073642'},
    'arc':       {'bg': '#2f343f', 'menu_bg': '#383c4a', 'fg': '#d3dae3', 'border': '#4b5162', 'input_bg': '#404552', 'accent': '#5294e2', 'node_bg': '#383c4a'},
    'nord':      {'bg': '#2e3440', 'menu_bg': '#3b4252', 'fg': '#d8dee9', 'border': '#4c566a', 'input_bg': '#434c5e', 'accent': '#88c0d0', 'node_bg': '#3b4252'},
    'github':    {'bg': '#0d1117', 'menu_bg': '#161b22', 'fg': '#c9d1d9', 'border': '#30363d', 'input_bg': '#21262d', 'accent': '#388bfd', 'node_bg': '#161b22'},
}


def _blend_hex(hex1, hex2, t=0.35):
    try:
        h1, h2 = hex1.lstrip('#'), hex2.lstrip('#')
        if len(h1) == 3: h1 = h1[0]*2 + h1[1]*2 + h1[2]*2
        if len(h2) == 3: h2 = h2[0]*2 + h2[1]*2 + h2[2]*2
        r1,g1,b1 = int(h1[0:2],16), int(h1[2:4],16), int(h1[4:6],16)
        r2,g2,b2 = int(h2[0:2],16), int(h2[2:4],16), int(h2[4:6],16)
        return '#{:02x}{:02x}{:02x}'.format(
            int(r1*(1-t)+r2*t), int(g1*(1-t)+g2*t), int(b1*(1-t)+b2*t))
    except Exception:
        return hex1


def _hex_luminance(h):
    try:
        h = h.lstrip('#')
        if len(h) == 3: h = h[0]*2+h[1]*2+h[2]*2
        r,g,b = int(h[0:2],16)/255, int(h[2:4],16)/255, int(h[4:6],16)/255
        def lin(c): return c/12.92 if c <= 0.04045 else ((c+0.055)/1.055)**2.4
        return 0.2126*lin(r)+0.7152*lin(g)+0.0722*lin(b)
    except Exception:
        return 0.5


def get_comfy_theme():
    """Read ComfyUI's active palette and derive CSS vars for the desktop panel."""
    try:
        user_dir = os.path.join(SCRIPT_DIR, "ComfyUI", "user", "default")
        settings_file = os.path.join(user_dir, "comfy.settings.json")
        palette_id = "dark"
        custom_palettes = {}
        if os.path.isfile(settings_file):
            with open(settings_file, "r", errors="replace") as f:
                data = json.load(f)
            palette_id = data.get("Comfy.ColorPalette", "") or "dark"
            custom_palettes = data.get("Comfy.CustomColorPalettes", {})

        # Try to get colors from custom palette first, then builtins, then fallback
        colors = {}
        if palette_id in custom_palettes:
            c = custom_palettes[palette_id].get("colors", {})
            cb = c.get("comfy_base", {})
            lg = c.get("litegraph_base", {})
            colors = {
                "bg":       cb.get("bg-color", "#202020"),
                "menu_bg":  cb.get("comfy-menu-bg", "#171718"),
                "fg":       cb.get("fg-color", "#ffffff"),
                "border":   cb.get("border-color", "#4e4e4e"),
                "input_bg": cb.get("comfy-input-bg", "#222222"),
                "accent":   lg.get("NODE_BOX_OUTLINE_COLOR") or lg.get("LINK_COLOR") or "#888",
                "node_bg":  lg.get("NODE_DEFAULT_BGCOLOR", "#353535"),
            }
        else:
            # Try reading from the frontend package palette files
            try:
                import glob as _glob
                import site as _site
                site_dir = _site.getsitepackages()[0]
                palette_files = _glob.glob(
                    os.path.join(site_dir, "comfyui_frontend_package*",
                                 "static", "assets", "palettes", f"{palette_id}.json"))
                if palette_files:
                    with open(palette_files[0], "r", errors="replace") as f:
                        pdata = json.load(f)
                    # Use 'id' from JSON as authoritative palette ID (matches EZi approach)
                    _ = pdata.get("id") or palette_id
                    cb = pdata.get("colors", {}).get("comfy_base", {})
                    lg = pdata.get("colors", {}).get("litegraph_base", {})
                    colors = {
                        "bg":       cb.get("bg-color", "#202020"),
                        "menu_bg":  cb.get("comfy-menu-bg", "#171718"),
                        "fg":       cb.get("fg-color", "#ffffff"),
                        "border":   cb.get("border-color", "#4e4e4e"),
                        "input_bg": cb.get("comfy-input-bg", "#222222"),
                        "accent":   lg.get("NODE_BOX_OUTLINE_COLOR") or lg.get("LINK_COLOR") or "#888",
                        "node_bg":  lg.get("NODE_DEFAULT_BGCOLOR", "#353535"),
                    }
            except Exception:
                pass
            if not colors:
                colors = _BUILTIN_PALETTES.get(palette_id, _BUILTIN_PALETTES["dark"])

        bg       = colors.get("bg", "#202020")
        menu_bg  = colors.get("menu_bg", "#171718")
        fg       = colors.get("fg", "#ffffff")
        border   = colors.get("border", "#4e4e4e")
        input_bg = colors.get("input_bg", "#222222")
        accent   = colors.get("accent", "#888888")
        node_bg  = colors.get("node_bg", "#353535")

        # Derive accent variants
        acc_lum = _hex_luminance(accent)
        if acc_lum >= 0.18:
            acc_bg       = _blend_hex(accent, "#000000", 0.60)
            acc_bg_hover = _blend_hex(accent, "#000000", 0.45)
        else:
            acc_bg       = _blend_hex(accent, "#ffffff", 0.60)
            acc_bg_hover = _blend_hex(accent, "#ffffff", 0.45)
        acc_lum2 = _hex_luminance(acc_bg)
        text_on_accent = "#ffffff" if acc_lum2 < 0.35 else "#111111"
        acc_hover = _blend_hex(accent, "#ffffff", 0.30)

        # Muted text (blend fg toward bg)
        muted = _blend_hex(fg, bg, 0.55)

        return {
            "palette_id":       palette_id,
            "--bg":             menu_bg,
            "--panel-bg":       menu_bg,
            "--node-bg":        node_bg,
            "--fg":             fg,
            "--muted":          muted,
            "--border":         border,
            "--input-bg":       input_bg,
            "--accent":         accent,
            "--accent-hover":   acc_hover,
            "--accent-bg":      acc_bg,
            "--accent-bg-hover":acc_bg_hover,
            "--text-on-accent": text_on_accent,
        }
    except Exception as e:
        return {"error": str(e)}


def list_comfy_themes():
    """Return list of available palette IDs: builtins + any custom palettes."""
    ids = list(_BUILTIN_PALETTES.keys())
    try:
        user_dir = os.path.join(SCRIPT_DIR, "ComfyUI", "user", "default")
        settings_file = os.path.join(user_dir, "comfy.settings.json")
        if os.path.isfile(settings_file):
            with open(settings_file, "r", errors="replace") as f:
                data = json.load(f)
            custom = list(data.get("Comfy.CustomColorPalettes", {}).keys())
            ids = ids + [c for c in custom if c not in ids]
        # Also scan frontend package palette JSON files — use 'id' field inside each JSON
        try:
            import glob as _glob, site as _site
            site_dir = _site.getsitepackages()[0]
            for p in sorted(_glob.glob(os.path.join(
                    site_dir, "comfyui_frontend_package*",
                    "static", "assets", "palettes", "*.json"))):
                try:
                    with open(p, "r", errors="replace") as f:
                        pdata = json.load(f)
                    pid = pdata.get("id") or os.path.splitext(os.path.basename(p))[0]
                    if pid and pid not in ids:
                        ids.append(pid)
                except Exception:
                    continue
        except Exception:
            pass
    except Exception:
        pass
    return ids


def set_comfy_theme(palette_id):
    """Write Comfy.ColorPalette into comfy.settings.json. Returns dict."""
    try:
        user_dir = os.path.join(SCRIPT_DIR, "ComfyUI", "user", "default")
        os.makedirs(user_dir, exist_ok=True)
        settings_file = os.path.join(user_dir, "comfy.settings.json")
        data = {}
        if os.path.isfile(settings_file):
            with open(settings_file, "r", errors="replace") as f:
                data = json.load(f)
        data["Comfy.ColorPalette"] = palette_id
        tmp = settings_file + ".tmp"
        with open(tmp, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        os.replace(tmp, settings_file)
        return {"ok": True, "palette_id": palette_id}
    except Exception as e:
        return {"error": str(e)}


def get_comfyui_versions():
    """Return list of recent ComfyUI git tags (newest first, max 20)."""
    comfy_dir = os.path.join(SCRIPT_DIR, "ComfyUI")
    try:
        r = subprocess.run(
            ["git", "tag", "--sort=-creatordate"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=10,
        )
        tags = [t.strip() for t in r.stdout.splitlines() if t.strip()]
        return tags[:20]
    except Exception:
        return []


# Loading splash shown instantly while server starts up
LOADING_HTML = f"""
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>
  *{{margin:0;padding:0;box-sizing:border-box}}
  body{{background:#1e1e28;color:#e0e0e0;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;
       display:flex;align-items:center;justify-content:center;height:100vh;overflow:hidden}}
  .wrap{{text-align:center}}
  .logo img{{width:96px;height:96px;margin-bottom:16px}}
  .status{{font-size:15px;color:#888;margin-bottom:24px}}
  .bar{{width:200px;height:3px;background:#333;border-radius:2px;margin:0 auto;overflow:hidden}}
  .bar .fill{{width:30%;height:100%;background:linear-gradient(90deg,#50c878,#ffc832);border-radius:2px;
              animation:slide 1.2s ease-in-out infinite}}
  @keyframes slide{{0%{{transform:translateX(-100%)}}100%{{transform:translateX(400%)}}}}
  .hint{{position:fixed;bottom:20px;left:0;right:0;text-align:center;font-size:12px;color:#555}}
</style>
</head>
<body>
<div class="wrap">
  <div class="logo">{('<img src="data:image/png;base64,' + _ICON_B64 + '" alt="ComfyUI">') if _ICON_B64 else ''}</div>
  <div class="status" id="status">Connecting to {COMFYUI_HOST}:{COMFYUI_PORT}...</div>
  <div class="bar"><div class="fill"></div></div>
</div>
<div class="hint">Cmd+B to open in browser &bull; Pixaroma</div>
</body>
</html>
"""

# Combined JS injected once after ComfyUI loads — shortcuts + performance + download fix
INJECTED_JS = """
(function() {
    if (window._comfyDesktopReady) return;
    window._comfyDesktopReady = true;

    /* Cmd+B / Ctrl+B → open in browser */
    document.addEventListener('keydown', function(e) {
        if ((e.metaKey || e.ctrlKey) && e.key === 'b') {
            e.preventDefault();
            pywebview.api.open_browser();
        }
    });

    /* Performance: GPU compositing hint on canvas + EZi Panel Themes */
    var style = document.createElement('style');
    style.textContent = [
        'canvas { will-change: transform; }',
        '* { scroll-behavior: auto !important; }',
        '#_comfy_toast{position:fixed;top:16px;right:16px;background:#333;color:#e0e0e0;padding:10px 18px;',
        'border-radius:8px;font-size:13px;z-index:99999;opacity:0;transition:opacity .3s;pointer-events:none}',
        '#_comfy_toast.show{opacity:1}',
        /* EZi Panel Themes */
        '._ezi-theme-dark{--bg:#1a1a1a;--panel-bg:#1e1e28;--node-bg:#252530;--fg:#e0e0e0;--muted:#888;--border:#444;--input-bg:#111;--accent:#e8530a;--accent-hover:#ff7040;--accent-bg:#6e2200;--accent-bg-hover:#8a3000;--text-on-accent:#fff}',
        '._ezi-theme-pixaroma{--bg:#1a1a1a;--panel-bg:#1e1e28;--node-bg:#252530;--fg:#cccccc;--muted:#888;--border:#444;--input-bg:#111;--accent:#e8530a;--accent-hover:#ff7040;--accent-bg:#6e2200;--accent-bg-hover:#8a3000;--text-on-accent:#fff}',
        '._ezi-theme-light{--bg:#f0f2f5;--panel-bg:#ffffff;--node-bg:#e2e6eb;--fg:#333;--muted:#666;--border:#c8cdd5;--input-bg:#fff;--accent:#e8530a;--accent-hover:#ff7040;--accent-bg:#ffdcc8;--accent-bg-hover:#ffcbb0;--text-on-accent:#000}',
        '._ezi-theme-comfyui{/* Uses ComfyUI theme vars applied via JS */}',
    ].join('\\n');
    document.head.appendChild(style);

    /* Toast helper */
    var toast = document.createElement('div');
    toast.id = '_comfy_toast';
    document.body.appendChild(toast);
    function showToast(msg, ms) {
        toast.textContent = msg;
        toast.classList.add('show');
        setTimeout(function(){ toast.classList.remove('show'); }, ms || 3000);
    }

    /* Extract filename from URL or download attribute */
    function getFilename(a) {
        if (a.getAttribute('download')) return a.getAttribute('download');
        try {
            var u = new URL(a.href);
            var p = u.searchParams.get('filename');
            if (p) return p;
            var parts = u.pathname.split('/');
            var last = parts[parts.length - 1];
            if (last && last.includes('.')) return decodeURIComponent(last);
        } catch(e) {}
        return 'download';
    }

    /* Download interceptor — catch <a download> clicks and image/video URLs */
    document.addEventListener('click', function(e) {
        var a = e.target.closest('a[download], a[href$=".png"], a[href$=".jpg"], a[href$=".mp4"], a[href$=".webp"], a[href$=".jpeg"], a[href$=".gif"]');
        if (a && a.href && !a.href.startsWith('blob:')) {
            e.preventDefault();
            e.stopPropagation();
            var fname = getFilename(a);
            showToast('Saving ' + fname + '...', 2000);
            pywebview.api.save_file(a.href, fname);
            return false;
        }
    }, true);

    /* Override anchor.click() to catch programmatic download links */
    var origClick = HTMLAnchorElement.prototype.click;
    HTMLAnchorElement.prototype.click = function() {
        if (this.hasAttribute('download') && this.href && !this.href.startsWith('blob:')) {
            var fname = getFilename(this);
            showToast('Saving ' + fname + '...', 2000);
            pywebview.api.save_file(this.href, fname);
            return;
        }
        return origClick.apply(this, arguments);
    };

    /* File upload interceptor — fix WKWebView broken <input type=file> */
    var _activeFileInput = null;
    document.addEventListener('click', function(e) {
        var inp = e.target.closest('input[type="file"]');
        if (!inp) {
            /* Only intercept elements explicitly marked for file upload */
            var btn = e.target.closest('.comfy-file-input, [data-upload], label[for]');
            if (btn) {
                var linkedId = btn.getAttribute('for');
                if (linkedId) {
                    var linked = document.getElementById(linkedId);
                    if (linked && linked.type === 'file') inp = linked;
                }
                if (!inp) {
                    var form = btn.closest('.comfy-widget, .comfy-modal, form');
                    if (form) inp = form.querySelector('input[type="file"]');
                }
            }
        }
        if (inp) {
            e.preventDefault();
            e.stopPropagation();
            _activeFileInput = inp;
            var accept = inp.getAttribute('accept') || '*';
            showToast('Opening file picker...', 2000);
            pywebview.api.pick_and_upload(accept);
            return false;
        }
    }, true);

    /* Override input.click() for programmatic file input triggers */
    var origInputClick = HTMLInputElement.prototype.click;
    HTMLInputElement.prototype.click = function() {
        if (this.type === 'file') {
            _activeFileInput = this;
            var accept = this.getAttribute('accept') || '*';
            pywebview.api.pick_and_upload(accept);
            return;
        }
        return origInputClick.apply(this, arguments);
    };

    /* Called by Python after successful upload to update ComfyUI widget */
    window._comfyDesktopUploadDone = function(filename, subfolder, type) {
        showToast('Uploaded: ' + filename, 3000);
        /* Try to refresh ComfyUI's image/video list */
        if (window.app && window.app.refreshComboInNodes) {
            window.app.refreshComboInNodes();
        }
    };

    /* Restore saved zoom level */
    (function(){
        var z = localStorage.getItem('_comfy_zoom');
        if (z) document.body.style.zoom = z;
    })();

    /* ── Desktop Settings Panel (Cmd+Shift+I / Ctrl+Shift+I) ── */
    (function() {
        var PANEL_ID = '_comfy_desktop_panel';

        function removePanel() {
            var p = document.getElementById(PANEL_ID);
            if (p) p.remove();
        }

        function row(label, value) {
            return '<tr><td style="color:var(--muted);padding:4px 12px 4px 0;white-space:nowrap">' +
                   label + '</td><td style="color:var(--fg);padding:4px 0">' + (value||'…') + '</td></tr>';
        }

        function applyTheme(el, t) {
            Object.keys(t).forEach(function(k){
                if (k.startsWith('--')) el.style.setProperty(k, t[k]);
            });
        }

        function buildPanel() {
            if (document.getElementById(PANEL_ID)) { removePanel(); return; }

            var overlay = document.createElement('div');
            overlay.id = PANEL_ID;
            overlay.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:999999;' +
                            'display:flex;align-items:center;justify-content:center;font-family:system-ui';
            overlay.onclick = function(e){ if(e.target===overlay) removePanel(); };

            overlay.innerHTML =
                '<div id="_cdp_inner" style="background:var(--bg,#1e1e28);border:1px solid var(--border,#444);border-radius:14px;' +
                'padding:28px 32px;min-width:400px;max-width:540px;color:var(--fg,#e0e0e0)">' +

                /* header */
                '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px">' +
                '<span style="font-size:16px;font-weight:600">⚙ EZi Desktop</span>' +
                '<button id="_cdp_close" style="background:none;border:none;color:#888;font-size:20px;cursor:pointer;line-height:1">✕</button>' +
                '</div>' +

                /* system info table */
                '<table id="_cdp_info" style="width:100%;border-collapse:collapse;font-size:13px">' +
                '<tr><td colspan="2" style="color:#555;padding-bottom:8px">Loading system info…</td></tr>' +
                '</table>' +

                '<hr style="border:none;border-top:1px solid #333;margin:14px 0">' +

                /* row 1: update + cache */
                '<div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:8px">' +
                '<button id="_cdp_upd" style="' + btnStyle('#2d5a27') + '">Check ComfyUI update</button>' +
                '<button id="_cdp_clr" style="' + btnStyle('#5a2727') + '">Clear cache</button>' +
                '<button id="_cdp_rst" style="' + btnStyle('#5a4010') + '">Restart server</button>' +
                '<button id="_cdp_inst_upd" style="' + btnStyle('#1a3a3a') + '">Check installer update</button>' +
                '<div id="_cdp_ezi_upd_badge" style="display:none;background:#3a1a6e;color:#bd93f9;border:1px solid #bd93f9;border-radius:6px;padding:5px 12px;font-size:12px;font-weight:bold;"></div>' +
                '</div>' +

                /* row 2: folders */
                '<div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:8px">' +
                '<button id="_cdp_fol_out"       style="' + btnStyle('#2a3a5a') + '">📂 Output</button>' +
                '<button id="_cdp_fol_in"        style="' + btnStyle('#2a3a5a') + '">📂 Input</button>' +
                '<button id="_cdp_fol_workflows" style="' + btnStyle('#2a3a5a') + '">📂 Workflows</button>' +
                '<button id="_cdp_fol_models"    style="' + btnStyle('#2a3a5a') + '">📂 Models</button>' +
                '<button id="_cdp_fol_root"      style="' + btnStyle('#2a3a5a') + '">📂 ComfyUI</button>' +
                '</div>' +

                /* row 3: url + browser */
                '<div style="display:flex;gap:8px;align-items:center;margin-bottom:12px">' +
                '<code id="_cdp_url" style="flex:1;background:#111;border:1px solid #333;border-radius:5px;' +
                'padding:5px 10px;font-size:12px;color:#7ec8e3;cursor:pointer;overflow:hidden;white-space:nowrap"' +
                ' title="Click to copy"></code>' +
                '<button id="_cdp_browser" style="' + btnStyle('#2a3a5a') + '">Open in browser</button>' +
                '</div>' +

                /* panel theme selector (EZi themes) */
                '<div style="display:flex;gap:8px;align-items:center;margin-bottom:8px">' +
                '<select id="_cdp_panel_theme" style="flex:1;background:var(--input-bg,#111);border:1px solid var(--border,#444);border-radius:5px;' +
                'padding:5px 8px;font-size:12px;color:var(--fg,#e0e0e0)">' +
                '<option value="comfyui">Panel Theme: ComfyUI (auto)</option>' +
                '<option value="dark">Panel Theme: EZi Dark</option>' +
                '<option value="pixaroma">Panel Theme: Pixaroma</option>' +
                '<option value="light">Panel Theme: EZi Light</option>' +
                '</select>' +
                '<button id="_cdp_panel_theme_apply" style="' + btnStyle('#2a3a5a') + '">Apply</button>' +
                '</div>' +

                /* ComfyUI theme selector (actual ComfyUI palette) */
                '<div style="display:flex;gap:8px;align-items:center;margin-bottom:8px">' +
                '<select id="_cdp_theme" style="flex:1;background:var(--input-bg,#111);border:1px solid var(--border,#444);border-radius:5px;' +
                'padding:5px 8px;font-size:12px;color:var(--fg,#e0e0e0)">' +
                '<option value="">ComfyUI Theme (loading\u2026)</option></select>' +
                '<button id="_cdp_theme_apply" style="' + btnStyle('#2a3a5a') + '">Set ComfyUI Theme</button>' +
                '</div>' +

                /* comfyui version switcher */
                '<div style="display:flex;gap:8px;align-items:center;margin-bottom:8px">' +
                '<select id="_cdp_ver" style="flex:1;background:var(--input-bg,#111);border:1px solid var(--border,#444);border-radius:5px;' +
                'padding:5px 8px;font-size:12px;color:var(--fg,#e0e0e0)">' +
                '<option value="">ComfyUI versions…</option></select>' +
                '<button id="_cdp_switch" style="' + btnStyle('#3a2a5a') + '">Switch ComfyUI</button>' +
                '<button id="_cdp_switch_both" style="' + btnStyle('#5a2a5a') + '" title="Switch ComfyUI + auto-install matching frontend">Switch Both</button>' +
                '</div>' +
                '<label style="font-size:11px;color:var(--muted,#888);display:flex;align-items:center;gap:6px;margin-bottom:8px;cursor:pointer">' +
                '<input type="checkbox" id="_cdp_auto_fe" checked> Auto-detect frontend from requirements.txt' +
                '<span id="_cdp_nightly_badge" style="display:none;background:#ff9800;color:#000;padding:1px 6px;border-radius:3px;font-size:10px;font-weight:600;margin-left:auto">NIGHTLY</span>' +
                '</label>' +

                /* frontend version switcher */
                '<div style="display:flex;gap:8px;align-items:center;margin-bottom:8px">' +
                '<select id="_cdp_fe_ver" style="flex:1;background:#111;border:1px solid #444;border-radius:5px;' +
                'padding:5px 8px;font-size:12px;color:#e0e0e0">' +
                '<option value="">Frontend versions (loading…)</option></select>' +
                '<button id="_cdp_fe_switch" style="' + btnStyle('#3a2a5a') + '">Switch frontend</button>' +
                '</div>' +

                /* custom paths */
                '<details style="margin-bottom:10px">' +
                '<summary style="font-size:12px;color:#888;cursor:pointer;user-select:none">Custom paths (applied on next start)</summary>' +
                '<div style="margin-top:8px;display:grid;grid-template-columns:80px 1fr;gap:6px;align-items:center">' +
                '<label style="font-size:11px;color:#666">Input dir:</label>' +
                '<input id="_cdp_path_in" type="text" placeholder="default" ' +
                'style="background:#111;border:1px solid #444;border-radius:4px;padding:4px 7px;font-size:11px;color:#e0e0e0;outline:none">' +
                '<label style="font-size:11px;color:#666">Output dir:</label>' +
                '<input id="_cdp_path_out" type="text" placeholder="default" ' +
                'style="background:#111;border:1px solid #444;border-radius:4px;padding:4px 7px;font-size:11px;color:#e0e0e0;outline:none">' +
                '<label style="font-size:11px;color:#666">User dir:</label>' +
                '<input id="_cdp_path_usr" type="text" placeholder="default" ' +
                'style="background:#111;border:1px solid #444;border-radius:4px;padding:4px 7px;font-size:11px;color:#e0e0e0;outline:none">' +
                '</div>' +
                '<button id="_cdp_paths_save" style="margin-top:8px;' + btnStyle('#2d5a27') + ';padding:5px 14px">Save paths</button>' +
                '</details>' +

                /* zoom + always on top */
                '<div style="display:flex;gap:8px;align-items:center;margin-bottom:8px">' +
                '<span style="font-size:12px;color:#888;white-space:nowrap">Zoom:</span>' +
                '<button id="_cdp_zm_out" style="' + btnStyle('#333') + ';padding:4px 10px">−</button>' +
                '<span id="_cdp_zm_val" style="font-size:12px;color:#e0e0e0;min-width:36px;text-align:center">100%</span>' +
                '<button id="_cdp_zm_in"  style="' + btnStyle('#333') + ';padding:4px 10px">+</button>' +
                '<button id="_cdp_zm_rst" style="' + btnStyle('#333') + ';padding:4px 10px;font-size:11px">Reset</button>' +
                '<label style="margin-left:12px;font-size:12px;color:#888;display:flex;align-items:center;gap:6px;cursor:pointer">' +
                '<input type="checkbox" id="_cdp_aot"> Always on top</label>' +
                '</div>' +

                /* runtime stats */
                '<div id="_cdp_stats" style="font-size:12px;color:#666;margin-bottom:8px">Loading stats…</div>' +

                /* launch args */
                '<div style="margin-bottom:12px">' +
                '<div style="font-size:11px;color:#666;margin-bottom:4px">Extra launch args (saved, applied on next start):</div>' +
                '<div style="display:flex;gap:8px">' +
                '<input id="_cdp_args" type="text" placeholder="e.g. --lowvram --cpu" ' +
                'style="flex:1;background:#111;border:1px solid #444;border-radius:5px;padding:5px 8px;' +
                'font-size:12px;color:#e0e0e0;outline:none">' +
                '<button id="_cdp_args_save" style="' + btnStyle('#2d5a27') + ';padding:5px 12px">Save</button>' +
                '</div>' +
                '</div>' +

                '<div id="_cdp_msg" style="font-size:12px;color:#888;min-height:16px"></div>' +
                '</div>';

            document.body.appendChild(overlay);
            document.getElementById('_cdp_close').onclick = removePanel;

            /* ── Apply ComfyUI theme to panel + populate theme selector ── */
            pywebview.api.get_comfy_theme().then(function(raw) {
                var t = JSON.parse(raw);
                var inner = document.getElementById('_cdp_inner');
                if (inner && !t.error) applyTheme(inner, t);
                var currentPalette = t.palette_id || '';
                pywebview.api.list_comfy_themes().then(function(raw2) {
                    var themes = JSON.parse(raw2);
                    var sel = document.getElementById('_cdp_theme');
                    sel.innerHTML = themes.map(function(id) {
                        var isCur = id === currentPalette;
                        return '<option value="'+id+'"'+(isCur?' selected':'')+'>'+id+(isCur?' ✓':'')+' </option>';
                    }).join('');
                });
            });

            document.getElementById('_cdp_theme_apply').onclick = function() {
                var sel = document.getElementById('_cdp_theme');
                var pid = sel.value;
                if (!pid) { setMsg('Select a theme first.', '#f88'); return; }
                pywebview.api.set_comfy_theme(pid).then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) { setMsg('Theme error: ' + d.error, '#f88'); return; }
                    setMsg('✓ Theme set to "' + pid + '" — reload page to see it', '#8f8');
                    /* Re-apply panel colours from new theme */
                    pywebview.api.get_comfy_theme().then(function(raw2) {
                        var t = JSON.parse(raw2);
                        var inner = document.getElementById('_cdp_inner');
                        if (inner && !t.error) applyTheme(inner, t);
                    });
                    /* Trigger ComfyUI to reload so the theme takes effect */
                    setTimeout(function() { window.location.reload(); }, 800);
                });
            };

            /* ── Panel Theme (EZi Dark/Light/Pixaroma) ── */
            /* Map ComfyUI theme IDs to EZi panel themes */
            var _comfyToPanel = {
                'dark': 'dark', 'light': 'light', 'github': 'dark', 'nord': 'dark',
                'solarized': 'dark', 'arc': 'dark', 'pixaroma': 'pixaroma'
            };
            function clearInlineThemeVars(el) {
                var toRemove = [];
                for (var i = 0; i < el.style.length; i++) {
                    var prop = el.style[i];
                    if (prop.startsWith('--')) toRemove.push(prop);
                }
                toRemove.forEach(function(p) { el.style.removeProperty(p); });
            }
            function applyPanelTheme(themeId) {
                var inner = document.getElementById('_cdp_inner');
                if (!inner) return;
                /* Remove existing theme classes and inline vars */
                inner.classList.remove('_ezi-theme-dark', '_ezi-theme-pixaroma', '_ezi-theme-light', '_ezi-theme-comfyui');
                clearInlineThemeVars(inner);
                /* If auto-sync mode, fetch current ComfyUI theme and map to panel theme */
                if (!themeId || themeId === 'comfyui') {
                    inner.classList.add('_ezi-theme-comfyui');
                    pywebview.api.get_comfy_theme().then(function(raw) {
                        var t = JSON.parse(raw);
                        if (!t.error) {
                            var comfyId = t.palette_id || 'dark';
                            var panelId = _comfyToPanel[comfyId] || 'dark';
                            inner.classList.remove('_ezi-theme-dark', '_ezi-theme-pixaroma', '_ezi-theme-light', '_ezi-theme-comfyui');
                            inner.classList.add('_ezi-theme-' + panelId);
                            applyTheme(inner, t);
                        }
                    });
                    return;
                }
                /* Manual theme selection - clear inline vars so class vars work */
                inner.classList.add('_ezi-theme-' + themeId);
            }
            /* Load saved panel theme */
            var savedPanelTheme = localStorage.getItem('_comfy_panel_theme') || 'comfyui';
            document.getElementById('_cdp_panel_theme').value = savedPanelTheme;
            applyPanelTheme(savedPanelTheme);
            /* Handle panel theme apply */
            document.getElementById('_cdp_panel_theme_apply').onclick = function() {
                var sel = document.getElementById('_cdp_panel_theme');
                var themeId = sel.value;
                localStorage.setItem('_comfy_panel_theme', themeId);
                applyPanelTheme(themeId);
                setMsg('✓ Panel theme: ' + themeId, '#8f8');
            };

            /* ── populate URL field ── */
            var urlEl = document.getElementById('_cdp_url');
            urlEl.textContent = window.location.origin;
            urlEl.onclick = function() {
                navigator.clipboard.writeText(window.location.origin).then(function() {
                    urlEl.textContent = '✓ Copied!';
                    setTimeout(function(){ urlEl.textContent = window.location.origin; }, 1500);
                });
            };

            /* ── system info ── */
            pywebview.api.get_system_info().then(function(raw) {
                var d = JSON.parse(raw);
                var html = '<tr><td colspan="2" style="color:#555;font-size:11px;padding-bottom:6px;' +
                           'text-transform:uppercase;letter-spacing:.06em">System</td></tr>';
                html += row('Platform', d.platform);
                html += row('Python', d.python);
                html += row('PyTorch', d.torch||'—');
                html += row('GPU / Backend', d.gpu||'—');
                if (d.cuda) html += row('CUDA', d.cuda);
                if (d.mps)  html += row('MPS available', d.mps);
                html += row('ComfyUI rev', d.comfyui_rev||'—');
                html += row('Frontend', d.frontend||'—');
                if (d.disk_free_gb) html += row('Disk free', d.disk_free_gb + ' GB');
                document.getElementById('_cdp_info').innerHTML = html;
            });

            /* ── cache info ── */
            function refreshCache() {
                pywebview.api.get_cache_info().then(function(raw) {
                    var d = JSON.parse(raw);
                    setMsg('Cache — pip: ' + (d.pip||0) + ' MB   uv: ' + (d.uv||0) + ' MB');
                });
            }
            refreshCache();

            /* ── zoom controls ── */
            var _zoom = parseFloat(localStorage.getItem('_comfy_zoom') || '1.0');
            function applyZoom(z) {
                _zoom = Math.max(0.5, Math.min(2.0, Math.round(z * 10) / 10));
                document.getElementById('_cdp_zm_val').textContent = Math.round(_zoom*100) + '%';
                pywebview.api.set_zoom(_zoom);
            }
            applyZoom(_zoom);
            document.getElementById('_cdp_zm_in').onclick  = function(){ applyZoom(_zoom + 0.1); };
            document.getElementById('_cdp_zm_out').onclick = function(){ applyZoom(_zoom - 0.1); };
            document.getElementById('_cdp_zm_rst').onclick = function(){ applyZoom(1.0); };

            /* ── always on top ── */
            document.getElementById('_cdp_aot').onchange = function() {
                pywebview.api.set_always_on_top(this.checked);
            };

            /* ── runtime stats (auto-refresh every 3s while panel open) ── */
            function refreshStats() {
                if (!document.getElementById(PANEL_ID)) return;
                pywebview.api.get_runtime_stats().then(function(raw) {
                    var d = JSON.parse(raw);
                    var parts = [];
                    if (d.process_ram_mb) parts.push('ComfyUI RAM: ' + d.process_ram_mb + ' MB');
                    if (d.ram_total_gb)   parts.push('System RAM: ' + d.ram_total_gb + ' GB total' + (d.ram_avail_gb ? ' / ' + d.ram_avail_gb + ' GB free' : ''));
                    if (d.vram_used_mb !== undefined) {
                        var v = 'VRAM: ' + d.vram_used_mb + ' MB used';
                        if (d.vram_total_mb) v += ' / ' + d.vram_total_mb + ' MB';
                        parts.push(v);
                    }
                    var el = document.getElementById('_cdp_stats');
                    if (el) el.textContent = parts.join('   ') || 'Stats unavailable';
                });
                pywebview.api.get_queue().then(function(raw) {
                    var d = JSON.parse(raw);
                    if (!d.error) {
                        var el = document.getElementById('_cdp_stats');
                        if (el) el.textContent += '   Queue: ' + d.running + ' running / ' + d.pending + ' pending';
                    }
                });
                setTimeout(function(){ if(document.getElementById(PANEL_ID)) refreshStats(); }, 3000);
            }
            refreshStats();

            /* ── launch args ── */
            pywebview.api.get_launch_args().then(function(raw) {
                var d = JSON.parse(raw);
                var inp = document.getElementById('_cdp_args');
                if (inp) inp.value = d.args || '';
            });
            document.getElementById('_cdp_args_save').onclick = function() {
                var val = document.getElementById('_cdp_args').value;
                pywebview.api.save_launch_args(val).then(function(raw) {
                    var d = JSON.parse(raw);
                    setMsg(d.ok ? '✓ Launch args saved (restart to apply)' : 'Error: ' + d.error,
                           d.ok ? '#8f8' : '#f88');
                });
            };

            /* ── installer update check ── */
            document.getElementById('_cdp_inst_upd').onclick = function() {
                var btn = this; btn.disabled = true; btn.textContent = 'Checking…';
                pywebview.api.check_installer_update().then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) setMsg('Installer check failed: ' + d.error, '#f88');
                    else if (d.up_to_date) setMsg('✓ Installer up to date  local: ' + d.local + ' (' + (d.local_date||'?') + ')', '#8f8');
                    else setMsg('↑ ' + d.commits_behind + ' commit(s) behind MAC-Linux  local: ' + d.local + ' (' + (d.local_date||'?') + ')  remote: ' + d.remote + ' (' + (d.remote_date||'?') + ')', '#fc8');
                    btn.disabled = false; btn.textContent = 'Check installer update';
                });
            };

            /* ── Version dropdowns (ComfyUI + Frontend) ── */
            pywebview.api.get_system_info().then(function(infoRaw) {
                var sysInfo = JSON.parse(infoRaw);
                var currentRev = (sysInfo.comfyui_rev || '').split('-')[0].split('+')[0];
                var currentFe  = sysInfo.frontend || '';

                pywebview.api.get_versions().then(function(raw) {
                    var tags = JSON.parse(raw);
                    var sel = document.getElementById('_cdp_ver');
                    if (!tags.length) { sel.innerHTML = '<option value="">No ComfyUI tags found</option>'; return; }
                    sel.innerHTML = tags.map(function(t) {
                        var isCur = currentRev && t === currentRev;
                        return '<option value="'+t+'"'+(isCur?' selected':'')+'>'+t+(isCur?' ✓':'')+' </option>';
                    }).join('');
                    if (!currentRev) sel.innerHTML = '<option value="">— select version —</option>' + sel.innerHTML;
                });

                pywebview.api.get_frontend_versions().then(function(raw) {
                    var vers = JSON.parse(raw);
                    var sel = document.getElementById('_cdp_fe_ver');
                    if (!vers.length) { sel.innerHTML = '<option value="">No frontend versions found</option>'; return; }
                    sel.innerHTML = vers.map(function(v) {
                        var isCur = v === currentFe;
                        return '<option value="'+v+'"'+(isCur?' selected':'')+'>'+v+(isCur?' ✓':'')+' </option>';
                    }).join('');
                    if (!currentFe) sel.innerHTML = '<option value="">— select frontend version —</option>' + sel.innerHTML;
                });
            });

            document.getElementById('_cdp_fe_switch').onclick = function() {
                var sel = document.getElementById('_cdp_fe_ver');
                var ver = sel.value;
                if (!ver) { setMsg('Select a frontend version first.', '#f88'); return; }
                if (!confirm('Install frontend v' + ver + '? Server will restart.')) return;
                setMsg('Installing frontend v' + ver + ' — please wait…', '#fc8');
                pywebview.api.set_frontend_version(ver).then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) setMsg('Frontend install failed: ' + d.error, '#f88');
                    else { setMsg('✓ Frontend v' + ver + ' installed — restarting…', '#8f8'); pywebview.api.restart_server(); setTimeout(removePanel, 1500); }
                });
            };

            /* ── Custom paths ── */
            pywebview.api.get_custom_paths().then(function(raw) {
                var d = JSON.parse(raw);
                var fi = document.getElementById('_cdp_path_in');
                var fo = document.getElementById('_cdp_path_out');
                var fu = document.getElementById('_cdp_path_usr');
                if (fi) fi.value = d.input || '';
                if (fo) fo.value = d.output || '';
                if (fu) fu.value = d.user || '';
            });
            document.getElementById('_cdp_paths_save').onclick = function() {
                var fi = document.getElementById('_cdp_path_in').value;
                var fo = document.getElementById('_cdp_path_out').value;
                var fu = document.getElementById('_cdp_path_usr').value;
                pywebview.api.set_custom_paths(fi, fo, fu).then(function(raw) {
                    var d = JSON.parse(raw);
                    setMsg(d.ok ? '✓ Paths saved (restart to apply)' : 'Error: ' + d.error,
                           d.ok ? '#8f8' : '#f88');
                });
            };

            function setMsg(txt, color) {
                var el = document.getElementById('_cdp_msg');
                if (el) { el.textContent = txt; el.style.color = color||'#888'; }
            }

            /* ── button handlers ── */
            document.getElementById('_cdp_upd').onclick = function() {
                var btn = this; btn.disabled = true; btn.textContent = 'Checking…';
                pywebview.api.check_update().then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) setMsg('Update check failed: ' + d.error, '#f88');
                    else if (d.up_to_date) setMsg('✓ Up to date (' + d.local + ')', '#8f8');
                    else setMsg('↑ ' + d.commits_behind + ' commit(s) behind  local:' + d.local + '  remote:' + d.remote, '#fc8');
                    btn.disabled = false; btn.textContent = 'Check for updates';
                });
            };

            document.getElementById('_cdp_clr').onclick = function() {
                var btn = this; btn.disabled = true; btn.textContent = 'Clearing…';
                pywebview.api.clear_cache('all').then(function(raw) {
                    var d = JSON.parse(raw);
                    setMsg(d.cleared.length ? 'Cleared: ' + d.cleared.join(', ') : 'Nothing to clear.');
                    btn.disabled = false; btn.textContent = 'Clear cache';
                    refreshCache();
                });
            };

            document.getElementById('_cdp_rst').onclick = function() {
                var btn = this; btn.disabled = true; btn.textContent = 'Restarting…';
                setMsg('Restarting server — window will reload automatically…', '#fc8');
                pywebview.api.restart_server().then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) { setMsg('Restart failed: ' + d.error, '#f88'); btn.disabled=false; btn.textContent='Restart server'; }
                    else { removePanel(); }
                });
            };

            document.getElementById('_cdp_fol_out').onclick       = function(){ pywebview.api.open_folder('output'); };
            document.getElementById('_cdp_fol_in').onclick          = function(){ pywebview.api.open_folder('input'); };
            document.getElementById('_cdp_fol_workflows').onclick    = function(){ pywebview.api.open_sub_folder('workflows'); };
            document.getElementById('_cdp_fol_models').onclick       = function(){ pywebview.api.open_folder('models'); };
            document.getElementById('_cdp_fol_root').onclick         = function(){ pywebview.api.open_folder('comfyui'); };

            /* ── EZi installer update badge (auto-check on panel open) ── */
            pywebview.api.check_installer_update().then(function(raw) {
                try {
                    var d = JSON.parse(raw);
                    if (!d.error && !d.up_to_date) {
                        var badge = document.getElementById('_cdp_ezi_upd_badge');
                        if (badge) {
                            badge.textContent = '⬆ Installer update available (' + d.commits_behind + ' commits behind)';
                            badge.style.display = 'block';
                        }
                    }
                } catch(e) {}
            });

            document.getElementById('_cdp_browser').onclick = function() {
                pywebview.api.open_browser(); removePanel();
            };

            document.getElementById('_cdp_switch').onclick = function() {
                var sel = document.getElementById('_cdp_ver');
                var tag = sel.value;
                if (!tag) { setMsg('Select a version first.', '#f88'); return; }
                if (!confirm('Switch ComfyUI to ' + tag + '? Server will restart.')) return;
                setMsg('Switching to ' + tag + ' — server will restart…', '#fc8');
                pywebview.api.switch_version(tag).then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) setMsg('Switch failed: ' + d.error, '#f88');
                    else removePanel();
                });
            };

            /* Combined ComfyUI + Frontend switcher (EZi v3.6.2 feature) */
            document.getElementById('_cdp_switch_both').onclick = function() {
                var sel = document.getElementById('_cdp_ver');
                var tag = sel.value;
                if (!tag) { setMsg('Select a ComfyUI version first.', '#f88'); return; }
                var autoFe = document.getElementById('_cdp_auto_fe').checked;
                var feMode = autoFe ? 'auto' : null;
                var msg = autoFe ? 'Switching to ' + tag + ' with auto-detected frontend…' : 'Switching to ' + tag + ' (keeping current frontend)…';
                if (!confirm(msg + ' Server will restart.')) return;
                setMsg(msg, '#fc8');
                pywebview.api.switch_version_and_frontend(tag, feMode).then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) {
                        setMsg('Switch failed: ' + d.error, '#f88');
                        return;
                    }
                    var info = d.results || {};
                    var feInfo = info.frontend || {};
                    var autoVer = info.auto_detected || 'none';
                    if (feInfo.ok) {
                        setMsg('✓ Switched to ' + tag + ' + frontend v' + feInfo.version + ' — restarting…', '#8f8');
                    } else if (autoVer !== 'none') {
                        setMsg('✓ Switched to ' + tag + ' (frontend v' + autoVer + ' install pending) — restarting…', '#8f8');
                    } else {
                        setMsg('✓ Switched to ' + tag + ' — restarting…', '#8f8');
                    }
                    setTimeout(removePanel, 1000);
                });
            };

            /* Check if frontend is nightly and show badge */
            pywebview.api.get_frontend_is_nightly().then(function(raw) {
                var isNightly = JSON.parse(raw);
                if (isNightly) {
                    var badge = document.getElementById('_cdp_nightly_badge');
                    if (badge) badge.style.display = 'inline';
                }
            });
        }

        function btnStyle(bg) {
            return 'background:' + bg + ';color:var(--fg,#e0e0e0);border:1px solid var(--border,#555);border-radius:6px;' +
                   'padding:7px 16px;font-size:13px;cursor:pointer';
        }

        /* Keyboard shortcut: Cmd+Shift+I (mac) or Ctrl+Shift+I (linux) */
        document.addEventListener('keydown', function(e) {
            if (e.shiftKey && e.key === 'I' && (e.metaKey || e.ctrlKey)) {
                e.preventDefault();
                buildPanel();
            }
        });

        /* Also expose globally so it can be called from console */
        window._comfyDesktopPanel = buildPanel;
    })();
})();
"""


def open_in_webview():
    """Open ComfyUI in a native pywebview window."""
    try:
        import webview
    except ImportError:
        print("pywebview not installed — falling back to browser")
        open_in_browser()
        return

    icon = ICON_PATH if os.path.isfile(ICON_PATH) else None

    class Api:
        def open_browser(self):
            """Called from JS when user presses Cmd+B / Ctrl+B."""
            webbrowser.open(COMFYUI_URL)

        def pick_and_upload(self, accept="*"):
            """Open native file picker and upload selected file to ComfyUI."""
            threading.Thread(
                target=self._do_pick_and_upload, args=(accept,), daemon=True
            ).start()

        def _do_pick_and_upload(self, accept):
            """Actual pick+upload logic."""
            file_path = self._native_open_dialog(accept)
            if not file_path:
                self._toast('Upload cancelled')
                return

            filename = os.path.basename(file_path)
            self._toast(f'Uploading {filename}...')

            # Determine upload subfolder based on extension
            ext = os.path.splitext(filename)[1].lower()
            upload_type = 'input'
            subfolder = ''

            # Upload to ComfyUI server
            try:
                import http.client
                import mimetypes

                boundary = '----ComfyDesktopUpload'
                content_type = mimetypes.guess_type(filename)[0] or 'application/octet-stream'

                with open(file_path, 'rb') as f:
                    file_data = f.read()

                body = (
                    f'--{boundary}\r\n'
                    f'Content-Disposition: form-data; name="image"; filename="{filename}"\r\n'
                    f'Content-Type: {content_type}\r\n\r\n'
                ).encode() + file_data + (
                    f'\r\n--{boundary}\r\n'
                    f'Content-Disposition: form-data; name="type"\r\n\r\n'
                    f'{upload_type}'
                    f'\r\n--{boundary}\r\n'
                    f'Content-Disposition: form-data; name="subfolder"\r\n\r\n'
                    f'{subfolder}'
                    f'\r\n--{boundary}\r\n'
                    f'Content-Disposition: form-data; name="overwrite"\r\n\r\n'
                    f'true'
                    f'\r\n--{boundary}--\r\n'
                ).encode()

                conn = http.client.HTTPConnection(COMFYUI_HOST, COMFYUI_PORT, timeout=30)
                conn.request(
                    'POST', '/upload/image',
                    body=body,
                    headers={'Content-Type': f'multipart/form-data; boundary={boundary}'}
                )
                resp = conn.getresponse()
                resp_data = resp.read().decode()
                conn.close()

                if resp.status == 200:
                    import json
                    result = json.loads(resp_data)
                    upl_name = result.get('name', filename)
                    upl_sub = result.get('subfolder', '')
                    upl_type = result.get('type', 'input')
                    self._toast(f'Uploaded: {upl_name}')
                    print(f"  Uploaded: {upl_name} (subfolder={upl_sub}, type={upl_type})")
                    # Notify JS to refresh widgets
                    try:
                        safe_upl_name = upl_name.replace('\\', '\\\\').replace("'", "\\'")
                        safe_upl_sub = upl_sub.replace('\\', '\\\\').replace("'", "\\'")
                        safe_upl_type = upl_type.replace('\\', '\\\\').replace("'", "\\'")
                        window.evaluate_js(
                            f"window._comfyDesktopUploadDone('{safe_upl_name}','{safe_upl_sub}','{safe_upl_type}');"
                        )
                    except Exception:
                        pass
                else:
                    self._toast(f'Upload failed: HTTP {resp.status}')
                    print(f"  Upload failed: {resp.status} {resp_data}")
            except Exception as e:
                self._toast(f'Upload failed: {e}')
                print(f"  Upload error: {e}")

        def _native_open_dialog(self, accept="*"):
            """Open a native file picker. Returns path or None."""
            if sys.platform == 'darwin':
                import subprocess
                # Build file type filter for osascript
                type_str = ''
                if accept and accept != '*':
                    exts = []
                    for part in accept.split(','):
                        part = part.strip().lower()
                        if part.startswith('.'):
                            exts.append('"' + part[1:] + '"')
                        elif 'image' in part:
                            exts.extend(['"png"', '"jpg"', '"jpeg"', '"gif"', '"webp"', '"bmp"', '"tiff"'])
                        elif 'video' in part:
                            exts.extend(['"mp4"', '"mov"', '"webm"', '"avi"', '"mkv"'])
                    if exts:
                        unique = sorted(set(exts))
                        type_str = ' of type {' + ', '.join(unique) + '}'

                script = (
                    f'set f to POSIX path of (choose file with prompt "Choose a file to upload:"{type_str})\n'
                    f'return f'
                )
                try:
                    r = subprocess.run(
                        ['osascript', '-e', script],
                        capture_output=True, text=True, timeout=120,
                    )
                    path = r.stdout.strip()
                    if r.returncode == 0 and path and os.path.isfile(path):
                        return path
                except Exception:
                    pass
                return None

            # Linux: tkinter fallback
            try:
                import tkinter as tk
                from tkinter import filedialog
                root = tk.Tk()
                root.withdraw()
                ftypes = [('All Files', '*.*')]
                if accept and accept != '*':
                    if 'image' in accept:
                        ftypes.insert(0, ('Images', '*.png *.jpg *.jpeg *.gif *.webp *.bmp'))
                    elif 'video' in accept:
                        ftypes.insert(0, ('Videos', '*.mp4 *.mov *.webm *.avi *.mkv'))
                path = filedialog.askopenfilename(
                    initialdir=os.path.expanduser('~/Downloads'),
                    filetypes=ftypes,
                )
                root.destroy()
                return path if path else None
            except Exception:
                pass
            return None

        def save_file(self, url, filename="download"):
            """Download file from server and open native Save As dialog."""
            if not url or not isinstance(url, str):
                return
            # Run in a thread so it doesn't block the webview
            threading.Thread(
                target=self._do_save, args=(url, filename), daemon=True
            ).start()

        def _do_save(self, url, filename):
            """Actual save logic — runs in background thread."""
            save_path = self._native_save_dialog(filename)
            if not save_path:
                self._toast('Save cancelled')
                return
            try:
                urllib.request.urlretrieve(url, save_path)
                basename = os.path.basename(save_path)
                self._toast(f'Saved: {basename}')
                print(f"  Saved: {save_path}")
            except Exception as e:
                self._toast(f'Save failed: {e}')
                print(f"  Save error: {e}")

        def _native_save_dialog(self, filename):
            """Open a native Save As dialog. Returns path or None."""
            downloads = os.path.expanduser('~/Downloads')

            # macOS: use osascript for a real Finder save dialog
            if sys.platform == 'darwin':
                import subprocess
                safe_name = filename.replace('"', '\\"')
                script = (
                    f'set f to POSIX path of (choose file name with prompt '
                    f'"Save as:" default name "{safe_name}" '
                    f'default location POSIX file "{downloads}")\n'
                    f'return f'
                )
                try:
                    r = subprocess.run(
                        ['osascript', '-e', script],
                        capture_output=True, text=True, timeout=120,
                    )
                    path = r.stdout.strip()
                    if r.returncode == 0 and path:
                        return path
                except Exception:
                    pass
                return None

            # Linux: try tkinter file dialog
            try:
                import tkinter as tk
                from tkinter import filedialog
                root = tk.Tk()
                root.withdraw()
                ext = os.path.splitext(filename)[1].lower()
                ftypes = [('All Files', '*.*')]
                if ext in ('.png', '.jpg', '.jpeg', '.webp', '.gif'):
                    ftypes.insert(0, ('Image Files', f'*{ext}'))
                elif ext == '.mp4':
                    ftypes.insert(0, ('Video Files', '*.mp4'))
                path = filedialog.asksaveasfilename(
                    initialdir=downloads,
                    initialfile=filename,
                    filetypes=ftypes,
                )
                root.destroy()
                return path if path else None
            except Exception:
                pass

            # Final fallback: save directly to ~/Downloads
            fallback = os.path.join(downloads, filename)
            # Avoid overwriting — add number suffix
            base, ext = os.path.splitext(fallback)
            counter = 1
            while os.path.exists(fallback):
                fallback = f"{base}_{counter}{ext}"
                counter += 1
            return fallback

        def get_system_info(self):
            """Return system/platform info as a JSON string (called from JS)."""
            return json.dumps(get_system_info())

        def get_cache_info(self):
            """Return pip/uv cache sizes as a JSON string (called from JS)."""
            return json.dumps(get_cache_info())

        def clear_cache(self, cache_type="all"):
            """Clear pip/uv cache. cache_type: 'pip'|'uv'|'all'"""
            cleared = clear_cache(cache_type)
            self._toast(f"Cache cleared: {', '.join(cleared) if cleared else 'nothing to clear'}")
            return json.dumps({"cleared": cleared})

        def check_update(self):
            """Check if ComfyUI has upstream updates. Returns JSON."""
            return json.dumps(check_comfyui_update())

        def get_versions(self):
            """Return list of ComfyUI git tags as a JSON array."""
            return json.dumps(get_comfyui_versions())

        def get_frontend_is_nightly(self):
            """Return True if installed frontend is a nightly/dev build."""
            return json.dumps(get_frontend_is_nightly())

        def get_required_frontend(self, tag):
            """Get the required frontend version for a specific ComfyUI tag."""
            return json.dumps(get_comfyui_required_frontend(tag))

        def switch_version_and_frontend(self, tag, fe_version=None):
            """Switch ComfyUI version and auto-install matching frontend.
            fe_version can be 'auto' to auto-detect from requirements.txt."""
            return json.dumps(switch_comfyui_and_frontend(tag, fe_version))

        def get_comfy_theme(self):
            """Return ComfyUI's active palette CSS vars for the desktop panel."""
            return json.dumps(get_comfy_theme())

        def list_comfy_themes(self):
            """Return list of available ComfyUI palette IDs."""
            return json.dumps(list_comfy_themes())

        def set_comfy_theme(self, palette_id):
            """Write palette_id into comfy.settings.json."""
            return json.dumps(set_comfy_theme(palette_id))

        def get_frontend_versions(self):
            """Return recent comfyui_frontend_package versions from PyPI."""
            return json.dumps(get_frontend_versions())

        def set_frontend_version(self, version):
            """Install a specific frontend version via pip. Returns JSON."""
            return json.dumps(install_frontend_version(version))

        def check_installer_update(self):
            """Check GitHub for a newer ComfyUI-Easy-Install release."""
            return json.dumps(check_installer_update())

        def get_custom_paths(self):
            """Return saved custom input/output/user paths."""
            return json.dumps(get_custom_paths())

        def set_custom_paths(self, input_dir, output_dir, user_dir):
            """Save custom paths into launch args."""
            return json.dumps(set_custom_paths(input_dir, output_dir, user_dir))

        def get_runtime_stats(self):
            """Return RAM usage of the ComfyUI server process and system RAM."""
            stats = {}
            pid_file = os.path.join(SCRIPT_DIR, ".comfyui_server.pid")
            try:
                import resource
                # System RAM via /proc or sysctl
                if sys.platform == "darwin":
                    r = subprocess.run(["sysctl", "-n", "hw.memsize"],
                                       capture_output=True, text=True, timeout=3)
                    total_bytes = int(r.stdout.strip())
                    stats["ram_total_gb"] = round(total_bytes / 1e9, 1)
                elif os.path.isfile("/proc/meminfo"):
                    with open("/proc/meminfo") as f:
                        for line in f:
                            if line.startswith("MemTotal:"):
                                stats["ram_total_gb"] = round(int(line.split()[1]) / 1e6, 1)
                            elif line.startswith("MemAvailable:"):
                                stats["ram_avail_gb"] = round(int(line.split()[1]) / 1e6, 1)
            except Exception:
                pass
            # ComfyUI process RSS
            try:
                if os.path.isfile(pid_file):
                    with open(pid_file) as f:
                        pid = int(f.read().strip())
                    if sys.platform == "darwin":
                        r = subprocess.run(["ps", "-o", "rss=", "-p", str(pid)],
                                           capture_output=True, text=True, timeout=3)
                        rss_kb = int(r.stdout.strip())
                        stats["process_ram_mb"] = round(rss_kb / 1024, 0)
                    elif os.path.isfile(f"/proc/{pid}/status"):
                        with open(f"/proc/{pid}/status") as f2:
                            for line in f2:
                                if line.startswith("VmRSS:"):
                                    stats["process_ram_mb"] = round(int(line.split()[1]) / 1024, 0)
            except Exception:
                pass
            # GPU VRAM
            try:
                import torch
                if sys.platform == "darwin" and torch.backends.mps.is_available():
                    stats["vram_used_mb"] = round(torch.mps.current_allocated_memory() / 1e6, 0)
                elif torch.cuda.is_available():
                    stats["vram_used_mb"]  = round(torch.cuda.memory_allocated(0) / 1e6, 0)
                    stats["vram_total_mb"] = round(torch.cuda.get_device_properties(0).total_memory / 1e6, 0)
            except Exception:
                pass
            return json.dumps(stats)

        def get_queue(self):
            """Return ComfyUI queue depth via its REST API."""
            try:
                import urllib.request as ur
                with ur.urlopen(f"http://{COMFYUI_HOST}:{COMFYUI_PORT}/queue", timeout=2) as r:
                    data = json.loads(r.read())
                running = len(data.get("queue_running", []))
                pending = len(data.get("queue_pending", []))
                return json.dumps({"running": running, "pending": pending})
            except Exception:
                return json.dumps({"error": "unavailable"})

        def set_always_on_top(self, on_top):
            """Toggle always-on-top for the window."""
            try:
                window.on_top = bool(on_top)
            except Exception:
                pass

        def set_zoom(self, level):
            """Set webview zoom level. level: float, e.g. 1.0 = 100%"""
            try:
                window.evaluate_js(
                    f"document.body.style.zoom='{float(level)}';"
                    f"localStorage.setItem('_comfy_zoom','{float(level)}');"
                )
            except Exception:
                pass

        def get_launch_args(self):
            """Return saved extra launch args from window state file."""
            state = load_window_state()
            return json.dumps({"args": state.get("launch_args", "")})

        def save_launch_args(self, args):
            """Persist extra launch args (e.g. --lowvram) to window state file."""
            try:
                state = load_window_state()
                state["launch_args"] = args.strip()
                with open(WINDOW_STATE_FILE, "w") as f:
                    json.dump(state, f)
                return json.dumps({"ok": True})
            except Exception as e:
                return json.dumps({"error": str(e)})

        def open_folder(self, target="comfyui"):
            """Open a folder in Finder/Files. target: 'comfyui'|'output'|'input'|'models'"""
            paths = {
                "comfyui": os.path.join(SCRIPT_DIR, "ComfyUI"),
                "output":  os.path.join(SCRIPT_DIR, "ComfyUI", "output"),
                "input":   os.path.join(SCRIPT_DIR, "ComfyUI", "input"),
                "models":  os.path.join(SCRIPT_DIR, "ComfyUI", "models"),
            }
            path = paths.get(target, paths["comfyui"])
            os.makedirs(path, exist_ok=True)
            try:
                if sys.platform == "darwin":
                    subprocess.Popen(["open", path])
                else:
                    subprocess.Popen(["xdg-open", path])
            except Exception:
                pass

        def open_sub_folder(self, folder_type):
            """Open a ComfyUI sub-folder. folder_type: 'workflows'|'input'|'models'"""
            user_dir = os.path.join(SCRIPT_DIR, "ComfyUI", "user", "default")
            paths = {
                "workflows": os.path.join(user_dir, "workflows"),
                "input":     os.path.join(SCRIPT_DIR, "ComfyUI", "input"),
                "models":    os.path.join(SCRIPT_DIR, "ComfyUI", "models"),
            }
            path = paths.get(folder_type)
            if not path:
                return
            os.makedirs(path, exist_ok=True)
            try:
                if sys.platform == "darwin":
                    subprocess.Popen(["open", path])
                else:
                    subprocess.Popen(["xdg-open", path])
            except Exception:
                pass

        def restart_server(self):
            """Kill the ComfyUI server process — port_monitor will reload the webview when it comes back."""
            pid_file = os.path.join(SCRIPT_DIR, ".comfyui_server.pid")
            if not os.path.isfile(pid_file):
                return json.dumps({"error": "No PID file found"})
            try:
                with open(pid_file) as f:
                    pid = int(f.read().strip())
                os.kill(pid, signal.SIGTERM)
                return json.dumps({"ok": True, "pid": pid})
            except Exception as e:
                return json.dumps({"error": str(e)})

        def switch_version(self, tag):
            """Git checkout a specific ComfyUI tag then restart the server."""
            comfy_dir = os.path.join(SCRIPT_DIR, "ComfyUI")
            if not tag or not os.path.isdir(os.path.join(comfy_dir, ".git")):
                return json.dumps({"error": "Invalid tag or not a git repo"})
            def _do_switch():
                try:
                    subprocess.run(["git", "checkout", tag], cwd=comfy_dir,
                                   capture_output=True, timeout=30)
                    self.restart_server()
                except Exception:
                    pass
            threading.Thread(target=_do_switch, daemon=True).start()
            return json.dumps({"ok": True, "tag": tag})

        def confirm_close(self):
            """Called from JS confirm-close dialog — destroy the window."""
            self._confirm_close = True
            try:
                window.destroy()
            except Exception:
                pass

        def cancel_close(self):
            """Called from JS confirm-close dialog — dismiss and keep open."""
            self._confirm_close = False

        def _toast(self, msg):
            """Show a toast message in the webview."""
            safe = msg.replace("'", "\\'")
            try:
                window.evaluate_js(
                    f"(function(){{var t=document.getElementById('_comfy_toast');"
                    f"if(t){{t.textContent='{safe}';t.classList.add('show');"
                    f"setTimeout(function(){{t.classList.remove('show')}},3000)}}}})();"
                )
            except Exception:
                pass

    api = Api()
    api._window = None
    api._confirm_close = False

    # Restore saved geometry (falls back to defaults if no state saved)
    _state = load_window_state()
    _win_w = _state.get("width",  WINDOW_WIDTH)
    _win_h = _state.get("height", WINDOW_HEIGHT)
    _win_x = _state.get("x")
    _win_y = _state.get("y")

    # Show window IMMEDIATELY with loading splash — no waiting
    _create_kwargs = dict(
        title=WINDOW_TITLE,
        html=LOADING_HTML,
        width=_win_w,
        height=_win_h,
        resizable=True,
        zoomable=True,
        min_size=(800, 600),
        js_api=api,
    )
    if _win_x is not None and _win_y is not None:
        _create_kwargs["x"] = _win_x
        _create_kwargs["y"] = _win_y
    window = webview.create_window(**_create_kwargs)

    def poll_and_navigate():
        """Background: poll server, then navigate once ready."""
        timeout = 10 if COMFYUI_REMOTE else 120
        if wait_for_server(COMFYUI_HOST, COMFYUI_PORT, timeout=timeout):
            print("ComfyUI server is ready!")
            try:
                window.load_url(COMFYUI_URL)
            except Exception:
                pass
        else:
            # Server unreachable — show error in the splash
            try:
                window.evaluate_js(
                    "document.getElementById('status').textContent="
                    "'Could not reach server. Press Cmd+B to open in browser.';"
                    "document.getElementById('status').style.color='#ff6b6b';"
                )
            except Exception:
                pass

    _navigated = [False]

    def on_loaded():
        """After each page load, inject performance JS (only on ComfyUI page)."""
        if not _navigated[0]:
            # First load is the splash — start background poll
            _navigated[0] = True
            t = threading.Thread(target=poll_and_navigate, daemon=True)
            t.start()
            return
        # Subsequent loads = ComfyUI page — inject JS
        try:
            window.evaluate_js(INJECTED_JS)
        except Exception:
            pass

    def on_closing():
        """Intercept window close — show native confirm dialog if ComfyUI is running.

        IMPORTANT: on_closing runs on the Cocoa main thread on macOS.
        evaluate_js() also needs the main thread (callAfter + semaphore) so
        calling it here deadlocks. Use a native OS dialog on a background
        thread instead, then call window.destroy() if the user confirms.
        """
        if api._confirm_close or COMFYUI_REMOTE:
            return True
        if not is_port_in_use(COMFYUI_PORT):
            return True

        def _ask_and_close():
            confirmed = False
            if sys.platform == "darwin":
                try:
                    r = subprocess.run(
                        [
                            "osascript", "-e",
                            'button returned of (display dialog '
                            '"Stop ComfyUI and close?" '
                            'buttons {"Cancel", "Stop & Close"} '
                            'default button "Stop & Close" '
                            'with title "EZi Desktop" '
                            'with icon caution)',
                        ],
                        capture_output=True, text=True, timeout=60,
                    )
                    confirmed = r.stdout.strip() == "Stop & Close"
                except Exception:
                    confirmed = True
            else:
                try:
                    import tkinter as tk
                    from tkinter import messagebox
                    root = tk.Tk()
                    root.withdraw()
                    confirmed = messagebox.askyesno(
                        "EZi Desktop",
                        "Stop ComfyUI and close?",
                    )
                    root.destroy()
                except Exception:
                    confirmed = True

            if confirmed:
                api._confirm_close = True
                try:
                    window.destroy()
                except Exception:
                    pass

        threading.Thread(target=_ask_and_close, daemon=True).start()
        # Return False to block this close attempt; _ask_and_close will call
        # window.destroy() → on_closing again with _confirm_close=True → True.
        return False

    def on_closed():
        """When the window is closed, save state and signal the server process."""
        save_window_state(window)
        if COMFYUI_REMOTE:
            return
        pid_file = os.path.join(SCRIPT_DIR, ".comfyui_server.pid")
        if os.path.isfile(pid_file):
            try:
                with open(pid_file, "r") as f:
                    pid = int(f.read().strip())
                os.kill(pid, signal.SIGTERM)
            except (ValueError, OSError):
                pass

    def port_monitor():
        """Background: detect ComfyUI restart and reload the webview."""
        _was_up = False
        _down_ticks = 0
        while True:
            time.sleep(1)
            if COMFYUI_REMOTE:
                break
            up = is_port_in_use(COMFYUI_PORT)
            if up:
                _down_ticks = 0
                if not _was_up:
                    _was_up = True
            else:
                if _was_up:
                    _down_ticks += 1
                    if _down_ticks >= 3:
                        _was_up = False
                        _down_ticks = 0
                        print("ComfyUI went offline — watching for restart...")
                        if wait_for_server(COMFYUI_HOST, COMFYUI_PORT, timeout=300):
                            print("ComfyUI restarted — reloading window.")
                            try:
                                window.load_url(COMFYUI_URL)
                            except Exception:
                                pass

    api._window = window  # now safe for Api methods to use

    window.events.closing += on_closing
    window.events.loaded  += on_loaded
    window.events.closed  += on_closed

    threading.Thread(target=port_monitor, daemon=True).start()

    print(f"  Tip: Press Cmd+B (macOS) or Ctrl+B (Linux) to open in browser for file uploads")

    # Start pywebview — private_mode=False may fix file upload dialogs on macOS
    webview.start(icon=icon, private_mode=False, debug=False)


def main():
    # In local mode, warn if port is already bound (another instance running)
    if not COMFYUI_REMOTE and is_port_in_use(COMFYUI_PORT):
        print(
            f"WARNING: Port {COMFYUI_PORT} is already in use. "
            "Another ComfyUI instance may already be running. "
            "Connecting to it instead of starting a new server."
        )

    # Check for display server
    has_display = (
        sys.platform == "darwin"
        or os.environ.get("DISPLAY")
        or os.environ.get("WAYLAND_DISPLAY")
    )

    if has_display:
        # Window opens instantly — server polling happens in background
        print(f"Launching EZi Desktop → {COMFYUI_URL}")
        open_in_webview()
    else:
        # Headless: must wait for server before opening browser
        timeout = 10 if COMFYUI_REMOTE else 120
        print(f"Waiting for ComfyUI server at {COMFYUI_URL}...")
        if not wait_for_server(COMFYUI_HOST, COMFYUI_PORT, timeout=timeout):
            print(f"ERROR: Cannot reach ComfyUI at {COMFYUI_URL}")
            sys.exit(1)
        open_in_browser()


if __name__ == "__main__":
    main()
