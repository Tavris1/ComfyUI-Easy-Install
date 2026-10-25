#!/usr/bin/env python3
"""
ComfyUI EZi Launcher v3.25.1 — macOS/Linux port of the Windows launcher UI.
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
import re
import time
import tempfile
from pathlib import Path

EZI_VERSION = "3.25.1"

# ---------------------------------------------------------------------------
# Paths and constants
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
ICON_PATH = SCRIPT_DIR / "comfyui_icon.png"
WINDOW_STATE_FILE = SCRIPT_DIR / ".comfyui_ezi_launcher_state.json"
KEEP_CACHE_FLAG = SCRIPT_DIR / "Add-Ons" / "Tools" / "Helper-CEI" / "keep_cache.flag"

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
# Launcher themes (ported from upstream ComfyUI-EZi-Launcher.py v3.24.0)
# ---------------------------------------------------------------------------
LAUNCHER_THEMES = {
    'dark': {
        'bg': '#0c0e12', 'bar-bg': '#161b22', 'border': '#21262d', 'border2': '#30363d', 'border3': '#484f58',
        'btn-bg': '#21262d', 'btn-bg2': '#2d333b', 'input-bg': '#0d1117', 'modal-bg': '#161b22',
        'hover-row': '#1c2128', 'text': '#cccccc', 'text2': '#8b949e', 'text3': '#e6edf3',
        'accent': '#388bfd', 'accent-hover': '#58a6ff', 'accent-bg': '#0d419d', 'accent-bg-hover': '#1158c7',
    },
    'pixaroma': {
        'bg': '#111111', 'bar-bg': '#1a1a1a', 'border': '#252525', 'border2': '#2e2e2e', 'border3': '#444444',
        'btn-bg': '#222222', 'btn-bg2': '#2a2a2a', 'input-bg': '#0d0d0d', 'modal-bg': '#1a1a1a',
        'hover-row': '#1f1f1f', 'text': '#cccccc', 'text2': '#888888', 'text3': '#e0e0e0',
        'accent': '#e8530a', 'accent-hover': '#ff7040', 'accent-bg': '#6e2200', 'accent-bg-hover': '#8a3000',
    },
    'aurora': {
        'bg': '#0b1926', 'bar-bg': '#102638', 'border': '#304659', 'border2': '#3b566f', 'border3': '#49758a',
        'btn-bg': '#22374b', 'btn-bg2': '#304b63', 'input-bg': '#09232d', 'modal-bg': '#122438',
        'hover-row': '#203649', 'text': '#edf3ff', 'text2': '#a1b3cc', 'text3': '#edf3ff',
        'accent': '#82dfcd', 'accent-hover': '#9be9d9', 'accent-bg': '#224c56', 'accent-bg-hover': '#2b616c',
    },
    'light': {
        'bg': '#f0f2f5', 'bar-bg': '#dde1e7', 'border': '#c8cdd5', 'border2': '#b0b7c0', 'border3': '#8a9199',
        'btn-bg': '#e2e6eb', 'btn-bg2': '#d0d5dc', 'input-bg': '#ffffff', 'modal-bg': '#ffffff',
        'hover-row': '#d8dce3', 'text': '#24292f', 'text2': '#57606a', 'text3': '#1c2026',
        'accent': '#0969da', 'accent-hover': '#0550ae', 'accent-bg': '#0969da', 'accent-bg-hover': '#0550ae',
    },
}

def _rgb(h):
    return tuple(int(h[i:i+2], 16) for i in (1, 3, 5))

def _gamma_lum(h):
    def lin(c): return c/12.92 if c <= 0.04045 else ((c+0.055)/1.055)**2.4
    r, g, b = [lin(c/255) for c in _rgb(h)]
    return 0.2126*r + 0.7152*g + 0.0722*b

def _blend(a, b, t):
    ra, rb = _rgb(a), _rgb(b)
    return '#%02x%02x%02x' % tuple(int(x*(1-t) + y*t) for x, y in zip(ra, rb))

def _hex_ok(value):
    v = str(value).strip()
    if re.fullmatch(r'#[0-9a-fA-F]{6}', v):
        return v.lower()
    m = re.fullmatch(r'#([0-9a-fA-F]{3})', v)
    if m:
        return '#' + ''.join(c*2 for c in m.group(1)).lower()
    return None

def _builtin_palette(pid):
    """Read a builtin ComfyUI palette from the installed frontend package."""
    import glob as _glob
    for cand in _glob.glob(str(SCRIPT_DIR / 'python_embeded' / '**' / 'site-packages'), recursive=True):
        for pkg in _glob.glob(os.path.join(cand, 'comfyui_frontend_package*')):
            if 'dist-info' in pkg or not os.path.isdir(pkg):
                continue
            pdir = os.path.join(pkg, 'static', 'assets', 'palettes')
            if not os.path.isdir(pdir):
                continue
            for fn in os.listdir(pdir):
                if not fn.endswith('.json'):
                    continue
                try:
                    with open(os.path.join(pdir, fn), encoding='utf-8', errors='replace') as f:
                        d = json.load(f)
                except (OSError, ValueError):
                    continue
                if d.get('id') == pid and d.get('colors'):
                    return d['colors']
    return {}

def _comfy_theme_vars():
    """Derive launcher theme vars from ComfyUI's active palette."""
    try:
        path = SCRIPT_DIR / 'ComfyUI' / 'user' / 'comfy.settings.json'
        if not path.is_file():
            path = SCRIPT_DIR / 'ComfyUI' / 'user' / 'default' / 'comfy.settings.json'
        with open(path, encoding='utf-8', errors='replace') as f:
            data = json.load(f)
        pid = data.get('Comfy.ColorPalette', '') or 'dark'
        custom = data.get('Comfy.CustomColorPalettes', {})
        colors = custom[pid].get('colors', {}) if isinstance(custom, dict) and pid in custom else _builtin_palette(pid)
        cb, lg = colors.get('comfy_base', {}), colors.get('litegraph_base', {})
        def c(k, fb=''): return _hex_ok(cb.get(k, '')) or fb
        def l(k, fb=''): return _hex_ok(lg.get(k, '')) or fb
        bg = c('bg-color', '#202020')
        menu_bg = c('comfy-menu-bg', bg)
        input_bg = c('comfy-input-bg', bg)
        fg = c('fg-color', '#cccccc')
        border = c('border-color', '#444444')
        lg_bg = l('CLEAR_BACKGROUND_COLOR', bg)
        node_bg = l('NODE_DEFAULT_BGCOLOR', menu_bg)
        node_title = l('NODE_TITLE_COLOR', fg)
        accent = l('NODE_BOX_OUTLINE_COLOR', c('border-color', '#388bfd'))
        lum = _gamma_lum(accent)
        if lum > 0.80 or lum < 0.05:
            link = l('LINK_COLOR', '')
            if link and 0.05 <= _gamma_lum(link) <= 0.80:
                accent, lum = link, _gamma_lum(link)
        target = '#000000' if lum >= 0.18 else '#ffffff'
        return pid, {
            'bg': lg_bg, 'bar-bg': menu_bg, 'border': border, 'border2': border, 'border3': border,
            'btn-bg': node_bg, 'btn-bg2': node_bg, 'input-bg': input_bg, 'modal-bg': menu_bg,
            'hover-row': lg_bg, 'text': fg, 'text2': node_title, 'text3': fg,
            'accent': accent, 'accent-hover': _blend(accent, '#ffffff', .30),
            'accent-bg': _blend(accent, target, .60), 'accent-bg-hover': _blend(accent, target, .45),
        }
    except (OSError, ValueError, AttributeError, KeyError, TypeError):
        return '', {}

