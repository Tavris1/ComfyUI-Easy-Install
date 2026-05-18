#!/usr/bin/env python3
"""
ComfyUI Desktop — PyWebView wrapper
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

    # ComfyUI git rev
    comfy_dir = os.path.join(SCRIPT_DIR, "ComfyUI")
    try:
        r = subprocess.run(
            ["git", "rev-parse", "--short", "HEAD"],
            cwd=comfy_dir, capture_output=True, text=True, timeout=5,
        )
        info["comfyui_rev"] = r.stdout.strip() if r.returncode == 0 else "unknown"
    except Exception:
        info["comfyui_rev"] = "unknown"

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

    /* Performance: GPU compositing hint on canvas */
    var style = document.createElement('style');
    style.textContent = [
        'canvas { will-change: transform; }',
        '* { scroll-behavior: auto !important; }',
        '#_comfy_toast{position:fixed;top:16px;right:16px;background:#333;color:#e0e0e0;padding:10px 18px;',
        'border-radius:8px;font-size:13px;z-index:99999;opacity:0;transition:opacity .3s;pointer-events:none}',
        '#_comfy_toast.show{opacity:1}',
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
                            'with title "ComfyUI Desktop" '
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
                        "ComfyUI Desktop",
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
        print(f"Launching ComfyUI Desktop → {COMFYUI_URL}")
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
