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
    api._window = None  # will be set after window creation

    # Show window IMMEDIATELY with loading splash — no waiting
    window = webview.create_window(
        WINDOW_TITLE,
        html=LOADING_HTML,
        width=WINDOW_WIDTH,
        height=WINDOW_HEIGHT,
        resizable=True,
        zoomable=True,
        min_size=(800, 600),
        js_api=api,
    )

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

    def on_closed():
        """When the window is closed, signal the parent process (local mode only)."""
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

    api._window = window  # now safe for Api methods to use

    window.events.loaded += on_loaded
    window.events.closed += on_closed

    print(f"  Tip: Press Cmd+B (macOS) or Ctrl+B (Linux) to open in browser for file uploads")

    # Start pywebview — private_mode=False may fix file upload dialogs on macOS
    webview.start(icon=icon, private_mode=False, debug=False)


def main():
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