def _persist_comfy_theme_vars():
    """Persist derived theme vars to the launcher state when the ComfyUI theme is active."""
    pid, vars_ = _comfy_theme_vars()
    if not vars_:
        return
    try:
        state = load_state()
        if state.get("launcher_theme") == "comfyui" and state.get("comfy_theme_vars") != vars_:
            state["comfy_theme_vars"] = vars_
            save_state(state)
    except Exception:
        pass

def launcher_theme_css(theme_name):
    """Return (resolved_name, {css-var: value}) for the launcher UI."""
    comfy_pid = ''
    if theme_name == 'comfyui':
        comfy_pid, v = _comfy_theme_vars()
        if not v:
            theme_name = 'aurora'
            v = dict(LAUNCHER_THEMES['aurora'])
    else:
        v = dict(LAUNCHER_THEMES.get(theme_name, LAUNCHER_THEMES['aurora']))
        theme_name = theme_name if theme_name in LAUNCHER_THEMES else 'aurora'
    acc = v['accent']
    on_acc = _blend(acc, '#000000', .85) if _gamma_lum(acc) >= 0.35 else '#ffffff'
    css = {
        '--bg': v['bg'], '--bg-light': v['bar-bg'], '--bg-lighter': v['btn-bg2'],
        '--panel': v['bar-bg'], '--modal': v['modal-bg'], '--row': v['hover-row'],
        '--accent': acc, '--accent-hover': v['accent-hover'], '--ready': acc,
        '--on-accent': on_acc,
        '--text': v['text3'], '--text-muted': v['text2'],
        '--border': v['border'], '--border2': v['border2'],
        '--g1': _blend(v['bg'], acc, .18), '--g2': _blend(v['bg'], v['border3'], .45),
    }
    return theme_name, comfy_pid, css

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
# Snapshots — ported from Windows launcher v3.25.0 (ComfyUI-Manager cm-cli)
# ---------------------------------------------------------------------------
SNAP_NAME_RE = re.compile(r"^(\d{4}-\d{2}-\d{2})_(\d{2}-\d{2}-\d{2})_(.+)$")
SNAP_MENU_MAX = 15

