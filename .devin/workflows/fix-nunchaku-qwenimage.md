---
description: Fix ComfyUI-nunchaku ImportError for apply_rotary_emb (NunchakuQwenImageDiTLoader)
---

# Fix: ComfyUI-nunchaku qwenimage.py ImportError

Applies to:
- Error: `ImportError: cannot import name 'apply_rotary_emb' from 'comfy.ldm.qwen_image.model'`
- Node: `NunchakuQwenImageDiTLoader`
- Package: `ComfyUI-nunchaku` v1.2.1

## Steps

1. Navigate to the nunchaku models folder:
   ```
   cd /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/custom_nodes/ComfyUI-nunchaku/models
   ```

2. Rename the old file as a backup:
   ```bash
   mv qwenimage.py qwenimage_backup.py
   ```

3. Download the patched replacement file:
   ```bash
   wget -O qwenimage.py "https://github.com/user-attachments/files/28592676/qwenimage.py"
   ```

4. Restart ComfyUI.

## Reverting

To restore the original file:
```bash
cd /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/custom_nodes/ComfyUI-nunchaku/models
mv qwenimage_backup.py qwenimage.py
```

## Root Cause

ComfyUI removed `apply_rotary_emb` from `comfy.ldm.qwen_image.model` and replaced it with
`apply_rope1` from `comfy.ldm.flux.math`. The nunchaku v1.2.1 custom node still imports the
old symbol, causing an `ImportError` at startup. The replacement file from
https://github.com/nunchaku-ai/ComfyUI-nunchaku/issues/820 removes this dependency.
