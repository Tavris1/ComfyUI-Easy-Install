#!/bin/bash
# Update Easy-Install helper files (Add-Ons, update scripts, launchers, EZi Desktop)
# Pixaroma Community Edition - macOS and Linux

cd "$(dirname "$0")" || exit 1
INSTALL_DIR="$(pwd -P)"

RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
RESET='\033[0m'

HLPR_NAME="Helper-CEI-NEXT-unix.zip"
URL="https://github.com/Tavris1/ComfyUI-Easy-Install/raw/MAC-Linux/${HLPR_NAME}"

# Runtime paths refreshed from the helper archive. Installer-only files and
# user-editable files such as ComfyUI/user/user.css are intentionally excluded.
UPDATE_PATHS=(
    Add-Ons
    update
    patches
    "ComfyUI/user/default/workflows"
    comfyui_desktop.py
    comfyui_icon.png
    comfyui_nirin_launcher_v6.sh
    run_comfyui_desktop.sh
    run_mac_intel.sh
    run_mac_mps.sh
    run_nvidia_gpu.sh
    Update_All_and_RUN.sh
    Update_Comfy_and_RUN.sh
    Update_Easy-Install.sh
)

fail() {
    echo ""
    echo -e "${RED}$1${RESET}"
    echo -e "${YELLOW}The existing installation was not changed.${RESET}"
    exit 1
}

if [ ! -d "ComfyUI" ] || [ ! -d "python_embeded" ]; then
    fail "Run this script from the ComfyUI-Easy-Install folder."
fi

for cmd in curl unzip; do
    command -v "$cmd" >/dev/null 2>&1 || fail "'$cmd' is required but not installed."
done

# Refuse to update while ComfyUI is running from this folder
comfyui_running_here() {
    local pid cwd
    for pid in $(pgrep -f "ComfyUI/main.py" 2>/dev/null); do
        if [ -d "/proc/$pid" ]; then
            cwd="$(readlink "/proc/$pid/cwd" 2>/dev/null)"
        else
            cwd="$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p')"
        fi
        if [ "$cwd" = "$INSTALL_DIR" ] || ps -p "$pid" -o command= 2>/dev/null | grep -qF "$INSTALL_DIR/ComfyUI/main.py"; then
            return 0
        fi
    done
    return 1
}

if comfyui_running_here; then
    fail "ComfyUI is still running from this folder. Please close it first."
fi

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/ezi-update.XXXXXX")" || fail "Could not create a temporary folder."
NEW_FILES=()
cleanup() {
    local f
    for f in "${NEW_FILES[@]}"; do
        rm -f "$f"
    done
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ARCHIVE="$TMP_DIR/$HLPR_NAME"

echo -e "${GREEN}::::: Updating ${YELLOW}ComfyUI-Easy-Install${GREEN} helper files :::::${RESET}"
echo ""

# Download to .part and rename only after curl reports success
if ! curl -fL --progress-bar --retry 5 --retry-delay 2 -o "$ARCHIVE.part" "$URL"; then
    fail "Failed to download updates."
fi
mv -f "$ARCHIVE.part" "$ARCHIVE"

# Validate the archive before touching the installation
if ! unzip -tqq "$ARCHIVE" >/dev/null 2>&1; then
    fail "The downloaded '$HLPR_NAME' is corrupted. Run the update again."
fi
if unzip -Z1 "$ARCHIVE" | grep -Eq '(^/|(^|/)\.\.(/|$))'; then
    fail "The downloaded '$HLPR_NAME' contains unsafe paths."
fi
if ! unzip -q "$ARCHIVE" -d "$TMP_DIR/staging"; then
    fail "Failed to extract '$HLPR_NAME'."
fi

SRC="$TMP_DIR/staging/ComfyUI-Easy-Install"
if [ ! -f "$SRC/comfyui_desktop.py" ] || [ ! -f "$SRC/Update_Easy-Install.sh" ] || [ ! -d "$SRC/Add-Ons" ]; then
    fail "The downloaded '$HLPR_NAME' is missing required helper files."
fi

NEW_VER="$(sed -n 's/^EZI_VERSION = "\(.*\)"/\1/p' "$SRC/comfyui_desktop.py")"
OLD_VER="$(sed -n 's/^EZI_VERSION = "\(.*\)"/\1/p' comfyui_desktop.py 2>/dev/null)"
echo -e "${GREEN}::::: EZi version: ${YELLOW}${OLD_VER:-unknown}${GREEN} -> ${YELLOW}${NEW_VER:-unknown}${RESET}"

# Phase 1: stage every file next to its destination. Any failure aborts
# before an existing file is replaced.
FILES=()
while IFS= read -r -d '' file; do
    FILES+=("${file#"$SRC"/}")
done < <(cd "$SRC" && for p in "${UPDATE_PATHS[@]}"; do
    [ -e "$p" ] && find "$p" -type f ! -name '*.bat' ! -name '.DS_Store' -print0
done | sed -z "s|^|$SRC/|")

[ ${#FILES[@]} -gt 0 ] || fail "No helper files found in the update."

for rel in "${FILES[@]}"; do
    dest="$INSTALL_DIR/$rel"
    mkdir -p "$(dirname "$dest")" || fail "Cannot create folder for '$rel'."
    cp -p "$SRC/$rel" "$dest.ezi-new" || fail "Cannot stage '$rel'."
    NEW_FILES+=("$dest.ezi-new")
done

# Phase 2: rename staged files into place. mv replaces the inode, so this
# script can safely replace itself while running.
for rel in "${FILES[@]}"; do
    dest="$INSTALL_DIR/$rel"
    if ! mv -f "$dest.ezi-new" "$dest"; then
        echo -e "${RED}Failed to replace '$rel'. Run the update again.${RESET}"
        exit 1
    fi
done
NEW_FILES=()

find "$INSTALL_DIR/Add-Ons" "$INSTALL_DIR/update" -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null
chmod +x "$INSTALL_DIR"/*.sh 2>/dev/null

echo ""
echo -e "${GREEN}::::: Updated ${YELLOW}${#FILES[@]}${GREEN} helper files :::::${RESET}"