CM_USER_DIR = SCRIPT_DIR / "ComfyUI" / "user"
CM_CLI_PATH = SCRIPT_DIR / "ComfyUI" / "custom_nodes" / "ComfyUI-Manager" / "cm-cli.py"
SNAPSHOTS_DIR = CM_USER_DIR / "__manager" / "snapshots"


def _find_cm_cli():
    return str(CM_CLI_PATH) if CM_CLI_PATH.is_file() else None


def _list_snapshots():
    found = []
    try:
        for name in os.listdir(SNAPSHOTS_DIR):
            full = SNAPSHOTS_DIR / name
            if name.lower().endswith(".json") and full.is_file():
                found.append((full.stat().st_mtime, str(full)))
    except OSError:
        return []
    found.sort(reverse=True)
    return [p for _, p in found]


def _snapshot_title(path):
    stem = os.path.splitext(os.path.basename(path))[0]
    m = SNAP_NAME_RE.match(stem)
    if m:
        return m.group(1) + " " + m.group(2).replace("-", ":"), m.group(3)
    try:
        stamp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.path.getmtime(path)))
    except OSError:
        stamp = ""
    return stamp, stem


def _snapshot_age(path, now=None):
    match = SNAP_NAME_RE.match(os.path.splitext(os.path.basename(path))[0])
    try:
        stamp = time.mktime(time.strptime(match.group(1) + " " + match.group(2), "%Y-%m-%d %H-%M-%S")) if match else os.path.getmtime(path)
    except (OSError, ValueError, OverflowError):
        try:
            stamp = os.path.getmtime(path)
        except OSError:
            return ""
    seconds = max(0, int((time.time() if now is None else now) - stamp))
    for duration, unit in [(31536000, "year"), (2592000, "month"), (604800, "week"),
                           (86400, "day"), (3600, "hour"), (60, "min")]:
        count = seconds // duration
        if count:
            return str(count) + " " + unit + ("s" if count != 1 and unit != "min" else "") + " ago"
    return "just now"


def _snapshot_torch(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            pips = json.load(f).get("pips", {})
        for key in pips:
            if str(key).lower().startswith("torch=="):
                return str(key).split("==", 1)[1]
    except (OSError, ValueError, AttributeError, TypeError):
        pass
    return None


def _installed_torch():
    import glob
    for cand in glob.glob(str(SCRIPT_DIR / "python_embeded" / "lib" / "python3*" / "site-packages")):
        try:
            for name in os.listdir(cand):
                m = re.match(r"(?i)^torch-(.+)\.dist-info$", name)
                if m:
                    return m.group(1)
        except OSError:
            pass
    return None


def _snap_note():
    if not _find_cm_cli():
        return "Manager (cm-cli) not found"
    count = len(_list_snapshots())
    if not count:
        return "No snapshots yet"
    return str(count) + (" snapshot" if count == 1 else " snapshots")


def _stamped(tag):
    SNAPSHOTS_DIR.mkdir(parents=True, exist_ok=True)
    return str(SNAPSHOTS_DIR / (time.strftime("%Y-%m-%d_%H-%M-%S") + "_" + tag + ".json"))


def _snap_env():
    env = os.environ.copy()
    env["COMFYUI_PATH"] = str(SCRIPT_DIR / "ComfyUI")
    env["PYTHONIOENCODING"] = "utf-8"
    return env


def _run_snap(cmd):
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, cwd=str(SCRIPT_DIR), env=_snap_env(), timeout=3600)
    except subprocess.TimeoutExpired:
        return 1, "Timed out: " + " ".join(cmd)
    return r.returncode, ((r.stdout or "") + (r.stderr or "")).strip()


def _restore_script_path():
    script = os.path.join(tempfile.gettempdir(), "ezi_snapshot_restore.py")
    with open(script, "w", encoding="utf-8", newline="\n") as f:
        f.write(SNAP_RESTORE_SCRIPT)
    return script


