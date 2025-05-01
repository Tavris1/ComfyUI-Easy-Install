# ComfyUI-Easy-Install  
> Portable installation of ComfyUI for **Windows** and **macOS** 🔹 Pixaroma Community Edition 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install?tab=readme-ov-file#installation-steps)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> ![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total)
>
> Dedicated to the **Pixaroma** team  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)  
---

## Basic software included  
- **Git**  
- **ComfyUI portable**  

## Nodes from Pixaroma tutorials included  
- ComfyUI-Manager  
- was-node-suite  
- Easy-Use  
- controlnet_aux  
- Comfyroll Studio  
- Crystools  
- rgthree  
- GGUF  
- Florence2  
- Searge_LLM  
- ControlAltAI-Nodes  
- Ollama  
- iTools  
- seamless-tiling  
- Inpaint-CropAndStitch  
- canvas_tab  
- OmniGen  
- Inspyrenet-Rembg  
- AdvancedReduxControl  
- VideoHelperSuite  
- AdvancedLivePortrait  
- ComfyUI-ToSVG  
- Kokoro  
- Janus-Pro  
- Sonic  
- TeaCache  
- KayTool  

---

## Installation Steps for Windows:  

1. Download the latest release [>> HERE <<](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip).  
2. Extract the ZIP file into a new folder.  
**Important:** Do **not** extract to system folders such as **`Program Files`**, **`Windows`**, or directly to **`C:\`**.  
3. Run **`ComfyUI-Easy-Install.bat`**  
> - This installation won't affect existing ComfyUI installs. Multiple ComfyUIs are supported.
> - After installation, you can rename or move **`ComfyUI-Easy-Install`** folder if needed.

### Tips for Existing Installations:  
- To preserve settings from other ComfyUI installations, place the following files in the same folder as the installer.  
They will be copied automatically to the appropriate folders:  
      - `run_nvidia_gpu.bat`  
      - `extra_model_paths.yaml` (refer to **Extra Model Paths Maker 🔥**)  
      - `comfy.settings.json` (user/default)  
      - `was_suite_config.json` (custom_nodes/was-node-suite-comfyui)  
      - `rgthree_config.json` (custom_nodes/rgthree-comfy)  

---

### Extra Model Paths Maker 🔥  

1. Place **Extra_Model_Paths_Maker.bat** in your existing **models** folder and run it.  
       - This generates an organized `extra_model_paths.yaml` listing all subfolders in the directory.  
2. Move `extra_model_paths.yaml` to your new **ComfyUI** folder.  
       - This allows ComfyUI to use your existing model files without additional downloads.  

> - Some folders like **LLM** and **llm_gguf** cannot be redirected this way.  

---

## macOS Installation and Optimization
*(thanks to [@VenimK](https://github.com/VenimK))*

### Installation Steps for macOS

1. Clone or download this repository
2. Run `chmod +x ComfyUI-Easy-Install.sh` to make the installation script executable
3. Execute `./ComfyUI-Easy-Install.sh` to install ComfyUI and its dependencies
4. After installation completes, run `./run_comfyui.sh` to start ComfyUI

### Mac M1/M2 Optimization

The `run_comfyui.sh` script includes several optimizations specifically for Apple Silicon (M1/M2) Macs:

#### Memory Management
- Memory clearing before startup to ensure maximum available RAM
- Optimized garbage collection settings
- Configurable high/low watermark ratios for MPS (Metal Performance Shaders)

#### Performance Enhancements
- MPS graph mode enabled for better performance
- Descriptor caching for improved speed
- Unified memory support for better memory utilization

#### Compatibility Settings
- FP32 accumulation for improved precision
- Force-upcast attention for better stability
- Float8 disabled (not supported on MPS)

### Troubleshooting Common Issues

#### Import Failures
Some custom nodes may fail to import due to:
- Dependencies not compatible with Apple Silicon
- Python package version conflicts
- Hyphenated directory names causing import issues

If you encounter import failures, check the console output for the specific node causing the issue and consider removing it if not essential to your workflow.

#### Memory Issues
If you experience out-of-memory errors:
1. Adjust the `PYTORCH_MPS_HIGH_WATERMARK_RATIO` and `PYTORCH_MPS_LOW_WATERMARK_RATIO` values in `run_comfyui.sh`
2. Use smaller model sizes when possible
3. Reduce batch sizes in your workflows

#### Performance Optimization
For best performance on Mac M1/M2:
- Use GGUF models instead of other quantization formats
- Consider using smaller models (7B instead of 13B for LLMs, etc.)
- Avoid nodes that require CPU-intensive operations

### Extra Model Paths for macOS

To use models from existing folders on your Mac:

1. Create an `Extra_Model_Paths_Maker.sh` script with the following content:

```bash
#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Output file path
OUTPUT_FILE="$SCRIPT_DIR/extra_model_paths.yaml"

# Start writing to the file
echo "# This file was generated by Extra_Model_Paths_Maker.sh" > "$OUTPUT_FILE"
echo "# It maps model folder names to their full paths" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "paths:" >> "$OUTPUT_FILE"

# Find all immediate subdirectories and add them to the file
find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
    # Get the basename of the directory
    base_name=$(basename "$dir")
    
    # Skip hidden directories (those starting with a dot)
    if [[ "$base_name" == .* ]]; then
        continue
    fi
    
    # Add the directory to the YAML file
    echo "    $base_name: $dir/" >> "$OUTPUT_FILE"
done

echo "\nExtra model paths file created at: $OUTPUT_FILE"
echo "You can now copy this file to your ComfyUI folder."
```

2. Place this script in your existing models folder and make it executable:
   ```bash
   chmod +x Extra_Model_Paths_Maker.sh
   ```

3. Run the script:
   ```bash
   ./Extra_Model_Paths_Maker.sh
   ```

4. Copy the generated `extra_model_paths.yaml` to your ComfyUI folder:
   ```bash
   cp extra_model_paths.yaml /path/to/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI/
   ```

> This allows ComfyUI to use your existing model files without duplicating them.
---

## Screenshot  
![End](https://github.com/user-attachments/assets/da090bd5-0e13-41e1-8a81-bf2d24a8632c)  

<div align="center">

### Support me on PayPal
[![Support me on-Paypal-blue](https://github.com/user-attachments/assets/c1a767b0-f3d9-48c7-877b-12653d2f9ac7)](https://paypal.me/tavris1)  
</div>
