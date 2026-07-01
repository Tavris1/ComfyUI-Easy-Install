<div align="center">

# ComfyUI-Easy-Install

Portable **ComfyUI** for **macOS** and **Linux** 🔹 Pixaroma Community Edition  
[![GitHub Release](https://img.shields.io/github/v/release/Tavris1/ComfyUI-Easy-Install)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)
[![GitHub Release Date](https://img.shields.io/github/release-date/Tavris1/ComfyUI-Easy-Install?style=flat)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/total.svg)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases)
[![GitHub Downloads Latest](https://img.shields.io/github/downloads/Tavris1/ComfyUI-Easy-Install/latest/total?style=flat&label=⬇+latest&color=orange)](https://github.com/Tavris1/ComfyUI-Easy-Install/releases/latest/download/ComfyUI-Easy-Install.zip)

Dedicated to the **Pixaroma** team  
[![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscord.com%2Fapi%2Finvites%2FgggpkVgBf3%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&logo=discord&logoColor=white&label=Join%20Pixaroma%20Discord&color=FFDF00&suffix=%20users)](https://discord.com/invite/gggpkVgBf3)

</div>

---

## 📦 Included Components

<details>
<summary><b>Core Components</b></summary>

| 🔧 Component | 📝 Note |
|---|---|
| [Git](https://git-scm.com/) | ![Git version](https://img.shields.io/github/v/tag/git/git?label=&display_name=tag&color=blue) - Latest (will install/update if needed) |
| [Python](https://www.python.org/downloads/release/python-31210/) | ![Python version](https://img.shields.io/badge/3.12.10-blue) - Built from source |
| [ComfyUI](https://github.com/Comfy-Org/ComfyUI) | ![ComfyUI version](https://img.shields.io/github/v/release/Comfy-Org/ComfyUI?label=&display_name=tag) - Latest version |

</details>

<details>
<summary><b>Nodes from Pixaroma tutorials</b></summary>

| 🖼️ Image | 🎬 Video | 🎵 Audio | 🧩 Utility / WF | 🤖 Models |
|---|---|---|---|---|
| [Tiled Diffusion & VAE](https://github.com/shiimizu/ComfyUI-TiledDiffusion) | [VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | [MelBandRoFormer](https://github.com/kijai/ComfyUI-MelBandRoFormer) | [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) | [QwenVL](https://github.com/1038lab/ComfyUI-QwenVL) |
| [Inpaint CropAndStitch](https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch) | [WanVideoWrapper](https://github.com/kijai/ComfyUI-WanVideoWrapper) | [Qwen3-TTS](https://github.com/flybirdxx/ComfyUI-Qwen-TTS) | [Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | [GGUF](https://github.com/city96/ComfyUI-GGUF) |
| [ControlNet Aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | [WanAnimatePreprocess](https://github.com/kijai/ComfyUI-WanAnimatePreprocess) | | [KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | |
| [LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | [SeedVR2 VideoUpscaler](https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler) | | [rgthree](https://github.com/rgthree/rgthree-comfy) | |
| [RMBG](https://github.com/1038lab/ComfyUI-RMBG) | | | [iTools](https://github.com/MohammadAboulEla/ComfyUI-iTools) | |
| [Easy-Sam3](https://github.com/yolain/ComfyUI-Easy-Sam3) | | | [ControlAltAI Nodes](https://github.com/gseth/ControlAltAI-Nodes) | |
| [SCAIL-Pose](https://github.com/kijai/ComfyUI-SCAIL-Pose) | | | [TeaCache](https://github.com/welltop-cn/ComfyUI-TeaCache) | |
| [Krea2T-Enhancer](https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer) | | | | |

</details>

<details>
<summary><b>Optional Add-ons Nodes and Tools</b></summary>

| 🧩 Nodes | 🛠️ Tools |
|---|---|
| [Nunchaku](https://github.com/nunchaku-ai/nunchaku) | Easy-Models-Linker |
| [SageAttention (v2.2.0)](https://github.com/woct0rdho/SageAttention) | ComfyUI-Version-Switcher |
| [FlashAttention](https://github.com/Dao-AILab/flash-attention) | Backup ComfyUI |
| [InsightFace](https://github.com/deepinsight/insightface) | Torch-Pack |
| [Trellis 2.0](https://github.com/visualbruno/ComfyUI-Trellis2) | |

</details>

## 🍎 macOS Installation

1. Clone this repository:
   ```bash
   git clone --single-branch --branch MAC-Linux https://github.com/Tavris1/ComfyUI-Easy-Install.git
   ```
2. Make the script executable and run it:
   ```bash
   cd ComfyUI-Easy-Install
   chmod +x ComfyUI-Easy-Install.sh
   ./ComfyUI-Easy-Install.sh
   ```
3. After installation, start ComfyUI:
   ```bash
   cd ComfyUI-Easy-Install
   ./run_mac_mps.sh
   ```
4. After setup, you can install the following from the **Add-ons** folder:
    - **Easy-Models-Linker** - *Uses existing **MODELS** folder via **extra_model_paths.yaml**, no re-download needed*
      - *Some folders like **LLM** and **llm_gguf** cannot be redirected this way*
    - **Nunchaku** - *Installs Nunchaku*
    - **SageAttention** - *Installs SageAttention v2.2.0*
    - **InsightFace** - *Installs InsightFace (Pretrained models for non-commercial research only)*
    - **Trellis2** - *Installs Trellis 2.0*
    - **Torch-Pack** - *Quick switching between: `Torch 2.7.1+cu128`, `Torch 2.8.0+cu128`, `Torch 2.9.1+cu130` and `Torch 2.10.0+cu130`*
    - **ComfyUI-Version-Switcher** - ***Reversible** rollback to a **previous** ComfyUI version on issues*
    - **Backup ComfyUI** - *Backup, restore, and manage your ComfyUI data folders*

<details>
<summary><b>Mac M1/M2 Optimization</b></summary>

The `run_mac_mps.sh` script includes optimizations for Apple Silicon (M1/M2) Macs:

- **Memory Management** - Memory clearing, optimized GC, configurable MPS watermark ratios
- **Performance** - MPS graph mode, descriptor caching, unified memory support
- **Compatibility** - FP32 accumulation, force-upcast attention, Float8 disabled (unsupported on MPS)

</details>

<details>
<summary><b>Troubleshooting macOS</b></summary>

- **Import Failures** - Some nodes may fail due to Apple Silicon incompatibility. Check console output and remove non-essential nodes.
- **Memory Issues** - Adjust `PYTORCH_MPS_HIGH_WATERMARK_RATIO` / `PYTORCH_MPS_LOW_WATERMARK_RATIO` in `run_mac_mps.sh`, use smaller models, reduce batch sizes.
- **Performance** - Use GGUF models, prefer smaller models (7B over 13B), avoid CPU-intensive nodes.

</details>

> [!TIP]
> - Multiple ComfyUI installs allowed without conflicts.
> - You can rename/move `ComfyUI-Easy-Install` folder after installation.

---

## 🐧 Linux and Proxmox Installation

<details>
<summary><b>Standard Linux Installation</b></summary>

1. Clone this repository:
   ```bash
   git clone -b MAC-Linux --single-branch https://github.com/Tavris1/ComfyUI-Easy-Install.git
   ```
2. Make the script executable and run it:
   ```bash
   cd ComfyUI-Easy-Install
   chmod +x ComfyUI-Easy-Install.sh
   ./ComfyUI-Easy-Install.sh
   ```
3. After installation, start ComfyUI:
   ```bash
   cd ComfyUI-Easy-Install
   ./run_nvidia_gpu.sh
   ```

</details>

<details>
<summary><b>Proxmox LXC Container Setup</b></summary>

1. Clone this repository:
   ```bash
   git clone -b MAC-Linux --single-branch https://github.com/Tavris1/ComfyUI-Easy-Install.git
   ```
2. Make all scripts executable:
   ```bash
   cd ComfyUI-Easy-Install
   chmod +x *.sh
   ```
3. Setup Container - Install ComfyUI in the container - GPU Passthrough:
   ```bash
   ./comfyui-lxc-standalone.sh
   ```

**Hardware Requirements**: At least 8GB RAM · NVMe SSD recommended · GPU passthrough (optional)

</details>

<details>
<summary><b>Troubleshooting Linux / Proxmox</b></summary>

> For Linux/Proxmox support, contact [@VenimK](https://discord.com/users/venimk) on Discord

- **Permission Errors**: `chmod -R 755 ComfyUI-Easy-Install`
- **Performance**: Use NVMe for model storage, configure container resources, consider GPU passthrough

</details>

> [!NOTE]
> The Proxmox setup automatically configures most settings, but you may need to adjust container resources based on your needs.

> [!TIP]
> - [**For Windows installation click here**](https://github.com/Tavris1/ComfyUI-Easy-Install)

<details>
<summary><b>Backup ComfyUI</b></summary>

A small interactive utility to back up, restore, and manage your ComfyUI data folders.

- **Script**: `Add-Ons/backup_comfyui.sh`
- **Version**: V2.01.3 (Pixaroma Community Edition, macOS/Linux by VenimK)
- **Backup location**: `~/ComfyUI_Backups/ComfyUI_backup_YYYYMMDD_HHMMSS`
- **What gets backed up**: `user`, `input`, `output` (always) · `models` (optional)

```bash
bash Add-Ons/backup_comfyui.sh
```

</details>

---

## 🖥️ EZi Desktop (Native Window Mode)

Run ComfyUI in a native desktop window instead of a browser:

```bash
./run_comfyui_desktop.sh
```

| ⌨️ Action | 🍎 macOS | 🐧 Linux |
|---|---|---|
| Open Desktop Settings panel | `Cmd+Shift+I` | `Ctrl+Shift+I` |
| Open ComfyUI in browser | `Cmd+B` | `Ctrl+B` |

> [!NOTE]
> On Linux, pywebview requires a GTK or Qt backend. The launcher will attempt to install it automatically. If it fails, run:
> ```bash
> # GTK (recommended for Ubuntu/Pop!_OS/Debian)
> sudo apt-get install python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.1
> SYS_GI=$(python3 -c "import gi,os; print(os.path.dirname(gi.__file__))")
> ln -s "$SYS_GI" "$(./python_embeded/python -c "import site; print(site.getsitepackages()[0])")/gi"
>
> # Qt alternative (no sudo needed)
> ./python_embeded/python -m pip install PyQt6 qtpy
> ```

---

<div align="center">

## ❤️ Support Me
Enjoy my projects? Any support is greatly appreciated!

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/VenimK)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white)](https://github.com/sponsors/venimK)

</div>