SNAP_RESTORE_SCRIPT = r'''import json
import os
import re
import subprocess
import sys
from importlib import metadata

PROTECTED = {'torch', 'torchvision', 'torchaudio', 'triton', 'triton-windows', 'pip', 'setuptools', 'wheel'}


def git(repo, *args):
    try:
        done = subprocess.run(['git', '-C', repo] + list(args), capture_output=True, text=True,
                              encoding='utf-8', errors='replace')
    except OSError as error:
        return 1, '', str(error)
    return done.returncode, done.stdout.strip(), done.stderr.strip()


def head_of(repo):
    code, out, _ = git(repo, 'rev-parse', 'HEAD')
    return out if code == 0 else None


def same_commit(a, b):
    return bool(a) and bool(b) and (a.startswith(b) or b.startswith(a))


def switch_commit(repo, target):
    code, _, err = git(repo, 'checkout', target)
    if code == 0:
        return True, ''
    for fetch in (['--unshallow', '--tags', 'origin'], ['--tags', 'origin'],
                  ['origin', '+refs/heads/master:refs/remotes/origin/master']):
        if git(repo, 'fetch', *fetch)[0] == 0:
            code, _, err = git(repo, 'checkout', target)
            if code == 0:
                return True, ''
    return False, '\n'.join(err.splitlines()[-6:])


def restore_core(snapshot, comfy_dir):
    target = snapshot.get('comfyui')
    if not target or not re.fullmatch(r'[0-9a-f]{7,40}', str(target)):
        print('ComfyUI: no commit in the snapshot, left unchanged')
        return 0
    head = head_of(comfy_dir)
    if same_commit(head, target):
        print('ComfyUI: already at ' + target[:7])
        return 0
    if not os.path.isdir(os.path.join(comfy_dir, '.git')):
        print('ComfyUI: .git folder not found, the commit cannot be restored')
        return 1
    print('ComfyUI: ' + str(head)[:7] + ' -> ' + target[:7])
    ok, detail = switch_commit(comfy_dir, target)
    if not ok:
        print('ComfyUI: git checkout failed')
        if detail:
            print(detail)
        return 1
    print('ComfyUI: now at ' + str(head_of(comfy_dir))[:7])
    return 0


def norm_url(url):
    url = re.sub(r'^[a-z+]+://', '', url.strip().lower())
    url = re.sub(r'^[^@/]*@', '', url)
    url = url.replace(':', '/', 1)
    url = re.sub(r'^www\.', '', url)
    return re.sub(r'(\.git)?/*$', '', url)


def origin_url(repo):
    try:
        with open(os.path.join(repo, '.git', 'config'), 'r', encoding='utf-8', errors='ignore') as f:
            text = f.read()
    except OSError:
        return None
    match = re.search(r'\[remote "origin"\][^\[]*?url\s*=\s*(\S+)', text)
    return match.group(1) if match else None


def local_repos(nodes_dir):
    found = []
    for folder, off in ((nodes_dir, False), (os.path.join(nodes_dir, '.disabled'), True)):
        try:
            names = sorted(os.listdir(folder))
        except OSError:
            continue
        for name in names:
            path = os.path.join(folder, name)
            if name != '.disabled' and os.path.isdir(os.path.join(path, '.git')):
                found.append((path, off or name.endswith('.disabled')))
    return found


def restore_nodes(snapshot, nodes_dir):
    wanted_nodes = snapshot.get('git_custom_nodes') or {}
    local = {}
    for path, off in local_repos(nodes_dir):
        url = origin_url(path)
        if url:
            local.setdefault(norm_url(url), []).append((path, off))
    ok, fixed, problems = 0, [], []
    for url, info in wanted_nodes.items():
        if 'comfyui-manager' in url.lower():
            continue
        target = info.get('hash')
        wanted_off = bool(info.get('disabled'))
        name = re.sub(r'\.git$', '', url.rstrip('/').split('/')[-1])
        entries = local.get(norm_url(url), [])
        if not entries:
            if wanted_off:
                continue
            code, _, err = git(nodes_dir, 'clone', url, name)
            if code != 0:
                problems.append(name + ': missing, clone failed: ' + (err.splitlines() or [''])[-1])
                continue
            path = os.path.join(nodes_dir, name)
            done, detail = switch_commit(path, target)
            if done:
                fixed.append(name + ': cloned at ' + str(target)[:7])
            else:
                problems.append(name + ': cloned, checkout failed: ' + (detail.splitlines() or [''])[-1])
            continue
        entries.sort(key=lambda e: e[1] != wanted_off)
        path, off = entries[0]
        good = True
        if target and not same_commit(head_of(path), target):
            before = str(head_of(path))[:7]
            done, detail = switch_commit(path, target)
            if done:
                fixed.append(name + ': ' + before + ' -> ' + target[:7])
            else:
                problems.append(name + ': checkout of ' + target[:7] + ' failed: ' + (detail.splitlines() or [''])[-1])
                good = False
        if off != wanted_off:
            problems.append(name + ': is ' + ('disabled' if off else 'enabled') +
                            ', snapshot has it ' + ('disabled' if wanted_off else 'enabled'))
            good = False
        if good and not any(f.startswith(name + ':') for f in fixed):
            ok += 1
    print('Custom nodes: ' + str(ok) + ' ok, ' + str(len(fixed)) + ' fixed, ' + str(len(problems)) + ' problems')
    for line in fixed:
        print('  fixed ' + line)
    for line in problems:
        print('  PROBLEM ' + line)
    return 1 if problems else 0


def norm(name):
    return re.sub(r'[-_.]+', '-', name).lower()


def same(a, b):
    for module in ('packaging.version', 'pip._vendor.packaging.version'):
        try:
            version = __import__(module, fromlist=['Version']).Version
            return version(a) == version(b)
        except Exception:
            continue
    return a.lower() == b.lower()


def installed():
    found = {}
    for dist in metadata.distributions():
        name = dist.metadata['Name']
        if name:
            found[norm(name)] = dist.version
    return found


def build_plan(pips, current):
    todo, skipped, absent, unchanged, direct = [], [], [], 0, 0
    for key, value in pips.items():
        name = norm(key.split('==')[0])
        have = current.get(name)
        if value:
            direct += 1
            if have is None:
                absent.append(name)
            continue
        if '==' not in key:
            continue
        wanted = key.split('==', 1)[1]
        if have is not None and same(have, wanted):
            unchanged += 1
        elif name in PROTECTED:
            skipped.append((name, have, wanted))
        else:
            todo.append((name, key, have))
    return todo, skipped, absent, unchanged, direct


def run_pip(specs):
    command = [sys.executable, '-m', 'pip', 'install', '--no-deps', '--no-input',
               '--disable-pip-version-check'] + specs
    return subprocess.call(command) == 0


def restore_pips(pips):
    current = installed()
    todo, skipped, absent, unchanged, direct = build_plan(pips, current)
    names = {norm(k.split('==')[0]) for k in pips}
    extras = sorted(n for n in current if n not in names)
    print('Python packages: ' + str(len(todo)) + ' to change, ' + str(unchanged) + ' unchanged, ' +
          str(direct) + ' direct references left as they are')
    for name, spec, have in todo:
        print('  ' + name + ' (' + (have or 'not installed') + ') -> ' + spec)
    for name, have, wanted in skipped:
        print('  skipped ' + name + ': installed ' + str(have) + ', snapshot ' + str(wanted))
    for name in absent:
        print('  not installed: ' + name + ' (direct reference, reinstall it from Add-ons)')
    failed = []
    specs = [spec for _, spec, _ in todo]
    if specs and not run_pip(specs):
        print('Batch install failed, retrying one by one')
        for name, spec, _ in todo:
            if not run_pip([spec]):
                failed.append(name)
    print('')
    print('Changed: ' + str(len(todo) - len(failed)) + ' | failed: ' + str(len(failed)) +
          ' | skipped: ' + str(len(skipped)) + ' | direct references not installed: ' + str(len(absent)))
    if extras:
        print(str(len(extras)) + ' installed packages are not in the snapshot and were left in place: ' +
              ', '.join(extras[:15]) + (' ...' if len(extras) > 15 else ''))
    if failed:
        print('Failed: ' + ', '.join(failed))
    return 1 if failed else 0


PRE_RESTORE = r'^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}_pre-restore\.json$'
PRE_UPDATE = r'^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}_pre-update-.+\.json$'
KEEP_PRE_RESTORE = 5
KEEP_PRE_UPDATE = 10


def load(path):
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except (OSError, ValueError):
        return None


def snapshot_files(folder):
    found = []
    try:
        names = os.listdir(folder)
    except OSError:
        return []
    for name in names:
        path = os.path.join(folder, name)
        if name.lower().endswith('.json') and os.path.isfile(path):
            found.append((os.path.getmtime(path), path))
    found.sort(reverse=True)
    return [path for _, path in found]


def prune(folder, pattern, keep, protected):
    own = [p for p in snapshot_files(folder) if re.match(pattern, os.path.basename(p))]
    removed = 0
    for path in own[keep:]:
        if path in protected:
            continue
        try:
            os.remove(path)
            removed += 1
        except OSError:
            pass
    return removed


def tidy_restore(target_path, backup_path):
    target = load(target_path)
    if target is not None and target == load(backup_path):
        try:
            os.remove(backup_path)
            print('Backup removed: the restore changed nothing')
        except OSError:
            pass
    else:
        print('Backup kept as an undo point: ' + os.path.basename(backup_path))
    removed = prune(os.path.dirname(backup_path), PRE_RESTORE, KEEP_PRE_RESTORE, {target_path})
    if removed:
        print('Removed ' + str(removed) + ' old restore backup(s)')
    return 0


def tidy_update(new_path):
    state = load(new_path)
    if state is None:
        print('Snapshot file is unreadable: ' + os.path.basename(new_path))
        return 0
    folder = os.path.dirname(new_path)
    others = [p for p in snapshot_files(folder) if p != new_path]
    if others and load(others[0]) == state:
        try:
            os.remove(new_path)
            print('No new snapshot needed: the state is identical to ' + os.path.basename(others[0]))
        except OSError:
            pass
    else:
        print('Snapshot saved: ' + os.path.basename(new_path))
    prune(folder, PRE_UPDATE, KEEP_PRE_UPDATE, set())
    return 0


def snap_update(out_path, cm_cli, user_dir, comfy_dir):
    env = dict(os.environ, COMFYUI_PATH=comfy_dir, PYTHONIOENCODING='utf-8')
    code = subprocess.call([sys.executable, cm_cli, 'save-snapshot', '--output', out_path,
                            '--user-directory', user_dir], env=env)
    if code != 0 or not os.path.isfile(out_path):
        print('Snapshot failed, continuing with the update')
        return 0
    return tidy_update(out_path)


def run_manager_restore(snapshot_path, cm_cli, user_dir):
    env = dict(os.environ, PYTHONUNBUFFERED='1', PYTHONIOENCODING='utf-8')
    command = [sys.executable, cm_cli, 'restore-snapshot', snapshot_path, '--user-directory', user_dir]
    failed_prefix = '[  FAILED   ] '
    held = []
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
                               encoding='utf-8', errors='replace', env=env)
    for line in process.stdout:
        text = line.rstrip('\r\n')
        if text.startswith(failed_prefix):
            held.append(text[len(failed_prefix):])
        elif text != 'Installation failed for pip packages: []':
            print(text, flush=True)
    return process.wait(), held


def apply_snapshot(snapshot, snapshot_path, nodes_dir, cm_cli, user_dir):
    code, held = run_manager_restore(snapshot_path, cm_cli, user_dir)
    if code != 0:
        for name in held:
            print('[  FAILED   ] ' + name)
        print('ComfyUI-Manager restore failed, exit code ' + str(code))
        return code
    problems = restore_nodes(snapshot, nodes_dir)
    if held and problems:
        print('ComfyUI-Manager reported FAILED: ' + ', '.join(held))
    elif held:
        print('ComfyUI-Manager listed ' + str(len(held)) + ' node(s) as FAILED, the disk check found no problems')
    return restore_pips(snapshot.get('pips') or {}) or problems


def main():
    mode, first = sys.argv[1], sys.argv[2]
    args = sys.argv[3:]
    if mode == 'info':
        print('Restoring snapshot: ' + os.path.basename(first))
        print('')
        return 0
    if mode == 'tidy-restore':
        return tidy_restore(first, args[0])
    if mode == 'tidy-update':
        return tidy_update(first)
    if mode == 'snap-update':
        return snap_update(first, args[0], args[1], args[2])
    snapshot = load(first)
    if snapshot is None:
        print('Cannot read the snapshot: ' + first)
        return 1
    if mode == 'core':
        return restore_core(snapshot, args[0])
    if mode == 'apply':
        return apply_snapshot(snapshot, first, args[0], args[1], args[2])
    print('Unknown mode: ' + mode)
    return 1


if __name__ == '__main__':
    sys.exit(main())
'''


