---
name: port-windows-to-mac-linux
description: Check the latest Windows branch commit of ComfyUI-Easy-Install and port any applicable changes to the MAC-Linux branch.
argument-hint: "[optional: specific commit or Windows branch name]"
allowed-tools:
  - read
  - grep
  - exec
  - edit
triggers:
  - user
  - model
---

Port the latest changes from the Windows branch of this repo to the MAC-Linux branch.

Default Windows branch: `Windows`
Default MAC-Linux branch: `MAC-Linux`
Tracked source files on MAC-Linux:
- `ComfyUI-Easy-Install.sh` (main installer)
- `comfyui_desktop.py` (EZi Desktop app)
- `Helper-CEI-NEXT-unix.zip` (binary helper bundle)

Ignored/extracted output directory: `ComfyUI-Easy-Install/` — do **not** edit files here; they are produced by the installer and are not tracked.

## Steps

1. **Fetch the Windows branch**
   - Run `git fetch origin Windows` (or the branch name the user provided).
   - Identify the latest Windows commit: `git log --oneline -1 FETCH_HEAD`.
   - Show the commit diff: `git show --stat <commit>` and `git show <commit> -- ComfyUI-Easy-Install.bat`.

2. **Inspect the current MAC-Linux state**
   - Confirm you are on the `MAC-Linux` branch.
   - Read `ComfyUI-Easy-Install.sh` and the top of `comfyui_desktop.py` to see which Windows changes already exist.

3. **Map Windows changes to MAC-Linux and apply**

   | Windows source | MAC-Linux equivalent | Action |
   |---|---|---|
   | `ComfyUI-Easy-Install.bat` installer logic | `ComfyUI-Easy-Install.sh` | Port logic line-by-line where a shell equivalent exists. |
   | Version in `ComfyUI-Easy-Install.bat` title | Line 3 of `ComfyUI-Easy-Install.sh` | Bump to match. |
   | `set "GCM_INTERACTIVE=never"` | Near existing `GIT_TERMINAL_PROMPT=0` / `GIT_ASKPASS=echo` exports | Add `export GCM_INTERACTIVE=never`. |
   | Re-enabled custom nodes (e.g., `ComfyUI-FishAudioS2`) | Matching `get_node` lines in `ComfyUI-Easy-Install.sh` | Uncomment if currently commented out. |
   | `uv pip uninstall av -y` → `--quiet` | The `uv pip uninstall av` line | Add `--quiet`. |
   | Remove duplicate `av` block | Check `ComfyUI-Easy-Install.sh` | Only remove if an exact duplicate exists. |
   | `git ls-remote` reachability check + `credential.interactive=never` on node clones | `get_node()` function | Add preflight check and `-c credential.interactive=never` to clone. |
   | EZi Desktop version strings inside `Helper-CEI.zip` (`ComfyUI-EZi.py`, `ComfyUI-EZi-Launcher.py`) | `comfyui_desktop.py` (`EZI_VERSION`) | Bump `EZI_VERSION` to match. |
   | `Helper-CEI.zip` update scripts (`Update ComfyUI and Nodes.bat`, `AutoRun.bat`) | Files inside `Helper-CEI-NEXT-unix.zip` | See binary handling below; do not edit the ignored `ComfyUI-Easy-Install/` directory directly. |

4. **Handle `Helper-CEI.zip` binary changes**

   The Windows branch bundles add-ons, launchers, and assets inside `Helper-CEI.zip`. The MAC-Linux branch uses `Helper-CEI-NEXT-unix.zip`. Git cannot diff binary blobs, so inspect them manually.

   1. Detect: `git show --stat <windows_commit>` will show if `Helper-CEI.zip` was modified.
   2. Download both versions to a temp directory:
      ```bash
      mkdir -p /tmp/cei-zip-compare
      curl -L -o /tmp/cei-zip-compare/helper-win-new.zip https://github.com/Tavris1/ComfyUI-Easy-Install/raw/Windows/Helper-CEI.zip
      curl -L -o /tmp/cei-zip-compare/helper-win-old.zip https://github.com/Tavris1/ComfyUI-Easy-Install/raw/<parent_commit>/Helper-CEI.zip
      ```
   3. Extract and compare:
      ```bash
      cd /tmp/cei-zip-compare
      rm -rf helper-win-new helper-win-old
      mkdir helper-win-new helper-win-old
      unzip -q helper-win-new.zip -d helper-win-new
      unzip -q helper-win-old.zip -d helper-win-old
      diff -rq helper-win-old helper-win-new
      ```
   4. For each changed file, determine if a MAC-Linux equivalent exists:
      - **Windows-only files** (`.bat`, `.exe`, registry/tools) → report and skip.
      - **EZi Desktop Python files** (`ComfyUI-EZi.py`, `ComfyUI-EZi-Launcher.py`) → check `comfyui_desktop.py` version string and bump if needed.
      - **Update scripts inside the zip** (`Update ComfyUI and Nodes.bat` → `Update_All_and_RUN.sh`, `Update_Comfy_and_RUN.sh`, `update/update_comfyui.sh`) → they live inside `Helper-CEI-NEXT-unix.zip`; do not edit the ignored `ComfyUI-Easy-Install/` directory. Report that the zip must be rebuilt to include these changes.
      - **Shared assets** (icons, workflow JSONs, patches) → port only if byte-for-byte safe and the zip can be rebuilt.
   5. **Do not commit a half-rebuilt binary.** Only update `Helper-CEI-NEXT-unix.zip` if you can fully reproduce its contents with correct compression and no accidental deletions. When in doubt, report the finding and leave the binary untouched.

5. **Apply only the applicable changes**
   - Prefer minimal, surgical edits.
   - Do not blindly copy Windows-only behavior (`.bat` syntax, Windows registry checks, `python_embeded\python.exe` paths) unless there is a direct shell equivalent.
   - Do not edit files inside the ignored `ComfyUI-Easy-Install/` output directory; those are not tracked.

6. **Verify**
   - `bash -n ComfyUI-Easy-Install.sh`
   - `python3 -m py_compile comfyui_desktop.py`
   - `git diff --stat` and review the diff for correctness.

7. **Commit**
   - Stage only tracked source files (`ComfyUI-Easy-Install.sh`, `comfyui_desktop.py`, etc.).
   - Do not stage `Helper-CEI-NEXT-unix.zip` unless you intentionally rebuilt it and the user approved.
   - Write a concise commit message summarizing the ported changes.
   - Do not push unless the user explicitly asks.

## Output

Report:
- The latest Windows commit hash and message.
- Which Windows `.bat` / tracked-script changes were applied to MAC-Linux and why.
- Which files inside `Helper-CEI.zip` changed and whether they have a MAC-Linux equivalent.
- Which changes were skipped and why (Windows-only, requires zip rebuild, etc.).
- Verification results (`bash -n`, `py_compile`, `git diff --stat`).
- The commit hash after committing.
