# ComfyUI-Easy-Install  (NEXT version)
> Portable **ComfyUI** for **Windows**, **macOS** and **Linux**  🔹 Pixaroma Community Edition 🔹  
> [![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
> [![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
> [![Github All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)]()
> [![GitHub Downloads latest)](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=downloads%40latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
>
> Dedicated to the **Pixaroma** team  
> [![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)  
---

## What will be installed  
- [**Git**](https://git-scm.com/) will be installed/updated if required  
- [**ComfyUI portable**](https://github.com/comfyanonymous/ComfyUI)  
- [**Python 3.12.10 Embedded**](https://www.python.org/downloads/release/python-31210/)

## Nodes from Pixaroma tutorials on [:arrow_forward:YouTube](https://www.youtube.com/@pixaroma)  

|||||
|---|---|---|---|
|01. [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager)|02. [WAS-Node-Suite](https://github.com/WASasquatch/was-node-suite-comfyui)|03. [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use)|04. [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux)|
|05. [Comfyroll Studio](https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes)|06. [Crystools](https://github.com/crystian/ComfyUI-Crystools)|07. [rgthree](https://github.com/rgthree/rgthree-comfy)|08. [GGUF](https://github.com/city96/ComfyUI-GGUF)|
|09. [Florence2](https://github.com/kijai/ComfyUI-Florence2)|10. [Searge_LLM](https://github.com/SeargeDP/ComfyUI_Searge_LLM)|11. [ControlAltAI-Nodes](https://github.com/gseth/ControlAltAI-Nodes)|12. [Ollama](https://github.com/stavsap/comfyui-ollama)|
|13. [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools)|14. [seamless-tiling](https://github.com/spinagon/ComfyUI-seamless-tiling)|15. [Inpaint-CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch)|16. [canvas_tab](https://github.com/Lerc/canvas_tab)|
|17. [OmniGen](https://github.com/1038lab/ComfyUI-OmniGen)|18. [Inspyrenet-Rembg](https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg)|19. [AdvancedReduxControl](https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl)|20. [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite)|
|21. [AdvancedLivePortrait](https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait)|22. [ComfyUI-ToSVG](https://github.com/Yanick112/ComfyUI-ToSVG)|23. [Kokoro](https://github.com/stavsap/comfyui-kokoro)|24. [Janus-Pro](https://github.com/CY-CHENYUE/ComfyUI-Janus-Pro)|
|25. [Sonic](https://github.com/smthemex/ComfyUI_Sonic)|26. [TeaCache](https://github.com/welltop-cn/ComfyUI-TeaCache)|27. [KayTool](https://github.com/kk8bit/KayTool)|28. [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion)|
|29. [LTXVideo](https://github.com/Lightricks/ComfyUI-LTXVideo)|30. [KJNodes](https://github.com/kijai/ComfyUI-KJNodes)|31. [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper)|32. [VibeVoice](https://github.com/Enemyx-net/VibeVoice-ComfyUI)|
|Optional **Add-ons**|
|01. [Nunchaku](https://github.com/mit-han-lab/ComfyUI-nunchaku)|02. [SageAttention 2.2.0](https://github.com/thu-ml/SageAttention)|03. [InsightFace](https://github.com/deepinsight/insightface)|Easy-Models-Linker :fire:|

---

## Optional **Add-ons**  
- [Nunchaku](https://github.com/mit-han-lab/ComfyUI-nunchaku)  
  - Stable and Dev versions. Install the Dev version first. Use Stable if problems occur.
- [SageAttention 2.2.0](https://github.com/thu-ml/SageAttention)
- [InsightFace](https://github.com/deepinsight/insightface)  
  - MIT License - pretrained models for non-commercial research only.

---

## macOS Installation and Optimization

### Installation Steps for macOS

1. Clone or download this repository

   git clone --single-branch --branch MAC-Linux https://github.com/Tavris1/ComfyUI-Easy-Install.git

   cd ComfyUI-Easy-Install

2. Run `chmod +x ComfyUI-Easy-Install.sh` to make the installation script executable

3. Execute `./ComfyUI-Easy-Install.sh` to install ComfyUI and its dependencies

4. After installation completes, run `./run_mac_mps.sh` to start ComfyUI (On M1/M2 Macs)

5. After installation completes, run `./run_nvidia_gpu.sh` to start ComfyUI (On Linux)

### Mac M1/M2 Optimization

The `run_mac_mps.sh` script includes several optimizations specifically for Apple Silicon (M1/M2) Macs:

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
1. Adjust the `PYTORCH_MPS_HIGH_WATERMARK_RATIO` and `PYTORCH_MPS_LOW_WATERMARK_RATIO` values in `run_mac_mps.sh`
2. Use smaller model sizes when possible
3. Reduce batch sizes in your workflows

#### Performance Optimization
For best performance on Mac M1/M2:
- Use GGUF models instead of other quantization formats
- Consider using smaller models (7B instead of 13B for LLMs, etc.)
- Avoid nodes that require CPU-intensive operations

### Extra Model Paths for macOS

To use models from existing folders on your Mac:

1. Create an `Easy-Models-Linker.sh` script with the following content:



## Linux and Proxmox Installation
<details>
<summary>Installation and Container Setup</summary>

### Standard Linux Installation
1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x ComfyUI-Easy-Install.sh
   ```
3. Run the installation script:
   ```bash
   ./ComfyUI-Easy-Install.sh
   ```

### Proxmox LXC Container Setup
1. Clone or download this repository
2. Make all scripts executable:
   ```bash
   chmod +x *.sh
   ```
3. Install ComfyUI in the container:
   ```bash
   ./ComfyUI-Easy-Install.sh
   ```

### Container Configuration
- **Hardware Requirements**:
  - At least 8GB RAM
  - NVMe SSD recommended
  - GPU passthrough (optional)


### Troubleshooting

> For Linux/Proxmox support, contact [@VenimK](https://discord.com/users/venimk) on Discord

#### Common Issues
1. **Permission Errors**:
   ```bash
   # Fix permissions in container
   chmod -R 755 ComfyUI-Easy-Install
   ```
#### Performance Optimization
- Use a NVMe drive for model storage
- Configure appropriate container resources
- Consider GPU passthrough for better performance

> [!NOTE]
> The Proxmox setup automatically configures most settings, but you may need to adjust container resources based on your needs.

</details>

## For Windows installation - click [:arrow_forward:HERE](https://github.com/Tavris1/ComfyUI-Easy-Install)

---