def snapshot_save():
    cm = _find_cm_cli()
    if not cm:
        return {"ok": False, "error": "ComfyUI-Manager cm-cli not found — install ComfyUI-Manager first."}
    out = _stamped("manual")
    code, text = _run_snap([PYTHON_EXEC, cm, "save-snapshot", "--output", out, "--user-directory", str(CM_USER_DIR)])
    if code != 0:
        return {"ok": False, "error": text or "save-snapshot failed"}
    return {"ok": True, "output": text or ("Saved " + os.path.basename(out))}


def snapshot_restore(path):
    cm = _find_cm_cli()
    if not cm:
        return {"ok": False, "error": "ComfyUI-Manager cm-cli not found."}
    script = _restore_script_path()
    backup = _stamped("pre-restore")
    steps = [
        [PYTHON_EXEC, script, "info", path],
        [PYTHON_EXEC, cm, "save-snapshot", "--output", backup, "--user-directory", str(CM_USER_DIR)],
        [PYTHON_EXEC, script, "core", path, str(SCRIPT_DIR / "ComfyUI")],
        [PYTHON_EXEC, script, "apply", path, str(SCRIPT_DIR / "ComfyUI" / "custom_nodes"), cm, str(CM_USER_DIR)],
        [PYTHON_EXEC, script, "tidy-restore", path, backup],
    ]
    log = []
    for cmd in steps:
        code, text = _run_snap(cmd)
        log.append(text or ("exit " + str(code)))
        if code != 0:
            return {"ok": False, "error": "Stopped at: " + cmd[2], "output": "\n".join(log)}
    return {"ok": True, "output": "\n".join(log)}


