#!/usr/bin/env python3
"""
Desktop EZi v3.8.0 — PyWebView wrapper
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

EZI_VERSION = "3.8.0"

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


# ─── ComfyUI-Manager security level ─────────────────────────────────────────

MANAGER_CONFIG_PATH = os.path.join(
    SCRIPT_DIR, "ComfyUI", "custom_nodes", "ComfyUI-Manager", "config.ini"
)


def get_manager_security_level():
    """Read security_level from ComfyUI-Manager config.ini."""
    import configparser
    try:
        cfg = configparser.ConfigParser()
        if os.path.isfile(MANAGER_CONFIG_PATH):
            cfg.read(MANAGER_CONFIG_PATH)
            return cfg.get("default", "security_level", fallback="weak")
    except Exception:
        pass
    return "weak"


def set_manager_security_level(level):
    """Write security_level to ComfyUI-Manager config.ini."""
    import configparser
    valid = {"weak", "normal-", "normal", "strong"}
    if level not in valid:
        return {"error": f"Invalid level '{level}'. Must be one of: {sorted(valid)}"}
    try:
        cfg = configparser.ConfigParser()
        if os.path.isfile(MANAGER_CONFIG_PATH):
            cfg.read(MANAGER_CONFIG_PATH)
        if not cfg.has_section("default"):
            cfg.add_section("default")
        cfg.set("default", "security_level", level)
        os.makedirs(os.path.dirname(MANAGER_CONFIG_PATH), exist_ok=True)
        with open(MANAGER_CONFIG_PATH, "w") as f:
            cfg.write(f)
        return {"ok": True, "level": level}
    except Exception as e:
        return {"error": str(e)}


def manager_config_exists():
    """Return True if ComfyUI-Manager is installed and config.ini exists."""
    return os.path.isfile(MANAGER_CONFIG_PATH)


# ─── Pinned packages ──────────────────────────────────────────────────────────

PINNED_PACKAGES_FILE = os.path.join(SCRIPT_DIR, ".pinned_packages.json")


def get_pinned_packages():
    """Return list of pinned package specs, e.g. ['numpy==1.26.4']."""
    try:
        if os.path.isfile(PINNED_PACKAGES_FILE):
            with open(PINNED_PACKAGES_FILE) as f:
                data = json.load(f)
            return data if isinstance(data, list) else []
    except Exception:
        pass
    return []


def add_pinned_package(spec):
    """Add a pip package spec to the pinned list. Returns dict."""
    spec = spec.strip()
    if not spec:
        return {"error": "Empty package spec"}
    try:
        pkgs = get_pinned_packages()
        pkg_name = spec.split("==")[0].split(">=")[0].split("<=")[0].split("!=")[0].strip().lower()
        pkgs = [p for p in pkgs
                if p.split("==")[0].split(">=")[0].split("<=")[0].split("!=")[0].strip().lower() != pkg_name]
        pkgs.append(spec)
        with open(PINNED_PACKAGES_FILE, "w") as f:
            json.dump(pkgs, f, indent=2)
        return {"ok": True, "packages": pkgs}
    except Exception as e:
        return {"error": str(e)}


def remove_pinned_package(spec):
    """Remove a package spec from the pinned list. Returns dict."""
    try:
        pkgs = get_pinned_packages()
        pkgs = [p for p in pkgs if p != spec]
        with open(PINNED_PACKAGES_FILE, "w") as f:
            json.dump(pkgs, f, indent=2)
        return {"ok": True, "packages": pkgs}
    except Exception as e:
        return {"error": str(e)}


def check_pinned_packages():
    """Return per-package install status for all pinned specs."""
    pkgs = get_pinned_packages()
    if not pkgs:
        return []
    python = os.path.join(SCRIPT_DIR, "python_embeded", "python")
    if not os.path.isfile(python):
        python = sys.executable
    installed_map = {}
    try:
        r = subprocess.run(
            [python, "-m", "pip", "list", "--format=json"],
            capture_output=True, text=True, timeout=20,
        )
        if r.returncode == 0:
            for pkg in json.loads(r.stdout):
                installed_map[pkg["name"].lower().replace("-", "_")] = pkg["version"]
    except Exception:
        pass
    results = []
    for spec in pkgs:
        pkg_name = spec.split("==")[0].split(">=")[0].split("<=")[0].split("!=")[0].strip()
        key = pkg_name.lower().replace("-", "_")
        installed_ver = installed_map.get(key)
        results.append({"spec": spec, "installed": installed_ver, "ok": installed_ver is not None})
    return results


def enforce_pinned_packages():
    """pip-install all pinned packages. Called at startup to enforce versions."""
    pkgs = get_pinned_packages()
    if not pkgs:
        return
    python = os.path.join(SCRIPT_DIR, "python_embeded", "python")
    if not os.path.isfile(python):
        python = sys.executable
    try:
        print(f"  Enforcing {len(pkgs)} pinned package(s): {', '.join(pkgs)}")
        subprocess.run(
            [python, "-m", "pip", "install", "--quiet"] + pkgs,
            capture_output=True, timeout=120,
        )
    except Exception as e:
        print(f"  Warning: pinned packages enforcement failed: {e}")


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

            var S = 'flex:1;background:var(--input-bg,#111);border:1px solid var(--border,#444);border-radius:5px;padding:5px 8px;font-size:12px;color:var(--fg,#e0e0e0)';
            var BOX_HD = 'font-size:10px;font-weight:bold;text-transform:uppercase;letter-spacing:.06em;color:var(--muted,#888);background:var(--input-bg,#111);padding:4px 10px;border-bottom:1px solid var(--border,#444)';
            function box(title, body) { return '<div style="border:1px solid var(--accent,#5294e2);border-radius:6px;overflow:hidden;margin-bottom:10px"><div style="'+BOX_HD+'">'+title+'</div><div style="padding:8px 10px">'+body+'</div></div>'; }
            overlay.innerHTML =
                '<style>' +
                '#_cdp_inner._ezi-theme-dark{--bg:#0c0e12;--border:#30363d;--fg:#ccc;--muted:#8b949e;--input-bg:#0d1117;--accent:#388bfd;--accent-bg:#0d419d}' +
                '#_cdp_inner._ezi-theme-pixaroma{--bg:#111;--border:#2e2e2e;--fg:#ccc;--muted:#888;--input-bg:#0d0d0d;--accent:#e8530a;--accent-bg:#6e2200}' +
                '#_cdp_inner._ezi-theme-light{--bg:#f0f2f5;--border:#c8cdd5;--fg:#24292f;--muted:#57606a;--input-bg:#fff;--accent:#0969da;--accent-bg:#d4e8ff}' +
                '._cdp_tab{padding:4px 8px;font:bold 11px/1.4 inherit;border:1px solid var(--accent,#5294e2);border-radius:4px;background:none;color:var(--accent,#5294e2);cursor:pointer;transition:all .15s;white-space:nowrap}' +
                '._cdp_tab:hover,._cdp_tab.on{background:var(--accent-bg,#0d419d);color:#fff}' +
                '</style>' +
                '<div id="_cdp_inner" style="background:var(--bg,#1e1e28);border:1px solid var(--border,#444);border-radius:14px;' +
                'min-width:500px;max-width:600px;color:var(--fg,#e0e0e0);max-height:88vh;overflow-y:auto">' +
                /* header */
                '<div style="display:flex;justify-content:space-between;align-items:center;padding:14px 20px 6px;flex-shrink:0">' +
                '<span style="font-size:16px;font-weight:600">\u2699 EZi Desktop</span>' +
                '<span style="font-size:11px;color:var(--muted,#888);margin-left:8px">v' + EZI_VERSION + '</span>' +
                '<button id="_cdp_close" style="background:none;border:none;color:var(--muted,#888);font-size:20px;cursor:pointer;line-height:1">\u2715</button>' +
                '</div>' +
                /* tab bar */
                '<div style="padding:6px 20px 0;border-bottom:1px solid var(--border,#444);flex-shrink:0">' +
                '<div style="display:flex;gap:4px;align-items:center;flex-wrap:wrap;padding-bottom:8px">' +
                '<button class="_cdp_tab" data-tab="sys">System Info</button>' +
                '<button class="_cdp_tab" data-tab="add">Add-ons</button>' +
                '<button class="_cdp_tab" data-tab="tls">Tools</button>' +
                '<button class="_cdp_tab" data-tab="app">Appearance</button>' +
                '<button class="_cdp_tab" data-tab="adv">Advanced</button>' +
                '<button onclick="pywebview.api.open_url(\\'https://github.com/Tavris1/ComfyUI-Easy-Install\\')" style="margin-left:auto;padding:4px 12px;font:bold 11px/1.4 inherit;border:1px solid var(--accent,#5294e2);border-radius:4px;background:none;color:var(--accent,#5294e2);cursor:pointer">\uD83C\uDFE0 Home page</button>' +
                '</div></div>' +
                /* scrollable content */
                '<div id="_cdp_content" style="padding:16px 20px">' +
                /* TAB: System Info */
                '<div id="_cdp_t_sys">' +
                '<table id="_cdp_info" style="width:100%;border-collapse:collapse;font-size:12px;margin-bottom:8px"><tr><td colspan="2" style="color:var(--muted,#555)">Loading\u2026</td></tr></table>' +
                '<div id="_cdp_stats" style="font-size:11px;color:var(--muted,#666);margin-bottom:10px">Loading stats\u2026</div>' +
                box('Package Cache', '<div style="display:flex;gap:8px;flex-wrap:wrap">' +
                    '<button id="_cdp_upd" style="'+btnStyle('#2d5a27')+'">Check for updates</button>' +
                    '<button id="_cdp_clr" style="'+btnStyle('#5a2727')+'">Clear cache</button>' +
                    '<button id="_cdp_rst" style="'+btnStyle('#5a4010')+'">Restart server</button>' +
                    '</div>') +
                '</div>' +
                /* TAB: Add-ons */
                '<div id="_cdp_t_add">' +
                '<div id="_cdp_ezi_upd_badge" style="display:none;background:#3a1a6e;color:#bd93f9;border:1px solid #bd93f9;border-radius:6px;padding:5px 12px;font-size:12px;font-weight:bold;margin-bottom:10px"></div>' +
                box('ComfyUI Version',
                    '<div style="display:flex;gap:8px;align-items:center;margin-bottom:6px">' +
                    '<select id="_cdp_ver" style="'+S+'"><option value="">versions\u2026</option></select>' +
                    '<button id="_cdp_switch" style="'+btnStyle('#3a2a5a')+'">Switch</button>' +
                    '<button id="_cdp_switch_both" style="'+btnStyle('#5a2a5a')+'" title="Switch ComfyUI + auto-install matching frontend">Switch Both</button>' +
                    '</div><label style="font-size:11px;color:var(--muted,#888);display:flex;align-items:center;gap:6px;cursor:pointer">' +
                    '<input type="checkbox" id="_cdp_auto_fe" checked> Auto-detect frontend from requirements.txt' +
                    '<span id="_cdp_nightly_badge" style="display:none;background:#ff9800;color:#000;padding:1px 6px;border-radius:3px;font-size:10px;font-weight:600;margin-left:auto">NIGHTLY</span></label>') +
                box('Frontend Version',
                    '<div style="display:flex;gap:8px;align-items:center">' +
                    '<select id="_cdp_fe_ver" style="'+S+'"><option value="">loading\u2026</option></select>' +
                    '<button id="_cdp_fe_switch" style="'+btnStyle('#3a2a5a')+'">Switch</button></div>') +
                box('Updates', '<button id="_cdp_inst_upd" style="'+btnStyle('#1a3a3a')+'">Check installer update</button>') +
                box('\uD83D\uDD25 Torch Pack Installer',
                    '<div style="display:flex;gap:8px;align-items:center;margin-bottom:8px">' +
                    '<select id="_cdp_tp_sel" style="'+S+';flex:1"><option value="">Loading\u2026</option></select>' +
                    '<button id="_cdp_tp_run" style="'+btnStyle('#3a5a2a')+'">Install</button>' +
                    '<button id="_cdp_tp_cancel" style="'+btnStyle('#5a2a2a')+'">Cancel</button></div>' +
                    '<pre id="_cdp_tp_log" style="margin:0;background:var(--input-bg,#0d0d0d);border:1px solid var(--border,#444);border-radius:5px;padding:8px;font-size:11px;color:#c8c8c8;height:180px;overflow-y:auto;white-space:pre-wrap;word-break:break-all;font-family:monospace">Select a script and click Install\u2026</pre>') +
                '</div>' +
                /* TAB: Tools */
                '<div id="_cdp_t_tls">' +
                box('Server',
                    '<div style="display:flex;gap:8px;align-items:center">' +
                    '<code id="_cdp_url" style="flex:1;background:var(--input-bg,#111);border:1px solid var(--border,#333);border-radius:5px;padding:5px 10px;font-size:12px;color:#7ec8e3;cursor:pointer;overflow:hidden;white-space:nowrap" title="Click to copy"></code>' +
                    '<button id="_cdp_browser" style="'+btnStyle('#2a3a5a')+'">Open in browser</button></div>') +
                box('Open Folder', '<div style="display:flex;gap:6px;flex-wrap:wrap">' +
                    '<button id="_cdp_fol_out"       style="'+btnStyle('#2a3a5a')+'">\uD83D\uDCC2 Output</button>' +
                    '<button id="_cdp_fol_in"        style="'+btnStyle('#2a3a5a')+'">\uD83D\uDCC2 Input</button>' +
                    '<button id="_cdp_fol_workflows" style="'+btnStyle('#2a3a5a')+'">\uD83D\uDCC2 Workflows</button>' +
                    '<button id="_cdp_fol_models"    style="'+btnStyle('#2a3a5a')+'">\uD83D\uDCC2 Models</button>' +
                    '<button id="_cdp_fol_root"      style="'+btnStyle('#2a3a5a')+'">\uD83D\uDCC2 ComfyUI</button></div>') +
                box('Launch Args (applied on next start)',
                    '<div style="display:flex;gap:8px"><input id="_cdp_args" type="text" placeholder="e.g. --lowvram --cpu" style="'+S+';outline:none">' +
                    '<button id="_cdp_args_save" style="'+btnStyle('#2d5a27')+';padding:5px 12px">Save</button></div>') +
                box('Custom Paths (applied on next start)',
                    '<div style="display:grid;grid-template-columns:70px 1fr;gap:5px;align-items:center;margin-bottom:8px">' +
                    '<label style="font-size:11px;color:var(--muted,#666)">Input:</label><input id="_cdp_path_in" type="text" placeholder="default" style="background:var(--input-bg,#111);border:1px solid var(--border,#444);border-radius:4px;padding:4px 7px;font-size:11px;color:var(--fg,#e0e0e0);outline:none">' +
                    '<label style="font-size:11px;color:var(--muted,#666)">Output:</label><input id="_cdp_path_out" type="text" placeholder="default" style="background:var(--input-bg,#111);border:1px solid var(--border,#444);border-radius:4px;padding:4px 7px;font-size:11px;color:var(--fg,#e0e0e0);outline:none">' +
                    '<label style="font-size:11px;color:var(--muted,#666)">User:</label><input id="_cdp_path_usr" type="text" placeholder="default" style="background:var(--input-bg,#111);border:1px solid var(--border,#444);border-radius:4px;padding:4px 7px;font-size:11px;color:var(--fg,#e0e0e0);outline:none"></div>' +
                    '<button id="_cdp_paths_save" style="'+btnStyle('#2d5a27')+';padding:5px 14px">Save paths</button>') +
                '</div>' +
                /* TAB: Appearance */
                '<div id="_cdp_t_app">' +
                box('EZi Panel Theme',
                    '<div style="display:flex;gap:8px;align-items:center">' +
                    '<select id="_cdp_panel_theme" style="'+S+'"><option value="comfyui">ComfyUI (auto-sync)</option><option value="dark">EZi Dark</option><option value="pixaroma">Pixaroma \u2014 orange</option><option value="light">EZi Light</option></select>' +
                    '<button id="_cdp_panel_theme_apply" style="'+btnStyle('#2a3a5a')+'">Apply</button></div>') +
                box('ComfyUI Node Editor Theme',
                    '<div style="display:flex;gap:8px;align-items:center">' +
                    '<select id="_cdp_theme" style="'+S+'"><option value="">Loading\u2026</option></select>' +
                    '<button id="_cdp_theme_apply" style="'+btnStyle('#2a3a5a')+'">Set Theme</button></div>') +
                box('View',
                    '<div style="display:flex;gap:8px;align-items:center;margin-bottom:8px">' +
                    '<span style="font-size:12px;color:var(--muted,#888)">Zoom:</span>' +
                    '<button id="_cdp_zm_out" style="'+btnStyle('#333')+';padding:4px 10px">\u2212</button>' +
                    '<span id="_cdp_zm_val" style="font-size:12px;color:var(--fg,#e0e0e0);min-width:36px;text-align:center">100%</span>' +
                    '<button id="_cdp_zm_in"  style="'+btnStyle('#333')+';padding:4px 10px">+</button>' +
                    '<button id="_cdp_zm_rst" style="'+btnStyle('#333')+';padding:4px 10px;font-size:11px">Reset</button></div>' +
                    '<label style="font-size:12px;color:var(--muted,#888);display:flex;align-items:center;gap:6px;cursor:pointer"><input type="checkbox" id="_cdp_aot"> Always on top</label>') +
                '</div>' +
                /* TAB: Advanced */
                '<div id="_cdp_t_adv">' +
                box('ComfyUI-Manager Security Level',
                    '<div style="position:relative"><div style="display:flex;gap:8px;align-items:center">' +
                    '<select id="_cdp_sec_lvl" style="'+S+'"><option value="weak">weak</option><option value="normal-">normal-</option><option value="normal">normal</option><option value="strong">strong</option></select>' +
                    '<button id="_cdp_sec_info" title="Security level info" style="width:20px;height:20px;border-radius:50%;border:1px solid var(--accent,#5294e2);background:none;color:var(--accent,#5294e2);font-size:11px;font-weight:bold;cursor:pointer;flex-shrink:0;display:inline-flex;align-items:center;justify-content:center;padding:0">i</button>' +
                    '<button id="_cdp_sec_apply" style="'+btnStyle('#2a3a5a')+';padding:5px 12px">Apply</button></div>' +
                    '<div id="_cdp_sec_tip" style="display:none;position:absolute;z-index:10;left:0;top:100%;margin-top:4px;background:var(--bg,#202020);border:1px solid var(--border,#444);border-radius:6px;padding:8px 12px;font-size:11px;color:var(--fg,#e0e0e0);line-height:1.7;max-width:340px;box-shadow:0 4px 16px rgba(0,0,0,.5)">' +
                    '<b>strong</b> \u2014 blocks high and middle risk features<br><b>normal</b> \u2014 blocks only high risk features<br><b>normal-</b> \u2014 blocks high risk only when --listen is non-localhost<br><b>weak</b> \u2014 all features available</div></div>') +
                box('Pinned Packages Manager',
                    '<div id="_cdp_pins" style="margin-bottom:6px"></div>' +
                    '<div style="display:flex;gap:8px"><input id="_cdp_pin_inp" type="text" placeholder="e.g. numpy==1.26.4" style="'+S+';outline:none">' +
                    '<button id="_cdp_pin_add" style="'+btnStyle('#2d5a27')+';padding:5px 12px">Add</button></div>') +
                '</div>' +
                '</div>' +
                /* footer */
                '<div style="padding:6px 20px 12px;flex-shrink:0"><div id="_cdp_msg" style="font-size:12px;color:var(--muted,#888);min-height:16px"></div></div>' +
                '</div>';

            document.body.appendChild(overlay);
            document.getElementById('_cdp_close').onclick = removePanel;

            /* ── Tab switching ── */
            (function() {
                var _tabs = ['sys','add','tls','app','adv'];
                function showTab(name) {
                    _tabs.forEach(function(t) {
                        document.getElementById('_cdp_t_' + t).style.display = (t === name) ? 'block' : 'none';
                        var b = document.querySelector('._cdp_tab[data-tab="' + t + '"]');
                        if (b) b.classList.toggle('on', t === name);
                    });
                    try { localStorage.setItem('_cdp_tab', name); } catch(e) {}
                }
                document.querySelectorAll('._cdp_tab').forEach(function(b) {
                    b.addEventListener('click', function() { showTab(this.getAttribute('data-tab')); });
                });
                var st = 'sys';
                try { st = localStorage.getItem('_cdp_tab') || 'sys'; } catch(e) {}
                showTab(st);
            })();

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

            /* ── ComfyUI-Manager security level ── */
            pywebview.api.get_manager_security_level().then(function(raw) {
                var d = JSON.parse(raw);
                var sel = document.getElementById('_cdp_sec_lvl');
                if (sel && d.level) sel.value = d.level;
            });
            document.getElementById('_cdp_sec_apply').onclick = function() {
                var lvl = document.getElementById('_cdp_sec_lvl').value;
                pywebview.api.set_manager_security_level(lvl).then(function(raw) {
                    var d = JSON.parse(raw);
                    setMsg(d.ok ? '\u2713 Security level set to "' + lvl + '" \u2014 restart ComfyUI to apply'
                                : 'Error: ' + d.error,
                           d.ok ? '#8f8' : '#f88');
                });
            };
            (function() {
                var infoBtn = document.getElementById('_cdp_sec_info');
                var tip = document.getElementById('_cdp_sec_tip');
                if (!infoBtn || !tip) return;
                infoBtn.onclick = function(e) {
                    e.stopPropagation();
                    tip.style.display = tip.style.display === 'none' ? 'block' : 'none';
                };
                document.addEventListener('click', function() { tip.style.display = 'none'; });
            })();

            /* ── Pinned packages ── */
            function refreshPins() {
                pywebview.api.check_pinned_packages().then(function(raw) {
                    var pkgs = JSON.parse(raw);
                    var el = document.getElementById('_cdp_pins');
                    if (!el) return;
                    if (!pkgs.length) {
                        el.innerHTML = '<span style="font-size:11px;color:#555">No pinned packages</span>';
                        return;
                    }
                    el.innerHTML = pkgs.map(function(p) {
                        var icon = p.ok ? '\u2713' : '\u26a0';
                        var icol = p.ok ? '#8f8' : '#fa8';
                        var ver  = p.ok ? (' <span style="font-size:10px;color:#666">' + p.installed + '</span>') : ' <span style="font-size:10px;color:#f88">not installed</span>';
                        return '<div style="display:flex;align-items:center;gap:6px;margin-bottom:3px">' +
                               '<span style="color:' + icol + ';font-size:14px">' + icon + '</span>' +
                               '<span style="font-size:12px;color:var(--fg,#e0e0e0);flex:1">' + p.spec + ver + '</span>' +
                               '<button class="_cdp_pin_rm" data-pkg="' + p.spec.replace(/"/g, '&quot;') + '" ' +
                               'style="background:none;border:none;color:#888;cursor:pointer;font-size:14px;padding:0 4px" title="Remove">\u2715</button>' +
                               '</div>';
                    }).join('');
                    el.querySelectorAll('._cdp_pin_rm').forEach(function(btn) {
                        btn.onclick = function() {
                            var pkg = this.getAttribute('data-pkg');
                            pywebview.api.remove_pinned_package(pkg).then(function() { refreshPins(); });
                        };
                    });
                });
            }
            refreshPins();
            document.getElementById('_cdp_pin_add').onclick = function() {
                var spec = document.getElementById('_cdp_pin_inp').value.trim();
                if (!spec) { setMsg('Enter a package spec (e.g. numpy==1.26.4)', '#f88'); return; }
                pywebview.api.add_pinned_package(spec).then(function(raw) {
                    var d = JSON.parse(raw);
                    if (d.error) { setMsg('Error: ' + d.error, '#f88'); return; }
                    document.getElementById('_cdp_pin_inp').value = '';
                    setMsg('\u2713 Pinned: ' + spec + ' (enforced on next start)', '#8f8');
                    refreshPins();
                });
            };
            document.getElementById('_cdp_pin_inp').addEventListener('keydown', function(e) {
                if (e.key === 'Enter') document.getElementById('_cdp_pin_add').click();
            });

            /* ── Torch Pack installer ── */
            (function() {
                var _tp_iid = null;
                var _tp_last = 0;
                /* populate dropdown */
                pywebview.api.list_torch_packs().then(function(raw) {
                    var packs = JSON.parse(raw);
                    var sel = document.getElementById('_cdp_tp_sel');
                    if (!sel) return;
                    if (!packs.length) {
                        sel.innerHTML = '<option value="">No Torch Pack scripts found</option>';
                        return;
                    }
                    var isMac = /mac/i.test(navigator.platform);
                    sel.innerHTML = packs.map(function(p) {
                        var label = p.name + (p.mac ? ' \u2014 macOS' : (p.cuda ? ' \u2014 CUDA' : ''));
                        var hi = (isMac && p.mac) || (!isMac && p.cuda);
                        return '<option value="' + p.filename + '"' + (hi ? ' style="font-weight:bold;color:#8f8"' : '') + '>' + label + '</option>';
                    }).join('');
                });
                /* install button */
                document.getElementById('_cdp_tp_run').onclick = function() {
                    var sel = document.getElementById('_cdp_tp_sel');
                    var fn = sel ? sel.value : '';
                    if (!fn) { setMsg('Select a Torch Pack script first.', '#f88'); return; }
                    var log = document.getElementById('_cdp_tp_log');
                    if (log) { log.textContent = 'Starting ' + fn + '\u2026\\n'; }
                    _tp_last = 0;
                    if (_tp_iid) { clearInterval(_tp_iid); _tp_iid = null; }
                    pywebview.api.run_torch_pack(fn).then(function(raw) {
                        var d = JSON.parse(raw);
                        if (d.error) { if (log) log.textContent += 'ERROR: ' + d.error + '\\n'; return; }
                        _tp_iid = setInterval(function() {
                            pywebview.api.get_torch_pack_log().then(function(raw2) {
                                var ld = JSON.parse(raw2);
                                if (ld.lines.length > _tp_last) {
                                    var added = ld.lines.slice(_tp_last).join('\\n');
                                    if (log) { log.textContent += added + '\\n'; log.scrollTop = log.scrollHeight; }
                                    _tp_last = ld.lines.length;
                                }
                                if (ld.done) {
                                    clearInterval(_tp_iid); _tp_iid = null;
                                    if (log) { log.textContent += '\u2014 Done \u2014\\n'; log.scrollTop = log.scrollHeight; }
                                }
                            });
                        }, 500);
                    });
                };
                /* cancel button */
                document.getElementById('_cdp_tp_cancel').onclick = function() {
                    if (_tp_iid) { clearInterval(_tp_iid); _tp_iid = null; }
                    pywebview.api.cancel_torch_pack().then(function() {
                        var log = document.getElementById('_cdp_tp_log');
                        if (log) { log.textContent += '\u2014 Cancelled \u2014\\n'; log.scrollTop = log.scrollHeight; }
                    });
                };
            })();

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

        def _check_ezi_update(self):
            """Background: poll GitHub releases to see if a newer EZi Desktop is available."""
            try:
                import urllib.request as _ur
                url = "https://api.github.com/repos/Tavris1/ComfyUI-Easy-Install/releases/latest"
                req = _ur.Request(url, headers={"User-Agent": "ComfyUI-Desktop-Mac"})
                with _ur.urlopen(req, timeout=8) as r:
                    data = json.loads(r.read())
                tag = data.get("tag_name", "").strip().lstrip("v")
                if not tag:
                    return
                local_parts  = [int(x) for x in EZI_VERSION.split(".") if x.isdigit()]
                remote_parts = [int(x) for x in tag.split(".")      if x.isdigit()]
                if remote_parts > local_parts:
                    display = "v" + tag
                    safe = display.replace("'", "\\'")
                    self._toast(f"EZi Desktop {safe} available — visit GitHub to update")
            except Exception:
                pass

        def get_ui_settings(self):
            """Return persisted UI settings as JSON."""
            state = load_window_state()
            settings = state.get("ui_settings", {})
            return json.dumps(settings)

        def save_ui_settings(self, settings_json):
            """Persist UI settings (theme, zoom, etc.) to window state file."""
            try:
                if not settings_json or not isinstance(settings_json, str):
                    return json.dumps({"error": "invalid input"})
                data = json.loads(settings_json)
                if not isinstance(data, dict):
                    return json.dumps({"error": "not a dict"})
                state = load_window_state()
                state["ui_settings"] = data
                with open(WINDOW_STATE_FILE, "w") as f:
                    json.dump(state, f)
                return json.dumps({"ok": True})
            except Exception as e:
                return json.dumps({"error": str(e)})

        def get_custom_paths(self):
            """Return saved custom input/output/user paths."""
            return json.dumps(get_custom_paths())

        def set_custom_paths(self, input_dir, output_dir, user_dir):
            """Save custom paths into launch args."""
            return json.dumps(set_custom_paths(input_dir, output_dir, user_dir))

        def get_manager_security_level(self):
            """Return current ComfyUI-Manager security level."""
            return json.dumps({"level": get_manager_security_level()})

        def set_manager_security_level(self, level):
            """Set ComfyUI-Manager security level (restart ComfyUI to apply)."""
            return json.dumps(set_manager_security_level(level))

        def get_pinned_packages(self):
            """Return list of pinned package specs."""
            return json.dumps(get_pinned_packages())

        def add_pinned_package(self, spec):
            """Add a package spec to the pinned list."""
            return json.dumps(add_pinned_package(spec))

        def remove_pinned_package(self, spec):
            """Remove a package spec from the pinned list."""
            return json.dumps(remove_pinned_package(spec))

        def manager_config_exists(self):
            """Return True if ComfyUI-Manager config.ini exists."""
            return json.dumps(manager_config_exists())

        def check_pinned_packages(self):
            """Return per-package install status for all pinned specs."""
            return json.dumps(check_pinned_packages())

        def open_url(self, url):
            """Open an arbitrary URL in the system browser."""
            try:
                webbrowser.open(url)
            except Exception:
                pass

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

        def retry(self, cols=0):
            """Restart ComfyUI with optional custom TQDM column width."""
            try:
                if cols and int(cols) > 0:
                    os.environ['TQDM_NCOLS'] = str(max(40, int(cols)))
            except Exception:
                pass
            self.restart_server()
            return json.dumps({"ok": True})

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

        def list_torch_packs(self):
            """Return metadata for every .sh file in Add-Ons/Torch-Pack/."""
            tp_dir = os.path.join(SCRIPT_DIR, "Add-Ons", "Torch-Pack")
            if not os.path.isdir(tp_dir):
                return json.dumps([])
            results = []
            for fname in sorted(os.listdir(tp_dir)):
                if not fname.endswith(".sh"):
                    continue
                is_mac  = "-mac" in fname.lower()
                is_cuda = any(x in fname for x in ("cu118", "cu121", "cu124", "cu126", "cu128", "cu130"))
                # derive a pretty display name
                stem = fname.replace(".sh", "")
                name = stem.replace("-mac", " (macOS)").replace("+", " ").replace("-", " ")
                results.append({
                    "filename": fname,
                    "name":     name,
                    "mac":      is_mac,
                    "cuda":     is_cuda,
                })
            return json.dumps(results)

        def run_torch_pack(self, filename):
            """Launch a Torch-Pack installer script and stream its output."""
            import re as _re
            # Safety: filename must be a plain basename ending in .sh, no path separators
            if not filename or not filename.endswith(".sh") or os.sep in filename or "/" in filename:
                return json.dumps({"error": "Invalid filename"})
            tp_dir  = os.path.join(SCRIPT_DIR, "Add-Ons", "Torch-Pack")
            script  = os.path.join(tp_dir, filename)
            if not os.path.isfile(script):
                return json.dumps({"error": "Script not found"})
            # Kill any previous install still running
            if getattr(self, "_tp_proc", None) and self._tp_proc.poll() is None:
                try:
                    self._tp_proc.terminate()
                except Exception:
                    pass
            self._tp_buf  = []
            self._tp_done = False
            _ANSI = _re.compile(r"\x1b\[[0-9;]*[mGKHF]")
            def _reader(proc):
                try:
                    for line in proc.stdout:
                        self._tp_buf.append(_ANSI.sub("", line.rstrip("\n")))
                except Exception:
                    pass
                finally:
                    proc.wait()
                    self._tp_done = True
            try:
                proc = subprocess.Popen(
                    ["bash", script],
                    cwd=tp_dir,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    bufsize=1,
                )
                self._tp_proc = proc
                threading.Thread(target=_reader, args=(proc,), daemon=True).start()
                return json.dumps({"ok": True})
            except Exception as e:
                return json.dumps({"error": str(e)})

        def get_torch_pack_log(self):
            """Return accumulated installer output lines and done flag."""
            lines = list(getattr(self, "_tp_buf", []))
            done  = bool(getattr(self, "_tp_done", True))
            return json.dumps({"lines": lines, "done": done})

        def cancel_torch_pack(self):
            """Kill the running Torch-Pack installer."""
            proc = getattr(self, "_tp_proc", None)
            if proc and proc.poll() is None:
                try:
                    proc.terminate()
                except Exception:
                    pass
            self._tp_done = True
            return json.dumps({"ok": True})

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
            # After server is up, check for EZi Desktop updates in background
            try:
                api._check_ezi_update()
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
            window.evaluate_js(f"const EZI_VERSION={repr(EZI_VERSION)};\n" + INJECTED_JS)
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
        """When the window is closed, save state, backup ComfyUI storage, and signal the server process."""
        # Try to backup ComfyUI localStorage/sessionStorage before exit
        try:
            result = window.evaluate_js("""
                (function() {
                    try {
                        var out = { ls: {}, ss: {} };
                        try {
                            var ls = window.localStorage;
                            for (var i = 0; i < ls.length; i++) {
                                var k = ls.key(i);
                                if (k) out.ls[k] = ls.getItem(k);
                            }
                        } catch(e) {}
                        try {
                            var ss = window.sessionStorage;
                            for (var j = 0; j < ss.length; j++) {
                                var sk = ss.key(j);
                                if (sk) out.ss[sk] = ss.getItem(sk);
                            }
                        } catch(e) {}
                        return JSON.stringify(out);
                    } catch(e) { return null; }
                })();
            """)
            if result:
                state = load_window_state()
                state["comfy_storage"] = json.loads(result)
                with open(WINDOW_STATE_FILE, "w") as f:
                    json.dump(state, f)
        except Exception:
            pass

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

    # Enforce pinned packages before starting
    enforce_pinned_packages()

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