def _snapshots_state():
    snaps = _list_snapshots() if _find_cm_cli() else []
    return {
        "available": _find_cm_cli() is not None,
        "note": _snap_note(),
        "items": [
            {"path": p, "title": _snapshot_title(p)[0], "tag": _snapshot_title(p)[1],
             "age": _snapshot_age(p), "torch": _snapshot_torch(p)}
            for p in snaps[:SNAP_MENU_MAX]
        ],
    }


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
        theme_name, comfy_pid, theme_css = launcher_theme_css(state.get("launcher_theme", "aurora"))
        if theme_name == "comfyui":
            _persist_comfy_theme_vars()
        return {
            "version": EZI_VERSION,
            "platform": PLATFORM,
            "valid_dir": INSTALL_DIR is not None,
            "mode": mode,
            "theme": theme_name,
            "theme_css": theme_css,
            "comfy_theme": comfy_pid,
            "keep_cache": KEEP_CACHE_FLAG.exists(),
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
                    "builtin": True,
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
            "snapshots": _snapshots_state(),
        }

    def set_mode(self, mode: str):
        state = load_state()
        state["mode"] = mode
        save_state(state)
        return {"ok": True}

    def set_theme(self, theme: str):
        theme_name, comfy_pid, theme_css = launcher_theme_css(theme)
        state = load_state()
        state["launcher_theme"] = theme if theme in LAUNCHER_THEMES or theme == "comfyui" else "aurora"
        save_state(state)
        if theme_name == "comfyui":
            _persist_comfy_theme_vars()
        return {"ok": True, "theme": theme_name, "theme_css": theme_css, "comfy_theme": comfy_pid}

    def set_keep_cache(self, enabled: bool):
        try:
            if enabled:
                KEEP_CACHE_FLAG.parent.mkdir(parents=True, exist_ok=True)
                KEEP_CACHE_FLAG.touch()
            elif KEEP_CACHE_FLAG.exists():
                KEEP_CACHE_FLAG.unlink()
        except OSError:
            pass
        return KEEP_CACHE_FLAG.exists()

    def save_snapshot(self):
        return snapshot_save()

    def restore_snapshot(self, path: str):
        return snapshot_restore(path)

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
  background: linear-gradient(135deg, var(--g1, #151925) 0%, var(--g2, #1e2333) 100%);
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
  background: color-mix(in srgb, var(--panel, #151925) 85%, transparent);
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
.theme-select {
  -webkit-app-region: no-drag;
  background: var(--bg-light);
  color: var(--text-muted);
  border: 1px solid var(--border);
  border-radius: 8px;
  font-size: 12px;
  padding: 4px 8px;
  margin-right: 12px;
  cursor: pointer;
}
.cache-toggle {
  -webkit-app-region: no-drag;
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  color: var(--text-muted);
  margin-right: 12px;
  cursor: pointer;
}
.cache-toggle input { accent-color: var(--accent); cursor: pointer; }
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
  flex: 1.8;
  display: flex;
  gap: 18px;
  min-width: 0;
}
.panel-col {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
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
  color: var(--on-accent, #0f1620);
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
  color: var(--on-accent, #0f1620);
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
.snap-row { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 10px; background: var(--bg); border: 1px solid var(--border); cursor: pointer; transition: 0.2s; font: inherit; color: inherit; }
.snap-row:hover { background: rgba(255,255,255,0.04); border-color: rgba(126,232,211,0.25); }
.snap-row:disabled { opacity: 0.5; cursor: not-allowed; }
.snap-row svg { width: 18px; height: 18px; color: var(--accent); flex-shrink: 0; }
.snap-info { min-width: 0; }
.snap-name { font-size: 13px; font-weight: 600; }
.snap-sub { font-size: 11px; color: var(--muted, #a1b3cc); }
.snap-select { display: block; width: 100%; }
.snap-select option { background: var(--bg); color: var(--text); }
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
    <select class="theme-select" id="theme-select" title="Launcher theme"></select>
    <label class="cache-toggle" title="Keep pip/uv package cache"><input type="checkbox" id="keep-cache" onchange="setKeepCache(this.checked)"> keep cache</label>
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
      <div class="card panel-col">
        <div class="update-header">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.3"/></svg>
          Update
        </div>
        <div class="update-list" id="update-list"></div>
      </div>
      <div class="card panel-col">
        <div class="update-header">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 8a2 2 0 0 0-1-1.73L13 4l-2.5 1.25L7 3l-4 2v14l4 2 2.5-1.25L12 20l4-2a2 2 0 0 0 1-1.73V8z"/></svg>
          Snapshots
        </div>
        <div class="update-list" id="snap-list"></div>
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

const THEME_OPTIONS = [
  {value:'aurora',  label:'EZi Aurora'},
  {value:'dark',    label:'EZi Dark'},
  {value:'pixaroma',label:'Pixaroma'},
  {value:'light',   label:'EZi Light'},
  {value:'comfyui', label:'ComfyUI'},
];

function applyTheme(css) {
  const r = document.documentElement;
  for (const k in css) r.style.setProperty(k, css[k]);
}

async function setTheme(t) {
  const res = await call('set_theme', t);
  if (res && res.ok) { applyTheme(res.theme_css); rebuildThemeSelect(res.theme, res.comfy_theme); }
}

async function setKeepCache(on) {
  const res = await call('set_keep_cache', on);
  const chk = document.getElementById('keep-cache');
  if (chk) chk.checked = !!res;
}

function rebuildThemeSelect(current, comfyPid) {
  const sel = document.getElementById('theme-select');
  sel.innerHTML = THEME_OPTIONS.map(o => {
    let label = o.label;
    if (o.value === 'comfyui') label += comfyPid ? ' (' + comfyPid + ')' : '';
    if (o.value === 'aurora') label += ' (default)';
    const disabled = o.value === 'comfyui' && !comfyPid ? ' disabled' : '';
    return `<option value="${o.value}"${o.value === current ? ' selected' : ''}${disabled}>${label}</option>`;
  }).join('');
}

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
    const isBuiltin = !!item.builtin;
    const canLaunch = isComfyUI || item.status_color === 'ready';
    const showInstall = !isComfyUI && !isBuiltin && item.status_color !== 'ready';
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
          ${showInstall ? `<button class="btn btn-ghost" onclick="doOpenFolder('ComfyUI/custom_nodes')">Install</button>` : ''}
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

const SNAP_MENU_MAX = 15;
const SNAP_ICONS = {
  save: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>',
  restore: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"/></svg>',
  pick: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>',
};

function renderSnapshots() {
  const s = state.snapshots || {available: false, note: '', items: []};
  const list = document.getElementById('snap-list');
  if (!list) return;
  const items = s.items || [];
  const latest = items.find(i => i.tag !== 'pre-restore');
  const off = s.available ? '' : ' disabled';
  list.innerHTML = `
    <button class="snap-row"${off} onclick="doSaveSnapshot()">
      ${SNAP_ICONS.save}
      <div class="snap-info">
        <div class="snap-name">Save snapshot</div>
        <div class="snap-sub">Current state, manual</div>
      </div>
    </button>
    <button class="snap-row"${off} onclick="restoreLatest()">
      ${SNAP_ICONS.restore}
      <div class="snap-info">
        <div class="snap-name">Restore latest</div>
        <div class="snap-sub">${escapeHtml(latest ? latest.title : 'Only backups left')}</div>
      </div>
    </button>
    <select class="snap-row snap-select"${off} onchange="restoreChosen(this.value)">
      <option value="">Restore other · Choose from ${Math.min(items.length, SNAP_MENU_MAX)}</option>
      ${items.map(i => `<option value="${escapeHtml(i.path)}">${escapeHtml(i.title)}</option>`).join('')}
    </select>
    <button class="snap-row" onclick="openSnapshotsFolder()">
      ${ICONS.folder}
      <div class="snap-info">
        <div class="snap-name">Snapshots (${items.length})</div>
        <div class="snap-sub">${escapeHtml(s.available ? 'Open snapshots folder' : s.note)}</div>
      </div>
    </button>
  `;
}

function restoreLatest() {
  const items = (state.snapshots && state.snapshots.items) || [];
  const latest = items.find(i => i.tag !== 'pre-restore');
  if (latest) doRestoreSnapshot(latest.path);
}

function restoreChosen(path) {
  if (path) doRestoreSnapshot(path);
}

async function openSnapshotsFolder() {
  const res = await call('open_folder', 'ComfyUI/user/__manager/snapshots');
  if (res && res.error) showToast(res.error);
}

async function refreshSnapshots() {
  state = await call('get_state');
  renderSnapshots();
}

async function doSaveSnapshot() {
  showToast('Saving snapshot...');
  const res = await call('save_snapshot');
  showToast((res && (res.output || res.error)) || 'Save failed');
  if (res && res.ok) refreshSnapshots();
}

async function doRestoreSnapshot(path) {
  if (!window.confirm('Restore snapshot?\n\nComfyUI is switched to the snapshot commit.\nCustom nodes are restored by ComfyUI-Manager and then verified.\nPython packages are set to the snapshot versions without dependency resolution.\nTorch is not changed.\nClose ComfyUI before continuing.\nThe current state is saved as a backup snapshot first.')) return;
  showToast('Restoring... this can take a few minutes');
  const res = await call('restore_snapshot', path);
  showToast((res && (res.output || res.error)) || 'Restore failed');
  if (res && res.ok) refreshSnapshots();
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
  applyTheme(state.theme_css || {});
  rebuildThemeSelect(state.theme || 'aurora', state.comfy_theme || '');
  document.getElementById('theme-select').addEventListener('change', e => setTheme(e.target.value));
  const cacheChk = document.getElementById('keep-cache');
  if (cacheChk) cacheChk.checked = !!state.keep_cache;
  document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.mode === currentMode));
  document.getElementById('version').textContent = 'v' + state.version;
  document.getElementById('logo').innerHTML = '""" + (('<img src="data:image/png;base64,' + _ICON_B64 + '">') if _ICON_B64 else '🎨') + r"""';
  renderItems();
  renderUpdates();
  renderFolders();
  renderSnapshots();
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
        width=1060,
        height=520,
        resizable=False,
        on_top=False,
        confirm_close=False,
    )

    api.window = window
    webview.start(debug=False, http_server=False)


if __name__ == "__main__":
    main()
